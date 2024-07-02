import 'package:client/screens/sinistre/sinistre_form_screen.dart';
import 'package:client/screens/sinistre/suivi_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class BottomNavProvider with ChangeNotifier {
  int _bottomNavIndex = 0;
  late Animation<double> _borderRadiusAnimation;
  late AnimationController _hideBottomBarAnimationController;

  int get bottomNavIndex => _bottomNavIndex;

  set bottomNavIndex(int index) {
    _bottomNavIndex = index;
    notifyListeners();
  }

  void setBorderRadiusAnimation(Animation<double> animation) {
    _borderRadiusAnimation = animation;
  }

  Animation<double> get borderRadiusAnimation => _borderRadiusAnimation;

  void setHideBottomBarAnimationController(AnimationController controller) {
    _hideBottomBarAnimationController = controller;
  }

  AnimationController get hideBottomBarAnimationController =>
      _hideBottomBarAnimationController;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;

  final iconList = <IconData>[
    Icons.home_filled,
    Icons.menu,
    Icons.mail,
    Icons.person_outline,
  ];

  @override
  void initState() {
    super.initState();

    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    fabCurve = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
    borderRadiusCurve = CurvedAnimation(
      parent: _borderRadiusAnimationController,
      curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(fabCurve);
    borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      borderRadiusCurve,
    );

    _hideBottomBarAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    var bottomNavProvider =
        Provider.of<BottomNavProvider>(context, listen: false);
    bottomNavProvider
        .setHideBottomBarAnimationController(_hideBottomBarAnimationController);
    bottomNavProvider.setBorderRadiusAnimation(borderRadiusAnimation);

    Future.delayed(
      Duration(seconds: 1),
      () => _fabAnimationController.forward(),
    );
    Future.delayed(
      Duration(seconds: 1),
      () => _borderRadiusAnimationController.forward(),
    );
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification &&
        notification.metrics.axis == Axis.vertical) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          _hideBottomBarAnimationController.reverse();
          _fabAnimationController.forward(from: 0);
          break;
        case ScrollDirection.reverse:
          _hideBottomBarAnimationController.forward();
          _fabAnimationController.reverse(from: 1);
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(widget.title,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3366FF), Color(0xFF00CCFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Handle menu
          },
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: onScrollNotification,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WelcomeCard(),
                const SizedBox(height: 16),
                HorizontalList(screenWidth: screenWidth),
                const SizedBox(height: 16),
                VerticalList(),
                const SizedBox(height: 16), // Added padding between the list and bottom navigation bar
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Consumer<BottomNavProvider>(
        builder: (context, provider, child) {
          return AnimatedBottomNavigationBar.builder(
            itemCount: iconList.length,
            tabBuilder: (int index, bool isActive) {
              final color =
                  isActive ? Color.fromARGB(204, 227, 20, 20) : Color.fromARGB(255, 40, 28, 206);
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(iconList[index], size: 24, color: color),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AutoSizeText(
                      '', // Ajouter les noms des onglets ici
                      maxLines: 1,
                      style: TextStyle(color: color),
                    ),
                  ),
                ],
              );
            },
            backgroundColor: Colors.white,
            activeIndex: provider.bottomNavIndex,
            splashColor: Colors.blue,
            notchAndCornersAnimation: provider.borderRadiusAnimation,
            splashSpeedInMilliseconds: 300,
            notchSmoothness: NotchSmoothness.defaultEdge,
            gapLocation: GapLocation.center,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
            onTap: (index) => provider.bottomNavIndex = index,
            hideAnimationController: provider.hideBottomBarAnimationController,
            shadow: BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 12,
              spreadRadius: 0.5,
              color: Colors.blue,
            ),
          );
        },
      ),
    );
  }
}

class WelcomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue à Sinistre Assurance',
              style: TextStyle(
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Que pouvons-nous faire pour vous ?',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class HorizontalList extends StatelessWidget {
  final double screenWidth;

  HorizontalList({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    double cardWidth = screenWidth * 0.4; // Adapts the card width

    return Container(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCard(context, 'Assurance Véhicule', Icons.car_rental, cardWidth,
              AssuranceVehiculePage()),
          const SizedBox(width: 6),
          _buildCard(context, 'Liste Des Véhicules', Icons.list, cardWidth,
              ListeDesVehiculesPage()),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon,
      double width, Widget destinationPage) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => destinationPage));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: width,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
class VerticalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildListItem(context, 'Déclaration Un Sinistre', 'Un accident?', Icons.report, SinistreFormScreen()),
        const Divider(),
        _buildListItem(context, 'Suivre Un Sinistre', 'Suivrez vos sinistres', Icons.track_changes, SuiviScreen()),
        const Divider(),
        _buildListItem(context, 'Demander Un Assistant', 'Suivrez vos sinistres', Icons.assistant, SuiviScreen()),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, String title, String subtitle, IconData icon, Widget screen) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontSize: 18)),
      subtitle: Text(subtitle),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        // Handle list item tap
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }
}
class AssuranceVehiculePage extends StatelessWidget {
  final autoSizeGroup = AutoSizeGroup();

  final iconList = <IconData>[
    Icons.home,
    Icons.menu,
    Icons.mail,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assurance Véhicule'),
      ),
      body: Center(
        child: Text('Page d\'Assurance Véhicule'),
      ),
      bottomNavigationBar: Consumer<BottomNavProvider>(
        builder: (context, provider, child) {
          return AnimatedBottomNavigationBar.builder(
            itemCount: iconList.length,
            tabBuilder: (int index, bool isActive) {
              final color =
                  isActive ? Color.fromARGB(204, 227, 20, 20) : Color.fromARGB(255, 40, 28, 206);
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(iconList[index], size: 24, color: color),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AutoSizeText(
                      '', // Ajouter les noms des onglets ici
                      maxLines: 1,
                      style: TextStyle(color: color),
                      group: autoSizeGroup,
                    ),
                  )
                ],
              );
            },
            backgroundColor: Colors.white,
            activeIndex: provider.bottomNavIndex,
            splashColor: Colors.blue,
            notchAndCornersAnimation: provider.borderRadiusAnimation,
            splashSpeedInMilliseconds: 300,
            notchSmoothness: NotchSmoothness.defaultEdge,
            gapLocation: GapLocation.center,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
            onTap: (index) => provider.bottomNavIndex = index,
            hideAnimationController: provider.hideBottomBarAnimationController,
            shadow: BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 12,
              spreadRadius: 0.5,
              color: Colors.blue,
            ),
          );
        },
      ),
    );
  }
}

class ListeDesVehiculesPage extends StatelessWidget {
  final autoSizeGroup = AutoSizeGroup();

  final iconList = <IconData>[
    Icons.notifications_on_sharp,
    Icons.menu,
    Icons.mail,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Véhicules'),
      ),
      body: Center(
        child: Text('Page de la Liste des Véhicules'),
      ),
      bottomNavigationBar: Consumer<BottomNavProvider>(
        builder: (context, provider, child) {
          return AnimatedBottomNavigationBar.builder(
            itemCount: iconList.length,
            tabBuilder: (int index, bool isActive) {
              final color =
                  isActive ? Color.fromARGB(204, 227, 20, 20) : Color.fromARGB(255, 40, 28, 206);
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(iconList[index], size: 24, color: color),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AutoSizeText(
                      '', // Ajouter les noms des onglets ici
                      maxLines: 1,
                      style: TextStyle(color: color),
                      group: autoSizeGroup,
                    ),
                  )
                ],
              );
            },
            backgroundColor: Colors.white,
            activeIndex: provider.bottomNavIndex,
            splashColor: Colors.blue,
            notchAndCornersAnimation: provider.borderRadiusAnimation,
            splashSpeedInMilliseconds: 300,
            notchSmoothness: NotchSmoothness.defaultEdge,
            gapLocation: GapLocation.center,
            leftCornerRadius: 32,
            rightCornerRadius: 32,
            onTap: (index) => provider.bottomNavIndex = index,
            hideAnimationController: provider.hideBottomBarAnimationController,
            shadow: BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 12,
              spreadRadius: 0.5,
              color: Colors.blue,
            ),
          );
        },
      ),
    );
  }
}
