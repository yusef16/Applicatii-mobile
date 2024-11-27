import 'package:flutter/material.dart';
import '../../domain/entities/centers.dart';

class MedicalCenterList extends StatelessWidget {
  final List<MedicalCenter> nearbyCenters;

  MedicalCenterList({required this.nearbyCenters});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: nearbyCenters.length,
        itemBuilder: (context, index) {
          final center = nearbyCenters[index];
          return Container(
            width: 200,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      center.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(center.title,
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text('${center.locationName} · ${center.distanceKm} km',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          );
        },
      ),
    );
  }
}
