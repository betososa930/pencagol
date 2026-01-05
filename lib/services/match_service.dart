import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/match_model.dart';

class MatchService {
  static final MatchService instance = MatchService._();
  MatchService._();

  final _firestore = FirebaseFirestore.instance;

  // Cargar todos los partidos del Mundial 2026
  Future<List<MatchModel>> getWorldCupMatches() async {
    try {
      final snapshot =
          await _firestore.collection('matches').orderBy('date').get();

      return snapshot.docs
          .map((doc) => MatchModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al cargar partidos: $e');
    }
  }

  // Obtener partidos por grupo
  Future<List<MatchModel>> getMatchesByGroup(String group) async {
    try {
      final snapshot = await _firestore
          .collection('matches')
          .where('group', isEqualTo: group)
          .orderBy('date')
          .get();

      return snapshot.docs
          .map((doc) => MatchModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al cargar partidos del grupo: $e');
    }
  }

  // Obtener todos los partidos en los que participa Argentina
  Stream<List<MatchModel>> getArgentinaMatches() {
    return _firestore
        .collection('matches')
        .where('group', isEqualTo: 'J')
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MatchModel.fromMap(doc.data()))
            .toList());
  }

  // Guardar todos los partidos del mundial (ejecutar una sola vez)
  Future<void> loadWorldCupFixture() async {
    try {
      final matches = _generateWorldCupMatches();

      for (var match in matches) {
        await _firestore.collection('matches').doc(match.id).set(match.toMap());
      }
    } catch (e) {
      throw Exception('Error al cargar fixture: $e');
    }
  }

  // Generar todos los partidos del mundial 2026
  List<Match> _generateWorldCupMatches() {
    return [
      // GRUPO A
      Match(
        id: 'G1M1',
        groupName: 'A',
        matchNumber: '1',
        date: '2026-06-11',
        time: '16:00',
        team1: 'México',
        team2: 'Sudáfrica',
        stadium: 'Estadio Ciudad de México',
        matchDay: 'Jueves',
        isKnockout: false,
      ),
      // ... (continúa con todos los demás partidos)
    ];
  }
}

class Match {
  final String id;
  final String groupName;
  final String matchNumber;
  final String date;
  final String time;
  final String team1;
  final String team2;
  final String stadium;
  final String matchDay;
  final bool isKnockout;

  Match({
    required this.id,
    required this.groupName,
    required this.matchNumber,
    required this.date,
    required this.time,
    required this.team1,
    required this.team2,
    required this.stadium,
    required this.matchDay,
    required this.isKnockout,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupName': groupName,
      'matchNumber': matchNumber,
      'date': date,
      'time': time,
      'team1': team1,
      'team2': team2,
      'stadium': stadium,
      'matchDay': matchDay,
      'isKnockout': isKnockout,
    };
  }

  factory Match.fromMap(Map<String, dynamic> map) {
    return Match(
      id: map['id'] ?? '',
      groupName: map['groupName'] ?? '',
      matchNumber: map['matchNumber'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      team1: map['team1'] ?? '',
      team2: map['team2'] ?? '',
      stadium: map['stadium'] ?? '',
      matchDay: map['matchDay'] ?? '',
      isKnockout: map['isKnockout'] ?? false,
    );
  }
}
