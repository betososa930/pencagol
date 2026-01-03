import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/match_model.dart';

class MatchResultCard extends StatefulWidget {
  final MatchModel match;

  const MatchResultCard({
    super.key,
    required this.match,
  });

  @override
  State<MatchResultCard> createState() => _MatchResultCardState();
}

class _MatchResultCardState extends State<MatchResultCard> {
  final TextEditingController _homeScoreController = TextEditingController();
  final TextEditingController _awayScoreController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.match.homeScore != null && widget.match.awayScore != null) {
      _homeScoreController.text = widget.match.homeScore.toString();
      _awayScoreController.text = widget.match.awayScore.toString();
    }
  }

  @override
  void dispose() {
    _homeScoreController.dispose();
    _awayScoreController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
    HapticFeedback.lightImpact();
  }

  void _saveResult() {
    final homeScore = int.tryParse(_homeScoreController.text);
    final awayScore = int.tryParse(_awayScoreController.text);

    if (homeScore != null && awayScore != null) {
      setState(() {
        _isEditing = false;
      });
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resultado guardado exitosamente'),
          backgroundColor: AppTheme.primaryGreen,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa valores válidos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header del partido
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.withOpacity(AppTheme.primaryGreen, 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.match.group,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(_isEditing ? Icons.close : Icons.edit),
                  onPressed: _toggleEdit,
                  color: AppTheme.primaryGreen,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Equipos y resultado
            Row(
              children: [
                // Equipo local
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget.match.homeFlag,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.match.homeTeam,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Resultado
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child:
                      _isEditing ? _buildScoreInputs() : _buildScoreDisplay(),
                ),

                // Equipo visitante
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget.match.awayFlag,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.match.awayTeam,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Fecha y lugar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppTheme.darkGrey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.match.formattedDate,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: AppTheme.darkGrey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.match.formattedTime,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.darkGrey,
                      ),
                    ),
                  ],
                ),
                if (widget.match.isFinished)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.withOpacity(AppTheme.primaryGreen, 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Finalizado',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppTheme.darkGrey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.match.venue,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.darkGrey,
                    ),
                  ),
                ),
              ],
            ),

            // Botón de guardar (solo cuando está editando)
            if (_isEditing) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveResult,
                  child: const Text('Guardar Resultado'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScoreInputs() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 50,
          child: TextField(
            controller: _homeScoreController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '-',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 50,
          child: TextField(
            controller: _awayScoreController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.withOpacity(AppTheme.goldAccent, 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: widget.match.homeScore != null && widget.match.awayScore != null
          ? Text(
              '${widget.match.homeScore} - ${widget.match.awayScore}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.blackAccent,
              ),
            )
          : const Text(
              'VS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.blackAccent,
              ),
            ),
    );
  }
}
