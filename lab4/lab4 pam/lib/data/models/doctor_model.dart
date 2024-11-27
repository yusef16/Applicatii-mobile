import '../../domain/entities/doctor.dart';

class DoctorModel extends Doctor {
  DoctorModel({
    required String name,
    required String specialty,
    required String location,
    required double rating,
    required int reviews,
    required String imageUrl,
  }) : super(
          name: name,
          specialty: specialty,
          location: location,
          rating: rating,
          reviews: reviews,
          imageUrl: imageUrl,
        );

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      name: json['full_name'],
      specialty: json['type_of_doctor'],
      location: json['location_of_center'],
      rating: json['review_rate'],
      reviews: json['reviews_count'],
      imageUrl: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': name,
      'type_of_doctor': specialty,
      'location_of_center': location,
      'review_rate': rating,
      'reviews_count': reviews,
      'image': imageUrl,
    };
  }
}
