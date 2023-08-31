class Employee {
  late String id;
  late String name;
  late String department;
  late String createdBy;
  late String image;
  late String createdAt;
  late String documentId;

  // Employee({
  //   required this.id,
  //   required this.name,
  //   required this.department,
  //   required this.createdBy,
  //   required this.image,
  //   required this.createdAt,
  // });

  Employee.formMap(Map<String, dynamic> map) {
    name = map['name'];
    department = map['department'];
    createdBy = map['createdBy'];
    image = map['image'];
    createdAt = map['createdAt'];
    documentId = map['\$id'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'department': department,
      'createdBy': createdBy,
      'image': image,
      'createdAt': createdAt,
      'documentId': documentId,
    };
  }
}
