import 'package:flutter/material.dart';
import '../models/cv_model.dart';
import '../services/cv_service.dart';
import 'settings_screen.dart';
import 'template_screen.dart';

class CvListScreen extends StatelessWidget {
  const CvListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CvService cvService = CvService();

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'CV Project',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Your CV Portfolio'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TemplateScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add New CV'),
      ),
      body: StreamBuilder<List<CvModel>>(
        stream: cvService.getCvs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cvs = snapshot.data!;

          if (cvs.isEmpty) {
            return const Center(
              child: Text('No CVs yet. Tap "Add New CV".'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cvs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final cv = cvs[index];

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withOpacity(0.06),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.08),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.blue.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Icons.description,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cv.fullName.isEmpty ? 'Unnamed CV' : cv.fullName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cv.jobTitle.isEmpty ? 'Professional CV' : cv.jobTitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TemplateScreen(cv: cv),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.orange,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await cvService.deleteCv(cv.id);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
