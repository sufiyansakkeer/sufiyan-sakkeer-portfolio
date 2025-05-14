import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:js' as js;
import 'package:portfolio/config/theme.dart';
import 'package:portfolio/config/theme_provider.dart';
import 'package:portfolio/config/routes.dart';
import 'package:portfolio/utils/constants.dart';
import 'package:portfolio/screens/home_screen.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Hide the loading screen when the app is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use js to call the JavaScript function
      if (js.context.hasProperty('hideLoadingScreen')) {
        js.context.callMethod('hideLoadingScreen', []);
      }
    });

    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: '${AppConstants.name} - Portfolio',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(), // Load home screen directly
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
