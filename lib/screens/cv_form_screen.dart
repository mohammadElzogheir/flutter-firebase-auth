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
  final _summary = TextEditingController();
  final _skillController = TextEditingController();
  final _langController = TextEditingController();
  final _expCompany = TextEditingController();
  final _expRole = TextEditingController();
  final _expFrom = TextEditingController();
  final _expTo = TextEditingController();
  final _eduSchool = TextEditingController();
  final _eduDegree = TextEditingController();
  final _eduYear = TextEditingController();

  bool isPublic = true;
  String templateId = 't1';

  List<String> skills = [];
  List<String> languages = [];
  List<Map<String, dynamic>> experiences = [];
  List<Map<String, dynamic>> education = [];

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
      _summary.text = cv.summary;
      isPublic = cv.isPublic;
      templateId =
          widget.templateId ?? (cv.templateId.isEmpty ? 't1' : cv.templateId);
      skills = List<String>.from(cv.skills);
      languages = List<String>.from(cv.languages);
      experiences = List<Map<String, dynamic>>.from(cv.experiences);
      education = List<Map<String, dynamic>>.from(cv.education);
    } else {
      templateId = widget.templateId ?? 't1';
      skills = [];
      languages = [];
      experiences = [];
      education = [];
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _jobTitle.dispose();
    _email.dispose();
    _phone.dispose();
    _summary.dispose();
    _skillController.dispose();
    _langController.dispose();
    _expCompany.dispose();
    _expRole.dispose();
    _expFrom.dispose();
    _expTo.dispose();
    _eduSchool.dispose();
    _eduDegree.dispose();
    _eduYear.dispose();
    super.dispose();
  }

  void _addSkill() {
    final value = _skillController.text.trim();
    if (value.isEmpty || skills.contains(value)) return;
    setState(() {
      skills.add(value);
      _skillController.clear();
    });
  }

  void _addLang() {
    final value = _langController.text.trim();
    if (value.isEmpty || languages.contains(value)) return;
    setState(() {
      languages.add(value);
      _langController.clear();
    });
  }

  void _addExperience() {
    final company = _expCompany.text.trim();
    final role = _expRole.text.trim();
    final from = _expFrom.text.trim();
    final to = _expTo.text.trim();

    if (company.isEmpty || role.isEmpty) return;

    setState(() {
      experiences.add({
        'company': company,
        'role': role,
        'from': from,
        'to': to,
      });
      _expCompany.clear();
      _expRole.clear();
      _expFrom.clear();
      _expTo.clear();
    });
  }

  void _addEducation() {
    final school = _eduSchool.text.trim();
    final degree = _eduDegree.text.trim();
    final year = _eduYear.text.trim();

    if (school.isEmpty || degree.isEmpty) return;

    setState(() {
      education.add({
        'school': school,
        'degree': degree,
        'year': year,
      });
      _eduSchool.clear();
      _eduDegree.clear();
      _eduYear.clear();
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final dataCv = CvModel(
      id: widget.cv?.id ?? '',
      ownerId: widget.cv?.ownerId ?? '',
      fullName: _fullName.text.trim(),
      jobTitle: _jobTitle.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      isPublic: isPublic,
      templateId: templateId,
      summary: _summary.text.trim(),
      skills: skills,
      experiences: experiences,
      education: education,
      languages: languages,
      likesCount: widget.cv?.likesCount ?? 0,
    );

    if (widget.cv == null) {
      await _cvService.addCv(dataCv);
    } else {
      await _cvService.updateCv(widget.cv!.id, dataCv.toMap());
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CvPreviewScreen(cv: dataCv),
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
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _jobTitle,
                decoration: const InputDecoration(labelText: 'Job Title'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
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
              TextFormField(
                controller: _summary,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Summary'),
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
              const SizedBox(height: 18),
              const Text(
                'Skills',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _skillController,
                      decoration:
                          const InputDecoration(labelText: 'Add a skill'),
                      onSubmitted: (_) => _addSkill(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addSkill,
                    child: const Text('+'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills
                    .map(
                      (s) => Chip(
                        label: Text(s),
                        onDeleted: () => setState(() => skills.remove(s)),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
              const Text(
                'Languages',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _langController,
                      decoration:
                          const InputDecoration(labelText: 'Add a language'),
                      onSubmitted: (_) => _addLang(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addLang,
                    child: const Text('+'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: languages
                    .map(
                      (s) => Chip(
                        label: Text(s),
                        onDeleted: () => setState(() => languages.remove(s)),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
              const Text(
                'Work Experience',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _expCompany,
                decoration: const InputDecoration(labelText: 'Company'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _expRole,
                decoration: const InputDecoration(labelText: 'Role / Position'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expFrom,
                      decoration: const InputDecoration(labelText: 'From'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _expTo,
                      decoration: const InputDecoration(labelText: 'To'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addExperience,
                  child: const Text('Add Experience'),
                ),
              ),
              const SizedBox(height: 10),
              ...experiences.asMap().entries.map((entry) {
                final index = entry.key;
                final ex = entry.value;
                return Card(
                  child: ListTile(
                    title: Text('${ex['role']} - ${ex['company']}'),
                    subtitle: Text('${ex['from']}  →  ${ex['to']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          experiences.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              }),
              const SizedBox(height: 18),
              const Text(
                'Education',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _eduSchool,
                decoration:
                    const InputDecoration(labelText: 'University / School'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _eduDegree,
                decoration: const InputDecoration(labelText: 'Degree'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _eduYear,
                decoration: const InputDecoration(labelText: 'Year'),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addEducation,
                  child: const Text('Add Education'),
                ),
              ),
              const SizedBox(height: 10),
              ...education.asMap().entries.map((entry) {
                final index = entry.key;
                final ed = entry.value;
                return Card(
                  child: ListTile(
                    title: Text(ed['degree'] ?? ''),
                    subtitle: Text('${ed['school']} (${ed['year']})'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          education.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              }),
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