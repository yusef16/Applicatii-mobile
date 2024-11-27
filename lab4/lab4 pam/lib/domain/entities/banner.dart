class BannerData {
  final String title;
  final String description;
  final String imageUrl;

  BannerData(
      {required this.title, required this.description, required this.imageUrl});

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      title: json['title'],
      description: json['description'],
      imageUrl: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': imageUrl,
    };
  }
}
