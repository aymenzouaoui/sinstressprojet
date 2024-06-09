import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Adjust the length based on the number of tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Profile'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Personal Info'),
            Tab(text: 'Loyalty Points'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PersonalInfoTab(),
          LoyaltyPointsTab(),
          SettingsTab(),
        ],
      ),
    );
  }
}

class PersonalInfoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
            ],
          ),
        ),
      ],
    );
  }
}

class LoyaltyPointsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProfileMenuItem(
          icon: Icons.star,
          text: 'Loyalty Points',
          trailing: const Text('126', style: TextStyle(fontSize: 16, color: Colors.black)),
          onTap: () {},
        ),
      ],
    );
  }
}

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
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
