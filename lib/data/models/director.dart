class Director {
  const Director({
    required this.id,
    required this.name,
    required this.gender,
    required this.uid,
    required this.department,
  });

  factory Director.fromJson(Map<String, dynamic> json) => Director(
        id: json['id'],
        name: json['name'],
        gender: json['gender'],
        uid: json['uid'],
        department: json['department'],
      );

  final int id;
  final String name;
  final int gender; // Хотел энам, но там трансгендеры. Не понял кто есть кто.
  final int uid;
  final String department;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'gender': gender,
        'uid': uid,
        'department': department,
      };
}
