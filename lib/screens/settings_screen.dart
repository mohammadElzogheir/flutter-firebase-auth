import 'package:flutter/material.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Theme Mode'),
              subtitle: const Text('Later: Light/Dark'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Theme toggle (later)')),
                );
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About App'),
              subtitle: const Text('Version 1.0.0'),
              onTap: () {},
            ),
            const Spacer(),
            ElevatedButton.icon(
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
          ],
        ),
      ),
    );
  }
}
