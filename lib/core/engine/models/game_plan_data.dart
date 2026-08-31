class TimeWindow {
  final String start;
  final String end;

  TimeWindow({required this.start, required this.end});
}

class GamePlanData {
  final String date;
  final double dayScore;
  final List<String> doList;
  final List<String> beCarefulList;
  final List<String> avoidList;
  final TimeWindow bestWindow;
  final Map<String, double> categories;
  final String? planetFactor;
  final String? houseFactor;
  final String? transitFactor;
  final String? vedicInterpretation;
  final String? practicalAction;

  GamePlanData({
    required this.date,
    required this.dayScore,
    required this.doList,
    required this.beCarefulList,
    required this.avoidList,
    required this.bestWindow,
    required this.categories,
    this.planetFactor,
    this.houseFactor,
    this.transitFactor,
    this.vedicInterpretation,
    this.practicalAction,
  });
}
