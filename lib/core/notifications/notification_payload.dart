class NotificationPayload {
  final String type;
  final String? transactionId;
  final String? captureId;

  const NotificationPayload({
    required this.type,
    this.transactionId,
    this.captureId,
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      type: json['type'] as String? ?? '',
      transactionId: json['transactionId'] as String?,
      captureId: json['captureId'] as String?,
    );
  }

  factory NotificationPayload.fromMap(Map<String, dynamic> map) {
    return NotificationPayload(
      type: map['type'] as String? ?? '',
      transactionId: map['transactionId'] as String?,
      captureId: map['captureId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        if (transactionId != null) 'transactionId': transactionId,
        if (captureId != null) 'captureId': captureId,
      };
}
