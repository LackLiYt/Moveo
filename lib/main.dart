import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moveo/common/error_page.dart';
import 'package:moveo/common/loading_page.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/features/auth/view/sign_up_page.dart';
import 'package:moveo/features/home/view/home_view.dart';
import 'package:moveo/theme/app_theme.dart';
import 'package:moveo/theme/theme_provider.dart';
import 'package:moveo/core/providers.dart';
import 'package:appwrite/appwrite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Mobile-specific optimizations
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      // Ensure status bar text is visible on both light and dark themes
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Enable hardware acceleration
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  runApp(
    const ProviderScope(
      child: MyApp()
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the theme mode
    final themeMode = ref.watch(themeProvider);

    // Initialize Appwrite client with error handling
    try {
      ref.watch(appwriteClientProvider);
    } on AppwriteException catch (e) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Moveo',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: ErrorPage(error: 'Failed to connect to Appwrite: ${e.message}'),
      );
    } catch (e) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Moveo',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: ErrorPage(error: 'An unexpected error occurred: $e'),
      );
    }
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moveo',
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      builder: (context, child) {
        // Add compatibility optimizations for all screens
        return MediaQuery(
          // Ensure consistent text scaling across devices
          data: MediaQuery.of(context).copyWith(
            padding: MediaQuery.of(context).padding,
            // Handle safe areas properly
            viewInsets: MediaQuery.of(context).viewInsets, textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2)),
          ),
          child: child!,
        );
      },
      home: ref.watch(currentUserAccountProvider).when(
            data: (user) {
              if (user != null) {
                return const HomeView();
              }
              return const SignUpPage();
            },
            error: (error, st) => ErrorPage(error: error.toString()),
            loading: () => const LoadingPage(),
          ),
    );
  }
}
