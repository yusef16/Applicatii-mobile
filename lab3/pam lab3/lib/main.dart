import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(DevicePreview(builder: (context) => MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DoctorSearchPage(),
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Roboto',
      ),
    );
  }
}

// Doctor Model
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

// Category Model
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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'icon': iconUrl,
    };
  }
}

// BannerData Model
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

// DoctorSearchPage
class DoctorSearchPage extends StatefulWidget {
  const DoctorSearchPage({super.key});

  @override
  _DoctorSearchPageState createState() => _DoctorSearchPageState();
}

class _DoctorSearchPageState extends State<DoctorSearchPage> {
  List<Doctor> doctors = [];
  List<dynamic> nearbyCenters = [];
  List<Category> categories = [];
  List<BannerData> banners = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    final String response = await rootBundle.loadString('assets/doctors.json');
    final data = json.decode(response);

    setState(() {
      doctors = (data['doctors'] as List)
          .map((doctor) => Doctor.fromJson(doctor))
          .toList();
      nearbyCenters = data['nearby_centers'];
      categories = (data['categories'] as List)
          .map((category) => Category.fromJson(category))
          .toList();
      banners = (data['banners'] as List)
          .map((banner) => BannerData.fromJson(banner))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Doctor Search', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocationAndNotification(),
              const SizedBox(height: 16),
              buildSearchBar(),
              const SizedBox(height: 16),
              CarouselWithDots(banners: banners),
              const SizedBox(height: 24),
              buildCategories(),
              const SizedBox(height: 24),
              const Text("Nearby Medical Centers",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              buildMedicalCenterList(),
              const SizedBox(height: 24),
              Text("${doctors.length} found",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              buildDoctorList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage(String imageUrl) {
    return Image.asset(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
    );
  }

  Widget buildMedicalCenterList() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: nearbyCenters.length,
        itemBuilder: (context, index) {
          final center = nearbyCenters[index];
          return Container(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: buildImage(center['image']),
                  ),
                ),
                const SizedBox(height: 8),
                Text(center['title'],
                    style:
                        const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text('${center['location_name']} · ${center['distance_km']} km',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search doctors...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget buildCategories() {
    return SizedBox(
      height: 100,
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        shrinkWrap: true,
        children: categories.map((category) {
          return Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue[50],
                child: Image.asset(
                  category.iconUrl,
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 4),
              Text(category.title, style: const TextStyle(fontSize: 9)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget buildDoctorList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(doctor.imageUrl),
              onBackgroundImageError: (_, __) => const Icon(Icons.person),
            ),
            title: Text(doctor.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${doctor.specialty} · ${doctor.location}',
                style: TextStyle(color: Colors.grey[700])),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.yellow),
                Text('${doctor.rating} (${doctor.reviews} reviews)',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LocationAndNotification extends StatefulWidget {
  const LocationAndNotification({super.key});

  @override
  _LocationAndNotificationState createState() =>
      _LocationAndNotificationState();
}

class _LocationAndNotificationState extends State<LocationAndNotification> {
  String _selectedLocation = 'Seattle, USA';
  final List<String> _locations = [
    'Seattle, USA',
    'New York, USA',
    'Los Angeles, USA',
    'Chicago, USA',
    'Miami, USA'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.blue),
              const SizedBox(width: 5),
              DropdownButton<String>(
                value: _selectedLocation,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLocation = newValue!;
                  });
                },
                items: _locations.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class CarouselWithDots extends StatefulWidget {
  final List<BannerData> banners;

  const CarouselWithDots({super.key, required this.banners});

  @override
  _CarouselWithDotsState createState() => _CarouselWithDotsState();
}

class _CarouselWithDotsState extends State<CarouselWithDots> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            itemCount: widget.banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  widget.banners[index].imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.banners.length, (index) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blue : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}
