import 'package:flutter/material.dart';
import '../../domain/repositories/banner_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/doctor_repository.dart';
import '../../domain/repositories/centers_repository.dart';
import '../widgets/carousel_with_dots.dart';
import '../widgets/category_grid.dart';
import '../widgets/doctor_list_item.dart';
import '../widgets/location_and_notification.dart';
import '../widgets/medical_center_list.dart';
import '../../domain/entities/doctor.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/banner.dart';
import '../../domain/entities/centers.dart';
import '../widgets/search_bar.dart';

class DoctorSearchPage extends StatefulWidget {
  final DoctorRepository doctorRepository;
  final CategoryRepository categoryRepository;
  final BannerRepository bannerRepository;
  final MedicalCenterRepository medicalCenterRepository;

  DoctorSearchPage({
    required this.doctorRepository,
    required this.categoryRepository,
    required this.bannerRepository,
    required this.medicalCenterRepository,
  });

  @override
  _DoctorSearchPageState createState() => _DoctorSearchPageState();
}

class _DoctorSearchPageState extends State<DoctorSearchPage> {
  List<Doctor> doctors = [];
  List<Category> categories = [];
  List<BannerData> banners = [];
  List<MedicalCenter> nearbyCenters = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    doctors = await widget.doctorRepository.getDoctors();
    categories = await widget.categoryRepository.getCategories();
    banners = await widget.bannerRepository.getBanners();
    nearbyCenters = await widget.medicalCenterRepository.getMedicalCenters();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Doctor Search")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LocationAndNotification(),
            buildSearchBar(),
            CarouselWithDots(banners: banners),
            CategoryGrid(categories: categories),
            MedicalCenterList(nearbyCenters: nearbyCenters),
            DoctorList(doctors: doctors),
          ],
        ),
      ),
    );
  }
}
