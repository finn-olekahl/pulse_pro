import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';

import 'package:pulse_pro/features/home/view/widgets/dock/dock.dart';
import 'package:pulse_pro/features/home/view/widgets/dock/dock_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final DockController _dockController = DockController();

  final PreloadPageController _pageController = PreloadPageController();

  int _currentScreen = 0;

  bool _pageSwitchFromDock = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PreloadPageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (!_pageSwitchFromDock) {
            _dockController.moveSliderTo(index < 2 ? index : index + 1);
          }
          if (_pageSwitchFromDock) {
            if (_currentScreen == index) {
              _pageSwitchFromDock = false;
            }
          }
        },
        children: [
          Container(
            color: Colors.red,
          ),
          Container(
            color: Colors.black,
          ),
          Container(
            color: Colors.blue,
          ),
          Container(
            color: Colors.yellow,
          ),
        ],
      ),
      bottomNavigationBar: Dock(
        controller: _dockController,
        currentIndex: _currentScreen,
        initialPadding: const EdgeInsets.only(left: 10, right: 10),
        onTap: (index) {
          _pageSwitchFromDock = true;

          if (_currentScreen != index) {
            _currentScreen = index;
          }
          _pageController.animateToPage(_currentScreen,
              duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
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
