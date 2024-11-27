import 'package:flutter/material.dart';
import '../../domain/entities/doctor.dart';

class DoctorList extends StatelessWidget {
  final List<Doctor> doctors;

  DoctorList({required this.doctors});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(doctor.imageUrl),
              onBackgroundImageError: (_, __) => Icon(Icons.person),
            ),
            title: Text(
              doctor.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${doctor.specialty} · ${doctor.location}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.yellow),
                Text(
                  '${doctor.rating} (${doctor.reviews} reviews)',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
