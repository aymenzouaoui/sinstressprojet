import 'package:client/models/sinistre.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:client/models/car.dart'; // Import Car class from the correct file
import 'sinistre_detail_screen.dart';


class SuiviScreen extends StatefulWidget {
  @override
  _SuiviScreenState createState() => _SuiviScreenState();
}

class _SuiviScreenState extends State<SuiviScreen> {
  List<Claim> claims = [
    Claim(
      type: 'Accident',
      description: 'Car accident at main street.',
      incidentDate: DateTime(2023, 5, 15),
      status: 'Processing',
    ),
    Claim(
      type: 'Theft',
      description: 'Bike stolen from garage.',
      incidentDate: DateTime(2023, 4, 10),
      status: 'Approved',
    ),
    Claim(
      type: 'Damage',
      description: 'House damaged by hailstorm.',
      incidentDate: DateTime(2023, 3, 20),
      status: 'Rejected',
    ),
    Claim(
      type: 'Other',
      description: 'Lost phone.',
      incidentDate: DateTime(2023, 6, 1),
      status: 'Processing',
    ),
  ];

  String _searchLocation = '';
  String? _selectedStatus;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    List<Claim> filteredClaims = claims.where((claim) {
      bool matchesLocation = _searchLocation.isEmpty ||
          claim.description.toLowerCase().contains(_searchLocation.toLowerCase());
      bool matchesStatus = _selectedStatus == null || claim.status == _selectedStatus;
      bool matchesDate = _selectedDate == null ||
          (claim.incidentDate.year == _selectedDate!.year &&
              claim.incidentDate.month == _selectedDate!.month &&
              claim.incidentDate.day == _selectedDate!.day);
      return matchesLocation && matchesStatus && matchesDate;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Claim Status'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: filteredClaims.length,
          itemBuilder: (context, index) {
            final claim = filteredClaims[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: Icon(
                  _getIconForClaimType(claim.type),
                  size: 40,
                  color: Colors.blue,
                ),
                title: Text(
                  claim.type,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      claim.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Incident Date: ${DateFormat.yMMMd().format(claim.incidentDate)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          'Status: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Chip(
                          label: Text(
                            claim.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: _getStatusColor(claim.status),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to SinistreDetailScreen when a claim is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SinistreDetailScreen(sinistre: _convertClaimToSinistre(claim)),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Sinistre _convertClaimToSinistre(Claim claim) {
    return Sinistre(
      id: '1',
      userId: 'user1',
      description: claim.description,
      status: claim.status,
      location: 'Sample Location',
      photos: ['https://via.placeholder.com/150'],
      dateReported: claim.incidentDate,
      car: Car(
        id: '1',
        make: 'Toyota',
        model: 'Corolla',
        year: 2020,
        licensePlate: 'XYZ123',
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search by Location'),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Enter location'),
            onChanged: (value) {
              setState(() {
                _searchLocation = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Claims'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(hintText: 'Select status'),
                value: _selectedStatus,
                items: ['Processing', 'Approved', 'Rejected']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    hintText: 'Select date',
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'No date selected'
                        : DateFormat.yMMMd().format(_selectedDate!),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedStatus = null;
                  _selectedDate = null;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Clear Filters'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  IconData _getIconForClaimType(String type) {
    switch (type) {
      case 'Accident':
        return Icons.directions_car;
      case 'Theft':
        return Icons.directions_bike;
      case 'Damage':
        return Icons.home;
      default:
        return Icons.device_unknown;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}

class Claim {
  final String type;
  final String description;
  final DateTime incidentDate;
  final String status;

  Claim({
    required this.type,
    required this.description,
    required this.incidentDate,
    required this.status,
  });
}
