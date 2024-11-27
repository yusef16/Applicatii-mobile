class Category {
  final String title;
  final String iconUrl;

  Category({required this.title, required this.iconUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json['title'],
      iconUrl: json['icon'],
    );
  }
}
