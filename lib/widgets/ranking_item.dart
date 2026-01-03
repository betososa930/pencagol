import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_model.dart';

class RankingItem extends StatelessWidget {
  final UserModel user;
  final int position;
  final bool isCurrentUser;

  const RankingItem({
    super.key,
    required this.user,
    required this.position,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppTheme.withOpacity(AppTheme.primaryGreen, 0.1)
            : AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser
            ? Border.all(color: AppTheme.primaryGreen, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppTheme.withOpacity(Colors.black, 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Posición
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getPositionColor(),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  position.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getPositionTextColor(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: isCurrentUser
                  ? AppTheme.withOpacity(AppTheme.primaryGreen, 0.2)
                  : AppTheme.lightGrey,
              child: Text(
                user.avatar,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 12),

            // Nombre del usuario
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCurrentUser
                          ? AppTheme.primaryGreen
                          : AppTheme.blackAccent,
                    ),
                  ),
                  if (isCurrentUser)
                    const Text(
                      'Tú',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),

            // Grupo
            Expanded(
              flex: 2,
              child: Text(
                user.groups.isNotEmpty ? user.groups.first : 'Sin grupo',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.darkGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Puntos
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    user.points.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isCurrentUser
                          ? AppTheme.primaryGreen
                          : AppTheme.blackAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'pts',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.darkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPositionColor() {
    switch (position) {
      case 1:
        return AppTheme.goldAccent;
      case 2:
        return const Color(0xFFC0C0C0); // Plata
      case 3:
        return const Color(0xFFCD7F32); // Bronce
      default:
        return AppTheme.lightGrey;
    }
  }

  Color _getPositionTextColor() {
    switch (position) {
      case 1:
      case 2:
      case 3:
        return AppTheme.white;
      default:
        return AppTheme.darkGrey;
    }
  }
}
