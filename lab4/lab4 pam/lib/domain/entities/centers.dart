class MedicalCenter {
  final String image;
  final String title;
  final String locationName;
  final double reviewRate;
  final int countReviews;
  final double distanceKm;
  final int distanceMinutes;

  MedicalCenter({
    required this.image,
    required this.title,
    required this.locationName,
    required this.reviewRate,
    required this.countReviews,
    required this.distanceKm,
    required this.distanceMinutes,
  });

  factory MedicalCenter.fromJson(Map<String, dynamic> json) {
    return MedicalCenter(
      image: json['image'],
      title: json['title'],
      locationName: json['location_name'],
      reviewRate: json['review_rate'].toDouble(), // Ensure it's a double
      countReviews: json['count_reviews'],
      distanceKm: json['distance_km'].toDouble(), // Ensure it's a double
      distanceMinutes: json['distance_minutes'],
    );
  }
}
