class Doctor {
  final String name;
  final String specialty;
  final String location;
  final double rating;
  final int reviews;
  final String imageUrl;

  Doctor({
    required this.name,
    required this.specialty,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      name: json['full_name'],
      specialty: json['type_of_doctor'],
      location: json['location_of_center'],
      rating: json['review_rate'],
      reviews: json['reviews_count'],
      imageUrl: json['image'],
    );
  }
}
