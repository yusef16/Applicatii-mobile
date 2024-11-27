import 'package:flutter/material.dart';

class LocationAndNotification extends StatefulWidget {
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
              Icon(Icons.location_on, color: Colors.blue),
              SizedBox(width: 5),
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
                    child: Text(value, style: TextStyle(fontSize: 16)),
                  );
                }).toList(),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
