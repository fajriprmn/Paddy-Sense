import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import 'dashboard_screen.dart';
import 'camera_screen.dart';
import 'history_screen.dart';
import 'library_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            DashboardScreen(),
            CameraScreen(),
            HistoryScreen(),
            LibraryScreen(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: TabBar(
            tabs: const [
              Tab(
                icon: Icon(Icons.home_outlined),
                text: AppStrings.navDashboard,
              ),
              Tab(
                icon: Icon(Icons.history),
                text: AppStrings.navHistory,
              ),
              Tab(
                icon: Icon(Icons.library_books_outlined),
                text: AppStrings.navLibrary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
