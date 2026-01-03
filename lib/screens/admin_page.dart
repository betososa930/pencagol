import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/match_model.dart';
import '../widgets/admin_section_card.dart';
import '../widgets/match_result_card.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGrey,
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.add_circle), text: 'Nueva Penca'),
            Tab(icon: Icon(Icons.sports_soccer), text: 'Resultados'),
            Tab(icon: Icon(Icons.people), text: 'Usuarios'),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildNewPencaTab(),
            _buildResultsTab(),
            _buildUsersTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewPencaTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionCard(
            icon: Icons.add_circle_outline,
            title: 'Crear Nueva Penca',
            subtitle: 'Configura una nueva penca para el Mundial 2026',
            child: _buildNewPencaForm(),
          ),
          const SizedBox(height: 16),
          AdminSectionCard(
            icon: Icons.list_alt,
            title: 'Pencas Activas',
            subtitle: 'Gestiona las pencas existentes',
            child: _buildActivePencasList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionCard(
            icon: Icons.sports_soccer,
            title: 'Publicar Resultados',
            subtitle: 'Ingresa los resultados de los partidos',
            child: _buildResultsForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionCard(
            icon: Icons.people_outline,
            title: 'Gestión de Usuarios',
            subtitle: 'Administra usuarios y grupos',
            child: _buildUsersManagement(),
          ),
        ],
      ),
    );
  }

  Widget _buildNewPencaForm() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 30));

    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nombre de la Penca',
            hintText: 'Ej: Penca Oficial Mundial 2026',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Descripción',
            hintText: 'Descripción opcional de la penca',
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              setState(() {
                selectedDate = date;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppTheme.withOpacity(AppTheme.primaryGreen, 0.3)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: AppTheme.primaryGreen),
                const SizedBox(width: 12),
                Text(
                  'Fecha límite: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Penca creada exitosamente'),
                  backgroundColor: AppTheme.primaryGreen,
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Crear Penca'),
          ),
        ),
      ],
    );
  }

  Widget _buildActivePencasList() {
    final pencas = [
      {
        'name': 'Penca Oficial Mundial 2026',
        'participants': 45,
        'status': 'Activa'
      },
      {'name': 'Penca Grupo A', 'participants': 12, 'status': 'Activa'},
      {'name': 'Penca Amigos', 'participants': 8, 'status': 'Activa'},
    ];

    return Column(
      children: pencas
          .map((penca) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        AppTheme.withOpacity(AppTheme.primaryGreen, 0.1),
                    child: const Icon(Icons.emoji_events,
                        color: AppTheme.primaryGreen),
                  ),
                  title: Text(penca['name'] as String),
                  subtitle: Text('${penca['participants']} participantes'),
                  trailing: Chip(
                    label: Text(penca['status'] as String),
                    backgroundColor:
                        AppTheme.withOpacity(AppTheme.primaryGreen, 0.1),
                    labelStyle: const TextStyle(color: AppTheme.primaryGreen),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildResultsForm() {
    final matches = _getMatchesForResults();

    return Column(
      children: matches
          .map((match) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MatchResultCard(match: match),
              ))
          .toList(),
    );
  }

  Widget _buildUsersManagement() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad próximamente'),
                      backgroundColor: AppTheme.primaryGreen,
                    ),
                  );
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Agregar Usuario'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidad próximamente'),
                      backgroundColor: AppTheme.primaryGreen,
                    ),
                  );
                },
                icon: const Icon(Icons.group_add),
                label: const Text('Crear Grupo'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppTheme.primaryGreen,
              child: Icon(Icons.people, color: AppTheme.white),
            ),
            title: const Text('Total de Usuarios'),
            subtitle: const Text('156 usuarios registrados'),
            trailing: const Text('Ver todos',
                style: TextStyle(color: AppTheme.primaryGreen)),
            onTap: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lista de usuarios próximamente'),
                  backgroundColor: AppTheme.primaryGreen,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<MatchModel> _getMatchesForResults() {
    return [
      MatchModel(
        homeTeam: 'Argentina',
        awayTeam: 'Brasil',
        homeFlag: '🇦🇷',
        awayFlag: '🇧🇷',
        date: DateTime.now().subtract(const Duration(days: 1)),
        venue: 'Estadio Azteca, México',
        group: 'Grupo A',
        homeScore: 2,
        awayScore: 1,
        isFinished: true,
      ),
      MatchModel(
        homeTeam: 'España',
        awayTeam: 'Alemania',
        homeFlag: '🇪🇸',
        awayFlag: '🇩🇪',
        date: DateTime.now(),
        venue: 'MetLife Stadium, Nueva York',
        group: 'Grupo B',
      ),
      MatchModel(
        homeTeam: 'Francia',
        awayTeam: 'Inglaterra',
        homeFlag: '🇫🇷',
        awayFlag: '🇬🇧',
        date: DateTime.now().add(const Duration(days: 2)),
        venue: 'BC Place, Vancouver',
        group: 'Grupo C',
      ),
    ];
  }
}
