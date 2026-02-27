import 'package:flutter/material.dart';
import '../models/cv_model.dart';
import '../services/cv_service.dart';
import 'cv_preview_screen.dart';

class CvFormScreen extends StatefulWidget {
  final CvModel? cv;
  final String? templateId;

  const CvFormScreen({super.key, this.cv, this.templateId});

  @override
  State<CvFormScreen> createState() => _CvFormScreenState();
}

class _CvFormScreenState extends State<CvFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _jobTitle = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  bool isPublic = true;
  String templateId = 't1';

  final CvService _cvService = CvService();

  @override
  void initState() {
    super.initState();
    final cv = widget.cv;

    if (cv != null) {
      _fullName.text = cv.fullName;
      _jobTitle.text = cv.jobTitle;
      _email.text = cv.email;
      _phone.text = cv.phone;
      isPublic = cv.isPublic;
      templateId = widget.templateId ?? (cv.templateId.isEmpty ? 't1' : cv.templateId);
    } else {
      templateId = widget.templateId ?? 't1';
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _jobTitle.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.cv == null) {
      final newCv = CvModel(
        id: '',
        fullName: _fullName.text.trim(),
        jobTitle: _jobTitle.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        isPublic: isPublic,
        templateId: templateId,
      );
      await _cvService.addCv(newCv);
    } else {
      await _cvService.updateCv(widget.cv!.id, {
        'fullName': _fullName.text.trim(),
        'jobTitle': _jobTitle.text.trim(),
        'email': _email.text.trim(),
        'phone': _phone.text.trim(),
        'isPublic': isPublic,
        'templateId': templateId,
      });
    }

    final previewCv = CvModel(
      id: widget.cv?.id ?? '',
      fullName: _fullName.text.trim(),
      jobTitle: _jobTitle.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      isPublic: isPublic,
      templateId: templateId,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CvPreviewScreen(cv: previewCv),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.cv != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit CV' : 'Add New CV'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fullName,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _jobTitle,
                decoration: const InputDecoration(labelText: 'Job Title'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Public'),
                value: isPublic,
                onChanged: (v) => setState(() => isPublic = v),
              ),
              const SizedBox(height: 10),
              Text(
                'Selected Template: $templateId',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? 'Update' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
