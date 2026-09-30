class AstroBabaResponse {
  final String answer;
  final String confidence;
  final List<String> actions;
  final List<String> warnings;

  AstroBabaResponse({
    required this.answer,
    required this.confidence,
    required this.actions,
    required this.warnings,
  });

  Map<String, dynamic> toJson() => {
        'answer': answer,
        'confidence': confidence,
        'actions': actions,
        'warnings': warnings,
      };

  factory AstroBabaResponse.fromJson(Map<String, dynamic> json) =>
      AstroBabaResponse(
        answer: json['answer'] as String? ?? '',
        confidence: json['confidence'] as String? ?? 'High',
        actions: (json['actions'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        warnings: (json['warnings'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );
}

class ChatMessage {
  final String text;
  final bool isUser;
  final AstroBabaResponse? aiData;
  /// True when the message is an error that the user can retry.
  final bool isError;
  /// The original user query that triggered this error (used for retry).
  final String? retryQuery;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.aiData,
    this.isError = false,
    this.retryQuery,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        'isError': isError,
        if (retryQuery != null) 'retryQuery': retryQuery,
        if (aiData != null) 'aiData': aiData!.toJson(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'] as String? ?? '',
        isUser: json['isUser'] as bool? ?? false,
        isError: json['isError'] as bool? ?? false,
        retryQuery: json['retryQuery'] as String?,
        aiData: json['aiData'] != null
            ? AstroBabaResponse.fromJson(
                json['aiData'] as Map<String, dynamic>)
            : null,
      );
}
