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
}

class ChatMessage {
  final String text;
  final bool isUser;
  final AstroBabaResponse? aiData;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.aiData,
  });
}
