// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse_pro/features/splash/view/splash_screen.dart';


void main() {
  group('path routes', () {
     testWidgets('match home route', (WidgetTester tester) async {
      final List<GoRoute> routes = <GoRoute>[
        GoRoute(
            path: '/',
            builder: (BuildContext context, GoRouterState state) =>
                const SplashScreen()),
      ];

      final GoRouter router = await createRouter(routes, tester);
      final RouteMatchList matches = router.routerDelegate.currentConfiguration;
      expect(matches.matches, hasLength(1));
      expect(matches.uri.toString(), '/');
      expect(find.byType(SplashScreen), findsOneWidget);
    });
  });
}

Future<GoRouter> createRouter(
  List<RouteBase> routes,
  WidgetTester tester, {
  String initialLocation = '/',
}) async {
  final GoRouter goRouter = GoRouter(
    routes: routes,
    initialLocation: initialLocation,
  );
  addTearDown(goRouter.dispose);
  await tester.pumpWidget(
    MaterialApp.router(
      routerConfig: goRouter,
    ),
  );
  return goRouter;
}
