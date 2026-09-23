import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_controller.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';

abstract final class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ValueNotifier(ref.read(authControllerProvider));
  ref.listen(authControllerProvider, (_, next) => authState.value = next);

  final router = GoRouter(
    initialLocation: Routes.dashboard,
    refreshListenable: authState,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final location = state.matchedLocation;

      // Hold every route on the splash screen until the saved session is checked,
      // remembering where the user was headed
      if (auth.isLoading) {
        if (location == Routes.splash) return null;
        return Uri(path: Routes.splash, queryParameters: {'from': state.uri.toString()}).toString();
      }

      final loggedIn = auth.value != null;
      final onAuthPage = location == Routes.login || location == Routes.register;

      if (location == Routes.splash) {
        final from = state.uri.queryParameters['from'];
        if (!loggedIn) return Routes.login;
        return from != null && from.startsWith('/') && !from.startsWith(Routes.splash)
            ? from
            : Routes.dashboard;
      }
      if (!loggedIn && !onAuthPage) return Routes.login;
      if (loggedIn && onAuthPage) return Routes.dashboard;
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (_, _) => Routes.dashboard),
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: Routes.register, builder: (_, _) => const RegisterScreen()),
      GoRoute(path: Routes.dashboard, builder: (_, _) => const DashboardScreen()),
    ],
  );

  ref.onDispose(() {
    authState.dispose();
    router.dispose();
  });
  return router;
});

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Myafrimall',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
