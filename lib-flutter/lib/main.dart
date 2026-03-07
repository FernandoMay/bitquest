import 'package:bitquest/features/ai_tutor/bloc/ai_tutor_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/colors.dart';
import 'core/services/storage_service.dart';
import 'features/missions/data/repositories/mission_repository_impl.dart';
import 'features/missions/presentation/bloc/missions_bloc.dart';
import 'features/ai_tutor/bloc/ai_tutor_bloc.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.darkBlue,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.darkBlue,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Initialize storage
  await StorageService.instance.init();
  
  runApp(const BITQUESTApp());
}

class BITQUESTApp extends StatelessWidget {
  const BITQUESTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MissionsBloc(
            repository: MissionRepositoryImpl(),
          )..add(LoadMissions()),
        ),
        BlocProvider(
          create: (context) => AiTutorBloc()..add(const InitializeChat()),
        ),
      ],
      child: MaterialApp(
        title: 'BITQUEST',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomePage(),
      ),
    );
  }
}
