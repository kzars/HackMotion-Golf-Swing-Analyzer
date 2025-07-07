import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bloc/golf_swing_cubit.dart';
import 'pages/home_page.dart';
import 'theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const HackMotionApp());
}

class HackMotionApp extends StatelessWidget {
  const HackMotionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HackMotion Golf',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: GoogleFonts.inter().fontFamily,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.primaryDark,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
        ),
      ),
      home: BlocProvider(
        create: (context) => GolfSwingCubit()..loadSwings(),
        child: const HomePage(),
      ),
    );
  }
}
