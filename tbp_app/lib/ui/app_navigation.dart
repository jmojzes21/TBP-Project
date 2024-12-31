import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tbp_app/ui/pages/activities_page.dart';
import 'package:tbp_app/ui/pages/eating_overview_page.dart';
import 'package:tbp_app/ui/pages/physical_indicators_page.dart';
import 'package:tbp_app/ui/pages/training_planning_page.dart';
import 'package:tbp_app/ui/pages/user_page.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  List<Widget> pages = const [
    ActivitiesPage(),
    EatingOverviewPage(),
    PhysicalIndicatorsPage(),
    TrainingPlanningPage(),
    UserPage(),
  ];

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (value) {
          setState(() => currentPageIndex = value);
        },
        destinations: const [
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.personRunning),
            label: 'Aktivnosti',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.carrot),
            label: 'Prehrana',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.weightScale),
            label: 'Težina',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.solidChartBar),
            label: 'Planovi',
          ),
          NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.solidUser),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
