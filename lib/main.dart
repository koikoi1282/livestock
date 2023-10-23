import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:livestock/bloc/authentication/authentication_bloc.dart';
import 'package:livestock/bloc/game/game_bloc.dart';
import 'package:livestock/bloc/game_data/game_data_bloc.dart';
import 'package:livestock/bloc/result/result_bloc.dart';
import 'package:livestock/constants/color.dart';
import 'package:livestock/firebase_options.dart';
import 'package:livestock/repository/authentication_repository.dart';
import 'package:livestock/repository/game_data_repository.dart';
import 'package:livestock/repository/game_repository.dart';
import 'package:livestock/repository/result_repository.dart';
import 'package:livestock/router/router.dart';
import 'package:livestock/utils/image_utils.dart';

void main() async {
  usePathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiRepositoryProvider(
    providers: [
      RepositoryProvider(create: (context) => AuthenticationRepository()),
      RepositoryProvider(create: (context) => GameRepository()),
      RepositoryProvider(create: (context) => GameDataRepository()),
      RepositoryProvider(create: (context) => ResultRepository()),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthenticationBloc(context.read<AuthenticationRepository>())),
        BlocProvider(create: (context) => GameBloc(context.read<GameRepository>())),
        BlocProvider(create: (context) => GameDataBloc(context.read<GameDataRepository>())),
        BlocProvider(create: (context) => ResultBloc(context.read<ResultRepository>())),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ImageUtils.precacheAllAsset(context);

    return MaterialApp.router(
      title: 'Cargill Taiwan games',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        inputDecorationTheme: const InputDecorationTheme(errorStyle: TextStyle(fontSize: 10)),
        colorScheme: ColorScheme.fromSeed(seedColor: primaryGreen, background: Colors.white, error: Colors.red),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
