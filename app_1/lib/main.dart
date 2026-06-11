import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/profile_provider.dart';
import 'providers/feed_provider.dart';
import 'providers/community_provider.dart';
import 'providers/launchpad_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final profileProvider = ProfileProvider();
  await profileProvider.loadFromPrefs();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: profileProvider),
      ChangeNotifierProvider(create: (_) => FeedProvider()),
      ChangeNotifierProvider(create: (_) => CommunityProvider()),
      ChangeNotifierProvider(create: (_) => LaunchpadProvider()),
    ],
    child: const AluConnectApp(),
  ));
}

class AluConnectApp extends StatelessWidget {
  const AluConnectApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ALUConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: Consumer<ProfileProvider>(
        builder: (_, p, __) =>
            p.isLoggedIn ? const MainShell() : const LoginScreen(),
      ),
    );
  }
}
