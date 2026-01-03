// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/match_model.dart';
import '../widgets/match_card.dart';
import '../widgets/quick_access_card.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToRanking() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/ranking');
  }

  void _navigateToAdmin() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/admin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.primaryGreen,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentOrange,
                    AppTheme.accentOrange.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  '⚽',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'PencaGol',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.admin_panel_settings, size: 26),
              onPressed: _navigateToAdmin,
              tooltip: 'Panel de Administración',
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 24),
            onPressed: () {
              HapticFeedback.lightImpact();
              AuthService.instance.signOut();
            },
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Saludo de bienvenida
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryGreen,
                      AppTheme.accentBlue,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryGreen.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Bienvenido a PencaGol!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Mundial 2026 - Haz tus predicciones',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppTheme.white,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Estados Unidos, Canadá y México',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppTheme.lightAccent,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Sección de accesos rápidos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Accesos Rápidos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.blackAccent,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: QuickAccessCard(
                            icon: Icons.leaderboard,
                            title: 'Ranking',
                            subtitle: 'Posiciones',
                            onTap: _navigateToRanking,
                            gradientStart: AppTheme.accentOrange,
                            gradientEnd: AppTheme.accentOrange.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: QuickAccessCard(
                            icon: Icons.sports_soccer,
                            title: 'Partidos',
                            subtitle: 'Todos los partidos',
                            onTap: () {
                              HapticFeedback.lightImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Próximamente: Todos los Partidos'),
                                  backgroundColor: AppTheme.primaryGreen,
                                ),
                              );
                            },
                            gradientStart: AppTheme.accentBlue,
                            gradientEnd: AppTheme.accentBlue.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: QuickAccessCard(
                            icon: Icons.groups,
                            title: 'Mi Grupo',
                            subtitle: 'Ver participantes',
                            onTap: () {
                              HapticFeedback.lightImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Próximamente: Mi Grupo'),
                                  backgroundColor: AppTheme.primaryGreen,
                                ),
                              );
                            },
                            gradientStart: const Color(0xFFFF6B6B),
                            gradientEnd:
                                const Color(0xFFFF6B6B).withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: QuickAccessCard(
                            icon: Icons.trending_up,
                            title: 'Estadísticas',
                            subtitle: 'Mi desempeño',
                            onTap: () {
                              HapticFeedback.lightImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Próximamente: Estadísticas'),
                                  backgroundColor: AppTheme.primaryGreen,
                                ),
                              );
                            },
                            gradientStart: const Color(0xFF4ECDC4),
                            gradientEnd:
                                const Color(0xFF4ECDC4).withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Próximos partidos
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Próximos Partidos',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.blackAccent,
                            letterSpacing: 0.3,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _navigateToRanking,
                          icon: const Icon(Icons.leaderboard, size: 18),
                          label: const Text('Ranking'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.accentOrange,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Lista de partidos
                    ..._getUpcomingMatches().map((match) => MatchCard(
                          match: match,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${match.homeTeam} vs ${match.awayTeam}'),
                                backgroundColor: AppTheme.primaryGreen,
                              ),
                            );
                          },
                        )),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<MatchModel> _getUpcomingMatches() {
    return [
      MatchModel(
        homeTeam: 'Argentina',
        awayTeam: 'Brasil',
        homeFlag: '🇦🇷',
        awayFlag: '🇧🇷',
        date: DateTime.now().add(const Duration(days: 2)),
        venue: 'Estadio Azteca, México',
        group: 'Grupo A',
      ),
      MatchModel(
        homeTeam: 'España',
        awayTeam: 'Alemania',
        homeFlag: '🇪🇸',
        awayFlag: '🇩🇪',
        date: DateTime.now().add(const Duration(days: 4)),
        venue: 'MetLife Stadium, Nueva York',
        group: 'Grupo B',
      ),
      MatchModel(
        homeTeam: 'Francia',
        awayTeam: 'Inglaterra',
        homeFlag: '🇫🇷',
        awayFlag: '🇬🇧',
        date: DateTime.now().add(const Duration(days: 6)),
        venue: 'BC Place, Vancouver',
        group: 'Grupo C',
      ),
    ];
  }
}
