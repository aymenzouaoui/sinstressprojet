import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.orangeAccent,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with actual image URL
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Farshad Roshan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    '+31611133458',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ProfileMenuItem(
                  icon: Icons.edit,
                  text: 'Edit Personal Info',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.star,
                  text: 'Loyalty Points',
                  trailing: const Text('126', style: TextStyle(fontSize: 16, color: Colors.black)),
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.notifications,
                  text: 'Notification Preferences',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.support,
                  text: 'Support',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.article,
                  text: 'Term & Conditions',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.info,
                  text: 'About',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.logout,
                  text: 'Log Out',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 3, // Profile tab selected
        selectedItemColor: Colors.blue,
        onTap: (index) {
          // Handle bottom navigation tap
        },
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget? trailing;
  final VoidCallback onTap;

  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.text,
    this.trailing,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}
