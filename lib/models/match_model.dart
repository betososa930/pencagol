class MatchModel {
  final String homeTeam;
  final String awayTeam;
  final String homeFlag;
  final String awayFlag;
  final DateTime date;
  final String venue;
  final String group;
  final int? homeScore;
  final int? awayScore;
  final bool isFinished;

  MatchModel({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeFlag,
    required this.awayFlag,
    required this.date,
    required this.venue,
    required this.group,
    this.homeScore,
    this.awayScore,
    this.isFinished = false,
  });

  String get formattedDate {
    final months = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String get formattedTime {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
