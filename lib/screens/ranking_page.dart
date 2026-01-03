// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/user_model.dart';
import '../widgets/ranking_item.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _selectedGroup = 'Todos';
  final List<String> _groups = [
    'Todos',
    'Grupo A',
    'Grupo B',
    'Grupo C',
    'Grupo D'
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: const Text('Ranking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              HapticFeedback.lightImpact();
              _animationController.reset();
              _animationController.forward();
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Filtro de grupos
            Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _groups.map((group) {
                    final isSelected = _selectedGroup == group;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(group),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedGroup = group;
                          });
                          HapticFeedback.lightImpact();
                        },
                        selectedColor:
                            AppTheme.withOpacity(AppTheme.primaryGreen, 0.2),
                        checkmarkColor: AppTheme.primaryGreen,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : AppTheme.darkGrey,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Header del ranking
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.withOpacity(Colors.black, 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 40), // Espacio para el número
                  const Expanded(
                    flex: 3,
                    child: Text(
                      'Usuario',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.blackAccent,
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Grupo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.blackAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Puntos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.blackAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Lista de ranking
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _getFilteredUsers().length,
                itemBuilder: (context, index) {
                  final user = _getFilteredUsers()[index];
                  final position = index + 1;
                  final isCurrentUser = user.id == 'current_user';

                  return RankingItem(
                    user: user,
                    position: position,
                    isCurrentUser: isCurrentUser,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<UserModel> _getFilteredUsers() {
    final allUsers = _getMockUsers();
    if (_selectedGroup == 'Todos') {
      return allUsers;
    }
    return allUsers
        .where((user) => user.groups.contains(_selectedGroup))
        .toList();
  }

  List<UserModel> _getMockUsers() {
    return [
      UserModel(
        id: 'current_user',
        name: 'Juan Pérez',
        email: 'juan@email.com',
        points: 85,
        avatar: '👤',
        groups: ['Grupo A'],
      ),
      UserModel(
        id: 'user2',
        name: 'María García',
        email: 'maria@email.com',
        points: 92,
        avatar: '👩',
        groups: ['Grupo A'],
      ),
      UserModel(
        id: 'user3',
        name: 'Carlos López',
        email: 'carlos@email.com',
        points: 78,
        avatar: '👨',
        groups: ['Grupo B'],
      ),
      UserModel(
        id: 'user4',
        name: 'Ana Martínez',
        email: 'ana@email.com',
        points: 88,
        avatar: '👩',
        groups: ['Grupo A'],
      ),
      UserModel(
        id: 'user5',
        name: 'Luis Rodríguez',
        email: 'luis@email.com',
        points: 73,
        avatar: '👨',
        groups: ['Grupo C'],
      ),
      UserModel(
        id: 'user6',
        name: 'Sofia Hernández',
        email: 'sofia@email.com',
        points: 81,
        avatar: '👩',
        groups: ['Grupo B'],
      ),
      UserModel(
        id: 'user7',
        name: 'Diego González',
        email: 'diego@email.com',
        points: 69,
        avatar: '👨',
        groups: ['Grupo C'],
      ),
      UserModel(
        id: 'user8',
        name: 'Laura Jiménez',
        email: 'laura@email.com',
        points: 76,
        avatar: '👩',
        groups: ['Grupo D'],
      ),
    ]..sort((a, b) => b.points.compareTo(a.points));
  }
}
