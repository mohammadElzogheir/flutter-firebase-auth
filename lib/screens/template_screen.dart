import 'package:flutter/material.dart';
import '../models/cv_model.dart';
import 'cv_form_screen.dart';

class TemplateScreen extends StatefulWidget {
  final CvModel? cv;
  const TemplateScreen({super.key, this.cv});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  String selectedTemplate = 't1';

  @override
  void initState() {
    super.initState();
    if (widget.cv != null && widget.cv!.templateId.isNotEmpty) {
      selectedTemplate = widget.cv!.templateId;
    }
  }

  void _goNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CvFormScreen(
          cv: widget.cv,
          templateId: selectedTemplate,
        ),
      ),
    );
  }

  Widget _previewCard({
    required String id,
    required String title,
    required Widget preview,
  }) {
    final isSelected = selectedTemplate == id;

    return InkWell(
      onTap: () => setState(() => selectedTemplate = id),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.black.withOpacity(0.05),
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.black.withOpacity(0.10),
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: preview,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? Colors.deepPurple : Colors.black.withOpacity(0.35),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _miniTemplate({
    required Color sideColor,
    required bool hasAvatar,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 38,
            decoration: BoxDecoration(
              color: sideColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                if (hasAvatar)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: sideColor.withOpacity(0.35),
                    ),
                  )
                else
                  Container(
                    width: 24,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: sideColor.withOpacity(0.35),
                    ),
                  ),
                const SizedBox(height: 8),
                Container(
                  height: 6,
                  width: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: sideColor.withOpacity(0.25),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 6,
                  width: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: sideColor.withOpacity(0.20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withOpacity(0.08),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 30,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.cv != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Select Design (Edit)' : 'Select a Professional Design'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.78,
                children: [
                  _previewCard(
                    id: 't1',
                    title: 'Modern Minimal',
                    preview: _miniTemplate(sideColor: Colors.deepPurple, hasAvatar: true),
                  ),
                  _previewCard(
                    id: 't2',
                    title: 'Classic Pro',
                    preview: _miniTemplate(sideColor: Colors.blue, hasAvatar: false),
                  ),
                  _previewCard(
                    id: 't3',
                    title: 'Creative Card',
                    preview: _miniTemplate(sideColor: Colors.orange, hasAvatar: true),
                  ),
                  _previewCard(
                    id: 't4',
                    title: 'Simple One Page',
                    preview: _miniTemplate(sideColor: Colors.green, hasAvatar: false),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _goNext,
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
