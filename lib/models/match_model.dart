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
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String get formattedTime {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Convertir MatchModel a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeFlag': homeFlag,
      'awayFlag': awayFlag,
      'date': date,
      'venue': venue,
      'group': group,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'isFinished': isFinished,
    };
  }

  // Crear MatchModel desde Map de Firestore
  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      homeTeam: map['homeTeam'] as String,
      awayTeam: map['awayTeam'] as String,
      homeFlag: map['homeFlag'] as String,
      awayFlag: map['awayFlag'] as String,
      date: (map['date'] as dynamic)?.toDate() ?? DateTime.now(),
      venue: map['venue'] as String,
      group: map['group'] as String,
      homeScore: map['homeScore'] as int?,
      awayScore: map['awayScore'] as int?,
      isFinished: map['isFinished'] as bool? ?? false,
    );
  }
}
