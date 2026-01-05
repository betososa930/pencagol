import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_page.dart';
import 'screens/home_page.dart';
import 'screens/ranking_page.dart';
import 'screens/admin_page.dart';
import 'theme/app_theme.dart';
import 'utils/page_transitions.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PencaGolApp());
}

class PencaGolApp extends StatelessWidget {
  const PencaGolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        // Mientras se carga el estado de autenticación
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final isLoggedIn = snapshot.hasData;
        return MaterialApp(
          title: 'PencaGol',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          locale: const Locale('es', 'ES'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('es', 'ES'),
            Locale('es', ''),
          ],
          home: isLoggedIn ? const HomePage() : const LoginPage(),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/home':
                return SlidePageRoute(child: const HomePage());
              case '/ranking':
                return SlidePageRoute(child: const RankingPage());
              case '/admin':
                return ScalePageRoute(child: const AdminPage());
              default:
                return MaterialPageRoute(
                    builder: (context) =>
                        isLoggedIn ? const HomePage() : const LoginPage());
            }
          },
        );
      },
    );
  }
}
