import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:autism_mobile_app/auth_service.dart';
import 'package:autism_mobile_app/config/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = AuthService();

  final bool isAuthenticated = await authService.isLoggedIn();
  if (isAuthenticated) {
    await authService.getAuthToken();
    authService.setAccountAccessToken();
  }
  // final String? authToken = await authService.getAuthToken();
  runApp(MyApp(isAuthenticated: isAuthenticated));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.isAuthenticated,
  }) : super(key: key);

  final bool? isAuthenticated;

  @override
  Widget build(BuildContext context) {
    // final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Autism',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        splashColor: Colors.blue,
        fontFamily: 'Arial', //'Mirza'
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) =>
          AppRoute().onGenerateRoute(settings, isAuthenticated!),
      // navigatorKey: _navigatorKey,
    );
  }
}
