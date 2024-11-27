import 'dart:convert';
import 'package:first_flutter_project/data/models/banner_model.dart';
import 'package:first_flutter_project/data/models/category_model.dart';
import 'package:flutter/services.dart';
import '../models/doctor_model.dart';
import '../models/centers_model.dart';

class DoctorLocalDataSource {
  Future<List<DoctorModel>> getDoctors() async {
    final String response = await rootBundle.loadString('assets/doctors.json');
    final data = json.decode(response);
    return (data['doctors'] as List)
        .map((doctor) => DoctorModel.fromJson(doctor))
        .toList();
  }
}

class JsonDataSource {
  Future<Map<String, dynamic>> loadJsonData() async {
    final String response = await rootBundle.loadString('assets/doctors.json');
    return json.decode(response);
  }
}

Future<List<MedicalCenter>> getMedicalCenters() async {
  final String response = await rootBundle.loadString('assets/doctors.json');
  final data = json.decode(response);
  return (data['nearby_centers'] as List)
      .map((center) => MedicalCenter.fromJson(center))
      .toList();
}

Future<List<Category>> getCategories() async {
  final String response = await rootBundle.loadString('assets/doctors.json');
  final data = json.decode(response);
  return (data['categories'] as List)
      .map((center) => Category.fromJson(center))
      .toList();
}

Future<List<BannerData>> getBanners() async {
  final String response = await rootBundle.loadString('assets/doctors.json');
  final data = json.decode(response);
  return (data['banners'] as List)
      .map((center) => BannerData.fromJson(center))
      .toList();
}
