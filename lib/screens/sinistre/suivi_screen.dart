import 'package:client/models/sinistre.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:client/ViewModel/sinistre_view_model.dart';
import 'sinistre_detail_screen.dart';

class SuiviScreen extends StatefulWidget {
  @override
  _SuiviScreenState createState() => _SuiviScreenState();
}

class _SuiviScreenState extends State<SuiviScreen> {
  @override
  void initState() {
    super.initState();
    final sinistreViewModel = Provider.of<SinistreViewModel>(context, listen: false);
    sinistreViewModel.fetchSinistres(); // Fetch user-specific sinistres
  }

  @override
  Widget build(BuildContext context) {
    final sinistreViewModel = Provider.of<SinistreViewModel>(context);

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
      body: sinistreViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: sinistreViewModel.sinistres.length,
                itemBuilder: (context, index) {
                  final sinistre = sinistreViewModel.sinistres[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      leading: Icon(
                        _getIconForClaimType(sinistre.car.make),
                        size: 40,
                        color: Colors.blue,
                      ),
                      title: Text(
                        sinistre.description,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            sinistre.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Incident Date: ${DateFormat.yMMMd().format(sinistre.dateReported)}',
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
                                  sinistre.status,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: _getStatusColor(sinistre.status),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to SinistreDetailScreen when a sinistre is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SinistreDetailScreen(sinistre: sinistre),
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
                // Handle search by location logic here
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
                value: null,
                items: ['Processing', 'Approved', 'Rejected']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    // Handle status filter logic here
                  });
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      // Handle date filter logic here
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    hintText: 'Select date',
                  ),
                  child: Text(
                    'No date selected',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
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
