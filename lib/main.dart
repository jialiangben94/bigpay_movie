import 'package:bigpay_movie/cubit/movie/movie_cubit.dart';
import 'package:bigpay_movie/repository/movie_repository.dart';
import 'package:bigpay_movie/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MovieRepository movieRepository = MovieRepository();
    return MaterialApp(
      title: 'BigPay Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => MovieCubit(movieRepository),
        child: const HomeScreen(),
      ),
    );
  }
}
