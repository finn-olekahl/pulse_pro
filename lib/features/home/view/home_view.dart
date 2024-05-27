import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:pulse_pro/features/discover/discover_page.dart';
import 'package:pulse_pro/features/home/cubit/home_cubit.dart';

import 'package:pulse_pro/features/home/view/widgets/dock/dock.dart';
import 'package:pulse_pro/features/home/view/widgets/dock/dock_controller.dart';
import 'package:pulse_pro/features/home/view/widgets/home_content.dart';
import 'package:pulse_pro/features/profile/profile_page.dart';
import 'package:pulse_pro/features/trainings_plan/plan_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final DockController _dockController;

  late final PreloadPageController _pageController;

  int _currentScreen = 0;

  bool _pageSwitchFromDock = false;

  void initState() {
    _dockController = context.read<HomeCubit>().dockController;
    _pageController = PreloadPageController(initialPage: _currentScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PreloadPageView(
        physics: const AlwaysScrollableScrollPhysics(),
        preloadPagesCount: 4,
        controller: _pageController,
        onPageChanged: (index) {
          if (!_pageSwitchFromDock) {
            _dockController.moveSliderTo(index);
          }
          if (_pageSwitchFromDock) {
            if (_currentScreen == index) {
              _pageSwitchFromDock = false;
            }
          }
        },
        children: const [
          HomeContent(),
          DiscoverPage(),
          TrainingPlanPage(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: Dock(
        initialPadding: const EdgeInsets.only(left: 10, right: 10),
        controller: _dockController,
        currentIndex: _currentScreen,
        onTap: (index) {
          _pageSwitchFromDock = true;
          if (_currentScreen != index) {
            setState(() {
              _currentScreen = index;
            });
            if (true) {
              _pageController.animateToPage(_currentScreen,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut);
            }
          }
        },
        items: [
          DockTabItem(text: 'Home'),
          DockTabItem(text: 'Discover'),
          DockTabItem(text: 'Activity'),
          DockTabItem(text: 'Profile'),
        ],
      ), // Hintergrundfarbe ändern
    );
  }
}
