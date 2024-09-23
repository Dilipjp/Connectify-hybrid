import 'package:connectify/view_models/theme/theme_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connectify/components/life_cycle_event_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectify/splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
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
            debugShowCheckedModeBanner: false,
            theme: themeData(
              notifier.dark ? Constants.darkTheme : Constants.lightTheme,
            ),
            home: Splashscreen(),
          );
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

}
