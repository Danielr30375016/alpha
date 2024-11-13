import 'package:alpha/domain/models/car_model.dart';
import 'package:alpha/ui/admin_marketplace/admin_marketplace_screen.dart';
import 'package:alpha/ui/home/home_screen.dart';
import 'package:alpha/ui/login/login_screen.dart';
import 'package:alpha/ui/upload_image/upload_image_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Routes {
  final GoRouter router = GoRouter(
    initialLocation: LoginScreen.routeName,
    redirect: (context, state) {
      final user = _auth.currentUser;
      final loggingIn = state.uri.toString() == LoginScreen.routeName;
      if (user == null && !loggingIn) {
        return LoginScreen.routeName;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: UpLoadImageScreen.routeName,
        builder: (context, state) => UpLoadImageScreen(
          id: state.pathParameters['id']!,
          carModel: state.extra as CarModel?,
        ),
      ),
      GoRoute(
        path: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AdminMarketplaceScreen.routeName,
        builder: (context, state) => const AdminMarketplaceScreen(),
      ),
    ],
  );
}
