import 'package:flutter/material.dart';
import '../models/cv_model.dart';

class CvPreviewScreen extends StatelessWidget {
  final CvModel cv;

  const CvPreviewScreen({super.key, required this.cv});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CV Preview'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: cv.templateId == 't2'
            ? _classicTemplate()
            : cv.templateId == 't3'
                ? _creativeTemplate()
                : cv.templateId == 't4'
                    ? _simpleTemplate()
                    : _modernTemplate(),
      ),
    );
  }

  Widget _modernTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(cv.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(cv.jobTitle, style: const TextStyle(fontSize: 16)),
        const Divider(height: 30),
        Text('Email: ${cv.email}'),
        Text('Phone: ${cv.phone}'),
      ],
    );
  }

  Widget _classicTemplate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(cv.fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(cv.jobTitle),
        const SizedBox(height: 20),
        Text('Contact Information', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text('Email: ${cv.email}'),
        Text('Phone: ${cv.phone}'),
      ],
    );
  }

  Widget _creativeTemplate() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cv.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          const SizedBox(height: 6),
          Text(cv.jobTitle, style: const TextStyle(color: Colors.deepPurple)),
          const SizedBox(height: 20),
          Text('Email: ${cv.email}'),
          Text('Phone: ${cv.phone}'),
        ],
      ),
    );
  }

  Widget _simpleTemplate() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(cv.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(cv.jobTitle),
          const SizedBox(height: 20),
          Text(cv.email),
          Text(cv.phone),
        ],
      ),
    );
  }
}
