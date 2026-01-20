import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/blocs/bloc_observer.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/colors.dart';
import 'features/bottom_nav/presentation/pages/bottom_nav_page.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  if (kDebugMode) Bloc.observer = AppBlocObserver();
  await initDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TenTwenty',
      theme: AppTheme.lightTheme,
      home: const BottomNavPage(),
    );
  }
}
