/**
 * PocketPlus Firestore security rules tests.
 *
 * Run with the emulator:  npm run test:emulator
 * (or, with an emulator already running on 8080:  npm test)
 *
 * Invariants under test:
 *  - every owner-scoped collection is readable/writable only by its owner
 *  - no client can ever delete financial data (soft-delete only)
 *  - cross-tenant access is denied even for authenticated users
 *  - doc-id-prefix collections (invoice_counters, sms_dedup_log) are scoped
 *    to the uid prefix
 *  - feedback is write-only for clients
 */

const { readFileSync } = require('fs');
const { resolve } = require('path');
const assert = require('assert');
const {
  initializeTestEnvironment,
  assertSucceeds,
  assertFails,
} = require('@firebase/rules-unit-testing');
const {
  doc,
  collection,
  getDoc,
  getDocs,
  setDoc,
  updateDoc,
  deleteDoc,
  query,
  where,
} = require('firebase/firestore');

const PROJECT_ID = 'demo-pocketplus';
const ALICE = 'alice_uid';
const MALLORY = 'mallory_uid';

/** Collections that follow the owner-scoped userId pattern. */
const OWNER_COLLECTIONS = [
  'profiles',
  'budgets',
  'transactions',
  'categories',
  'invoices',
  'khata_customers',
  'khata_entries',
  'savings_goals',
  'savings_entries',
];

let testEnv;

before(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: {
      rules: readFileSync(resolve(__dirname, '../firestore.rules'), 'utf8'),
    },
  });
});

after(async () => {
  await testEnv.cleanup();
});

beforeEach(async () => {
  await testEnv.clearFirestore();
});

function db(uid) {
  return uid
    ? testEnv.authenticatedContext(uid).firestore()
    : testEnv.unauthenticatedContext().firestore();
}

/** Seed a doc bypassing rules. */
async function seed(path, data) {
  await testEnv.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), path), data);
  });
}

describe('users collection', () => {
  it('owner can read and write their own user doc', async () => {
    await assertSucceeds(
      setDoc(doc(db(ALICE), 'users', ALICE), { name: 'Alice' }),
    );
    await assertSucceeds(getDoc(doc(db(ALICE), 'users', ALICE)));
  });

  it('another user cannot read or write it', async () => {
    await seed(`users/${ALICE}`, { name: 'Alice' });
    await assertFails(getDoc(doc(db(MALLORY), 'users', ALICE)));
    await assertFails(
      updateDoc(doc(db(MALLORY), 'users', ALICE), { name: 'pwned' }),
    );
  });

  it('user docs can never be deleted', async () => {
    await seed(`users/${ALICE}`, { name: 'Alice' });
    await assertFails(deleteDoc(doc(db(ALICE), 'users', ALICE)));
  });

  it('unauthenticated access is denied', async () => {
    await seed(`users/${ALICE}`, { name: 'Alice' });
    await assertFails(getDoc(doc(db(null), 'users', ALICE)));
  });
});

describe('owner-scoped financial collections', () => {
  for (const col of OWNER_COLLECTIONS) {
    describe(col, () => {
      it('owner can create, read, and update', async () => {
        const ref = doc(db(ALICE), col, 'doc1');
        await assertSucceeds(setDoc(ref, { userId: ALICE, amount: 100 }));
        await assertSucceeds(getDoc(ref));
        await assertSucceeds(updateDoc(ref, { amount: 200 }));
      });

      it('cannot create a doc owned by someone else', async () => {
        await assertFails(
          setDoc(doc(db(MALLORY), col, 'doc1'), { userId: ALICE, amount: 1 }),
        );
      });

      it('another user cannot read or update', async () => {
        await seed(`${col}/doc1`, { userId: ALICE, amount: 100 });
        await assertFails(getDoc(doc(db(MALLORY), col, 'doc1')));
        await assertFails(
          updateDoc(doc(db(MALLORY), col, 'doc1'), { amount: 0 }),
        );
      });

      it('hard delete is denied even for the owner', async () => {
        await seed(`${col}/doc1`, { userId: ALICE, amount: 100 });
        await assertFails(deleteDoc(doc(db(ALICE), col, 'doc1')));
      });

      it('owner soft-delete (update with deletedAt) is allowed', async () => {
        await seed(`${col}/doc1`, { userId: ALICE, amount: 100 });
        await assertSucceeds(
          updateDoc(doc(db(ALICE), col, 'doc1'), {
            isDeleted: true,
            deletedAt: new Date(),
          }),
        );
      });
    });
  }
});

describe('invoice_counters (doc id = {userId}_{profileId})', () => {
  it('owner can read/write their own counter', async () => {
    await assertSucceeds(
      setDoc(doc(db(ALICE), 'invoice_counters', `${ALICE}_profile1`), {
        next: 1,
      }),
    );
  });

  it('another user cannot touch it', async () => {
    await seed(`invoice_counters/${ALICE}_profile1`, { next: 5 });
    await assertFails(
      getDoc(doc(db(MALLORY), 'invoice_counters', `${ALICE}_profile1`)),
    );
    await assertFails(
      setDoc(doc(db(MALLORY), 'invoice_counters', `${ALICE}_profile1`), {
        next: 999,
      }),
    );
  });
});

describe('sms_dedup_log (doc id = {userId}_{smsHash})', () => {
  it('owner can read/write their own dedup entries', async () => {
    await assertSucceeds(
      setDoc(doc(db(ALICE), 'sms_dedup_log', `${ALICE}_abc123`), {
        createdAt: new Date(),
      }),
    );
    await assertSucceeds(
      getDoc(doc(db(ALICE), 'sms_dedup_log', `${ALICE}_abc123`)),
    );
  });

  it("cannot read or write another user's entries", async () => {
    await seed(`sms_dedup_log/${ALICE}_abc123`, { createdAt: new Date() });
    await assertFails(
      getDoc(doc(db(MALLORY), 'sms_dedup_log', `${ALICE}_abc123`)),
    );
    await assertFails(
      setDoc(doc(db(MALLORY), 'sms_dedup_log', `${ALICE}_abc123`), {}),
    );
  });
});

describe('usernames (public username -> account index)', () => {
  it('anyone (even unauthenticated) can get a username doc by id', async () => {
    await seed('usernames/alice', { uid: ALICE, email: 'a@x.com' });
    await assertSucceeds(getDoc(doc(db(null), 'usernames', 'alice')));
    await assertSucceeds(getDoc(doc(db(MALLORY), 'usernames', 'alice')));
  });

  it('cannot be listed/enumerated', async () => {
    await seed('usernames/alice', { uid: ALICE, email: 'a@x.com' });
    await assertFails(getDocs(collection(db(null), 'usernames')));
    await assertFails(
      getDocs(query(collection(db(MALLORY), 'usernames'), where('uid', '==', ALICE))),
    );
  });

  it('a signed-in user can claim a username pointing to their own uid', async () => {
    await assertSucceeds(
      setDoc(doc(db(ALICE), 'usernames', 'alice'), {
        uid: ALICE,
        email: 'a@x.com',
        username: 'alice',
      }),
    );
  });

  it('cannot claim a username pointing at someone else', async () => {
    await assertFails(
      setDoc(doc(db(MALLORY), 'usernames', 'victim'), {
        uid: ALICE,
        email: 'a@x.com',
      }),
    );
  });

  it('is immutable once claimed (no reassignment or delete)', async () => {
    await seed('usernames/alice', { uid: ALICE, email: 'a@x.com' });
    // Even the owner cannot overwrite or delete it.
    await assertFails(
      setDoc(doc(db(ALICE), 'usernames', 'alice'), { uid: ALICE, email: 'b@x.com' }),
    );
    await assertFails(deleteDoc(doc(db(ALICE), 'usernames', 'alice')));
    // And another user certainly cannot hijack it.
    await assertFails(
      setDoc(doc(db(MALLORY), 'usernames', 'alice'), { uid: MALLORY, email: 'm@x.com' }),
    );
  });
});

describe('feedback', () => {
  it('signed-in users can submit feedback', async () => {
    await assertSucceeds(
      setDoc(doc(db(ALICE), 'feedback', 'f1'), { userId: ALICE, nps: 9 }),
    );
  });

  it('feedback is never client-readable, updatable, or deletable', async () => {
    await seed('feedback/f1', { userId: ALICE, nps: 9 });
    await assertFails(getDoc(doc(db(ALICE), 'feedback', 'f1')));
    await assertFails(updateDoc(doc(db(ALICE), 'feedback', 'f1'), { nps: 1 }));
    await assertFails(deleteDoc(doc(db(ALICE), 'feedback', 'f1')));
  });
});

describe('removed CA collections are default-denied', () => {
  for (const col of ['ca_connections', 'ca_members', 'ca_comments']) {
    it(`${col}: no read or write for any signed-in user`, async () => {
      await seed(`${col}/x`, { ownerId: ALICE, caId: MALLORY });
      await assertFails(getDoc(doc(db(MALLORY), col, 'x')));
      await assertFails(getDoc(doc(db(ALICE), col, 'x')));
      await assertFails(
        setDoc(doc(db(MALLORY), col, `${ALICE}_${MALLORY}`), {
          ownerId: ALICE,
          caId: MALLORY,
        }),
      );
    });
  }

  it('regression: minting a ca_members doc no longer grants access to transactions', async () => {
    await seed('transactions/t1', { userId: ALICE, amount: 100 });
    // The old rules let any signed-in user write ca_members/{owner}_{self}
    // and then read the owner's financial data. Both steps must now fail.
    await assertFails(
      setDoc(doc(db(MALLORY), 'ca_members', `${ALICE}_${MALLORY}`), {
        ownerId: ALICE,
        caId: MALLORY,
      }),
    );
    await assertFails(getDoc(doc(db(MALLORY), 'transactions', 't1')));
  });
});

describe('sanity', () => {
  it('loads rules successfully', () => {
    assert.ok(testEnv);
  });
});
