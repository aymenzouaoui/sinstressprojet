import 'package:flutter/material.dart';
import '../../data/repository.dart';
import '../../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Repository _repository = Repository();
  late Future<User?> _userFuture;
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userFuture = _repository.getUserById('user@example.com'); // Replace with actual user ID/email
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      _formKey.currentState!.save();

      // Simulate a user update (you would implement proper user update here)
      User updatedUser = User(
        id: _email, // Assuming email is used as ID
        name: _name,
        email: _email,
        phoneNumber: _phoneNumber,
      );

      bool success = await _repository.createUser(updatedUser);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Profil mis à jour avec succès.'
              : 'Échec de la mise à jour du profil.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement des données.'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Aucun utilisateur trouvé.'));
          } else {
            User user = snapshot.data!;
            _name = user.name;
            _email = user.email;
            _phoneNumber = user.phoneNumber;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 34,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.34,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: _name,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: _email,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      initialValue: _phoneNumber,
                      decoration: InputDecoration(
                        hintText: 'Enter your phone number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _phoneNumber = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2F80ED),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Update Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.17,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
