String? buildWhatsAppUrl(String? phone, String message) {
  if (phone == null || phone.isEmpty) return null;
  final encoded = Uri.encodeComponent(message);
  return 'https://wa.me/91$phone?text=$encoded';
}
