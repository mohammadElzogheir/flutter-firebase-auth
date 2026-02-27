class CvModel {
  final String id;
  final String fullName;
  final String jobTitle;
  final String email;
  final String phone;
  final bool isPublic;
  final String templateId;

  CvModel({
    required this.id,
    required this.fullName,
    required this.jobTitle,
    required this.email,
    required this.phone,
    required this.isPublic,
    required this.templateId,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'jobTitle': jobTitle,
      'email': email,
      'phone': phone,
      'isPublic': isPublic,
      'templateId': templateId,
    };
  }

  factory CvModel.fromMap(String id, Map<String, dynamic> map) {
    return CvModel(
      id: id,
      fullName: map['fullName'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      isPublic: map['isPublic'] ?? false,
      templateId: map['templateId'] ?? '',
    );
  }
}
