class CvModel {
  final String id;
  final String ownerId;
  final String fullName;
  final String jobTitle;
  final String email;
  final String phone;
  final bool isPublic;
  final String templateId;
  final String summary;
  final List<String> skills;
  final List<Map<String, dynamic>> experiences;
  final List<Map<String, dynamic>> education;
  final List<String> languages;
  final int likesCount;

  CvModel({
    required this.id,
    required this.ownerId,
    required this.fullName,
    required this.jobTitle,
    required this.email,
    required this.phone,
    required this.isPublic,
    required this.templateId,
    required this.summary,
    required this.skills,
    required this.experiences,
    required this.education,
    required this.languages,
    required this.likesCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'fullName': fullName,
      'jobTitle': jobTitle,
      'email': email,
      'phone': phone,
      'isPublic': isPublic,
      'templateId': templateId,
      'summary': summary,
      'skills': skills,
      'experiences': experiences,
      'education': education,
      'languages': languages,
      'likesCount': likesCount,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory CvModel.fromMap(String id, Map<String, dynamic> map) {
    List<String> stringList(dynamic value) {
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return <String>[];
    }

    List<Map<String, dynamic>> mapList(dynamic value) {
      if (value is List) {
        return value.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return <Map<String, dynamic>>[];
    }

    return CvModel(
      id: id,
      ownerId: map['ownerId'] ?? '',
      fullName: map['fullName'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      isPublic: map['isPublic'] ?? false,
      templateId: map['templateId'] ?? 't1',
      summary: map['summary'] ?? '',
      skills: stringList(map['skills']),
      experiences: mapList(map['experiences']),
      education: mapList(map['education']),
      languages: stringList(map['languages']),
      likesCount: map['likesCount'] is int ? map['likesCount'] : 0,
    );
  }
}