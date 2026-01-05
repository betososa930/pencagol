import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/fixture_data.dart';
import '../services/prediction_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late List<Map<String, dynamic>> allMatches;
  late Map<String, Map<String, dynamic>> predictions;

  @override
  void initState() {
    super.initState();
    allMatches = FixtureData.getAllMatches();
    predictions = {};
    _loadPredictions();
  }

  Future<void> _loadPredictions() async {
    try {
      final userPredictions =
          await PredictionService.instance.getUserPredictions();
      setState(() {
        predictions = userPredictions;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar predicciones: $e'),
            backgroundColor: AppTheme.accentOrange,
          ),
        );
      }
    }
  }

  String _formatDate(String date) {
    final months = {
      '01': 'Ene',
      '02': 'Feb',
      '03': 'Mar',
      '04': 'Abr',
      '05': 'May',
      '06': 'Jun',
      '07': 'Jul',
      '08': 'Ago',
      '09': 'Sep',
      '10': 'Oct',
      '11': 'Nov',
      '12': 'Dic'
    };
    final parts = date.split('-');
    return '${parts[2]} ${months[parts[1]]}';
  }

  String _generateMatchId(Map<String, dynamic> match, int index) {
    return '${match['group']}_${match['round']}_$index';
  }

  void _showPredictionDialog(Map<String, dynamic> match, int matchIndex) {
    final matchId = _generateMatchId(match, matchIndex);
    int? team1Score = predictions[matchId]?['team1Score'];
    int? team2Score = predictions[matchId]?['team2Score'];
    bool _isSaving = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
              '${match['flag1']} ${match['team1']} vs ${match['flag2']} ${match['team2']}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Score para Team 1
                TextField(
                  decoration: InputDecoration(
                    labelText: '${match['flag1']} ${match['team1']} goles',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.sports_soccer),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    team1Score = int.tryParse(value);
                  },
                  controller:
                      TextEditingController(text: team1Score?.toString() ?? ''),
                ),
                const SizedBox(height: 16),
                // Score para Team 2
                TextField(
                  decoration: InputDecoration(
                    labelText: '${match['flag2']} ${match['team2']} goles',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.sports_soccer),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    team2Score = int.tryParse(value);
                  },
                  controller:
                      TextEditingController(text: team2Score?.toString() ?? ''),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: _isSaving ? null : () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _isSaving
                  ? null
                  : () async {
                      if (team1Score != null && team2Score != null) {
                        setDialogState(() => _isSaving = true);
                        try {
                          await PredictionService.instance.savePrediction(
                            matchId: matchId,
                            team1Score: team1Score!,
                            team2Score: team2Score!,
                          );
                          setState(() {
                            predictions[matchId] = {
                              'team1Score': team1Score,
                              'team2Score': team2Score,
                            };
                          });
                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Predicción guardada'),
                                backgroundColor: AppTheme.primaryGreen,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error al guardar: $e'),
                                backgroundColor: AppTheme.accentOrange,
                              ),
                            );
                          }
                          setDialogState(() => _isSaving = false);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ingresa ambos resultados'),
                            backgroundColor: AppTheme.accentOrange,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentOrange,
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppTheme.white),
                      ),
                    )
                  : const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: const Text('Calendario Mundial 2026'),
        backgroundColor: AppTheme.primaryGreen,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._groupMatchesByGroup(allMatches).entries.map((entry) {
              final group = entry.key;
              final matches = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Grupo $group',
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...matches.asMap().entries.map((matchEntry) {
                    final matchIndex = matchEntry.key;
                    final match = matchEntry.value;
                    final matchId = _generateMatchId(match, matchIndex);
                    final prediction = predictions[matchId];

                    return Column(
                      children: [
                        _buildMatchCard(
                          match,
                          matchId,
                          prediction,
                          () => _showPredictionDialog(match, matchIndex),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCard(
    Map<String, dynamic> match,
    String matchId,
    Map<String, dynamic>? prediction,
    VoidCallback onPredictionTap,
  ) {
    final hasPrediction = prediction != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: hasPrediction
            ? Border.all(color: AppTheme.accentOrange, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppTheme.blackAccent.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fecha, hora y ronda
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(match['date']),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentOrange,
                ),
              ),
              Text(
                match['time'],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentOrange,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.lightGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Fecha ${match['round']}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Teams y resultado/predicción
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '${match['flag1']} ${match['team1']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.blackAccent,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    if (hasPrediction)
                      Text(
                        '${prediction['team1Score']} - ${prediction['team2Score']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.accentOrange,
                        ),
                      )
                    else
                      Text(
                        'vs',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkGrey,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  '${match['team2']} ${match['flag2']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.blackAccent,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stadium
          Text(
            match['stadium'],
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.darkGrey,
            ),
          ),
          const SizedBox(height: 12),

          // Botón de predicción
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPredictionTap,
              icon: Icon(
                hasPrediction ? Icons.edit : Icons.add,
                size: 18,
              ),
              label: Text(
                hasPrediction ? 'Editar predicción' : 'Hacer predicción',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: hasPrediction
                    ? AppTheme.accentOrange
                    : AppTheme.primaryGreen,
                foregroundColor: AppTheme.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupMatchesByGroup(
    List<Map<String, dynamic>> matches,
  ) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (var match in matches) {
      final group = match['group'] as String;
      grouped.putIfAbsent(group, () => []).add(match);
    }
    return grouped;
  }
}
