import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/firebase_providers.dart';
import '../../../shared/providers/user_provider.dart';
import '../data/tutorial_steps_provider.dart';
import '../domain/tutorial_step.dart';

class TutorialState {
  final bool isActive;
  final int currentStep;
  final int totalSteps;
  final TutorialRole? role;
  final bool isCompleted;

  const TutorialState({
    required this.isActive,
    required this.currentStep,
    required this.totalSteps,
    this.role,
    required this.isCompleted,
  });

  TutorialState copyWith({
    bool? isActive,
    int? currentStep,
    int? totalSteps,
    TutorialRole? role,
    bool? isCompleted,
  }) {
    return TutorialState(
      isActive: isActive ?? this.isActive,
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
      role: role ?? this.role,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class TutorialController extends Notifier<TutorialState> {
  @override
  TutorialState build() {
    return const TutorialState(
      isActive: false,
      currentStep: 1,
      totalSteps: 0,
      role: null,
      isCompleted: false,
    );
  }

  bool isTutorialNeeded() {
    final data = ref.read(userDocProvider).value?.data();
    if (data == null) return false;
    return !(data['tutorialCompleted'] as bool? ?? false);
  }

  void startTutorial(TutorialRole role) {
    final steps = ref.read(tutorialStepsProvider(role));
    state = TutorialState(
      isActive: true,
      currentStep: 1,
      totalSteps: steps.length,
      role: role,
      isCompleted: false,
    );
    _logStepViewed(1);
  }

  void nextStep() {
    if (!state.isActive) return;
    if (state.currentStep >= state.totalSteps) {
      if (state.role != null) {
        complete(state.role!);
      }
      return;
    }
    final next = state.currentStep + 1;
    state = state.copyWith(currentStep: next);
    _logStepViewed(next);
  }

  Future<void> skip() async {
    final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
    state = state.copyWith(isActive: false, isCompleted: true);
    if (uid != null) {
      await ref.read(firestoreProvider).collection('users').doc(uid).set(
        {'tutorialCompleted': true},
        SetOptions(merge: true),
      );
    }
    // TODO(pocketplus-analytics): log tutorial-skipped (wired in services task).
  }

  Future<void> complete(TutorialRole role) async {
    final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
    state = state.copyWith(isActive: false, isCompleted: true);
    if (uid != null) {
      await ref.read(firestoreProvider).collection('users').doc(uid).set(
        {'tutorialCompleted': true, 'tutorialRole': role.firestoreValue},
        SetOptions(merge: true),
      );
    }
    // TODO(pocketplus-analytics): log tutorial-completed (wired in services task).
  }

  void _logStepViewed(int stepNumber) {
    // TODO(pocketplus-analytics): log tutorial-step-viewed (wired in services task).
  }
}

final tutorialControllerProvider =
    NotifierProvider<TutorialController, TutorialState>(
  TutorialController.new,
);
