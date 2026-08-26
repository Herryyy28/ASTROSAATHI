import 'game_plan_data.dart';

class MuhuratResult {
  final String category;
  final TimeWindow bestWindow;
  final String strength;
  final String bestFor;
  final TimeWindow? avoidWindow;

  MuhuratResult({
    required this.category,
    required this.bestWindow,
    required this.strength,
    required this.bestFor,
    this.avoidWindow,
  });
}

class MuhuratInput {
  final String date;
  final String location;
  final String category;

  MuhuratInput({
    required this.date,
    required this.location,
    required this.category,
  });
}
