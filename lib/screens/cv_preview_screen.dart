import 'package:flutter/material.dart';
import '../models/cv_model.dart';

class CvPreviewScreen extends StatelessWidget {
  final CvModel cv;

  const CvPreviewScreen({super.key, required this.cv});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CV Preview')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(cv.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(cv.jobTitle, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Email: ${cv.email}'),
            Text('Phone: ${cv.phone}'),
            const Divider(height: 30),

            if (cv.summary.trim().isNotEmpty) ...[
              const Text('Summary', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(cv.summary),
              const SizedBox(height: 16),
            ],

            if (cv.skills.isNotEmpty) ...[
              const Text('Skills', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cv.skills.map((s) => Chip(label: Text(s))).toList(),
              ),
              const SizedBox(height: 16),
            ],

            if (cv.languages.isNotEmpty) ...[
              const Text('Languages', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cv.languages.map((s) => Chip(label: Text(s))).toList(),
              ),
              const SizedBox(height: 16),
            ],

            if (cv.experiences.isNotEmpty) ...[
              const Text('Work Experience', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...cv.experiences.map((ex) {
                return Card(
                  child: ListTile(
                    title: Text('${ex['role'] ?? ''} - ${ex['company'] ?? ''}'),
                    subtitle: Text('${ex['from'] ?? ''}  →  ${ex['to'] ?? ''}'),
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],

            if (cv.education.isNotEmpty) ...[
              const Text('Education', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...cv.education.map((ed) {
                return Card(
                  child: ListTile(
                    title: Text(ed['degree'] ?? ''),
                    subtitle: Text('${ed['school'] ?? ''}  (${ed['year'] ?? ''})'),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}