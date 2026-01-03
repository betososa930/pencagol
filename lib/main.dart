import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
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
    return StreamBuilder(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        final isLoggedIn = snapshot.data != null;
        return MaterialApp(
          title: 'PencaGol',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          home: isLoggedIn ? const HomePage() : const SplashScreen(),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/splash':
                return MaterialPageRoute(
                    builder: (context) => const SplashScreen());
              case '/login':
                return MaterialPageRoute(
                    builder: (context) => const LoginPage());
              case '/home':
                return SlidePageRoute(child: const HomePage());
              case '/ranking':
                return SlidePageRoute(child: const RankingPage());
              case '/admin':
                return ScalePageRoute(child: const AdminPage());
              default:
                return MaterialPageRoute(
                    builder: (context) =>
                        isLoggedIn ? const HomePage() : const SplashScreen());
            }
          },
        );
      },
    );
  }
}
