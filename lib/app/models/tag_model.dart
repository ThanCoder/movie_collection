class TagModel {
  String name;
  int count;
  bool isSelected;
  TagModel({
    required this.name,
    this.isSelected = false,
    this.count = 0,
  });

  factory TagModel.fromMap(Map<String, dynamic> map) {
    return TagModel(
      name: map['name'] ?? '',
      count: map['count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'count': count,
      };
}
