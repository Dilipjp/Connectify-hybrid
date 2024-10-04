import 'package:connectify/Register/register.dart';
import 'package:connectify/screens/FogotPassword.dart';
import 'package:connectify/screens/mainscreen.dart';
import 'package:connectify/services/user_service.dart';
import 'package:connectify/utils/config.dart';
import 'package:connectify/utils/constants.dart';
import 'package:connectify/utils/providers.dart';
import 'package:connectify/view_models/theme/theme_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:connectify/components/life_cycle_event_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectify/splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Login/login.dart';
import 'firebase_options.dart';

import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.initFirebase(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        detachedCallBack: () => UserService().setUserStatus(false),
        resumeCallBack: () => UserService().setUserStatus(true),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, Widget? child) {
          return MaterialApp(
            title: "Connectify App",

            initialRoute: '/splash',
            routes: {
              '/splash': (context) => Splashscreen(),
              '/login': (context) => Login(),
              '/signup': (context) => Register(),
              '/home': (context) => TabScreen(),
              '/forget-password': (context) => ForgetPasswordScreen(),

            });
        },
      ),
    );
  }

    ThemeData themeData(ThemeData theme) {
      return theme.copyWith(
        textTheme: GoogleFonts.nunitoTextTheme(
          theme.textTheme,
        ),
      );
    }

=======
import 'screens/splash_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
      routes: {
        '/sign-in': (context) => SignInScreen(),
        '/sign-up': (context) => SignUpScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
>>>>>>> f777a7b046bdee987911d81dcfc7ca05fbbb8eaa
}
