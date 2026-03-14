import 'package:flutter/material.dart';
import '../main.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ValueListenableBuilder<ThemeMode>(
        valueListenable: appThemeMode,
        builder: (context, mode, _) {
          final isDark = mode == ThemeMode.dark;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Theme Mode'),
                  subtitle: Text(isDark ? 'Dark' : 'Light'),
                  value: isDark,
                  onChanged: (value) {
                    appThemeMode.value =
                        value ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
                const SizedBox(height: 8),
                const ListTile(
                  leading: Icon(Icons.info),
                  title: Text('About App'),
                  subtitle: Text('Version 1.0.0'),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await auth.logout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (_) => false,
                        );
                      }
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}