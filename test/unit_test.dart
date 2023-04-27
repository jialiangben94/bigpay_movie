import 'package:bigpay_movie/cubit/movie/movie_cubit.dart';
import 'package:bigpay_movie/model/movie_model.dart';
import 'package:bigpay_movie/repository/movie_repository.dart';
import 'package:bigpay_movie/repository/service/exceptions.dart';
import 'package:bigpay_movie/ui/screens/home_screen.dart';
import 'package:bigpay_movie/ui/screens/movie_card.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bigpay_movie/main.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieRepositroy extends Mock implements MovieRepository {}

void main() {
  late MockMovieRepositroy movieRepository;
  late MovieCubit movieCubit;
  final MovieModel movie =
      MovieModel(id: 1, posterPath: "test", title: "testing title");
  final RequestException sampleError = RequestException('Failed to load data');

  setUp(() {
    movieRepository = MockMovieRepositroy();
    movieCubit = MovieCubit(movieRepository);
  });

  group('HomeScreen', () {
    testWidgets('Show loading indicator when first load', (tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Show movie card after retreive data', (tester) async {
      when(() => movieRepository.getPoularMovie(1))
          .thenAnswer((invocation) async => [movie]);
      await tester.runAsync(() async {
        await tester.pumpWidget(MaterialApp(
          title: 'BigPay Movie App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: BlocProvider(
            create: (context) => MovieCubit(movieRepository),
            child: const HomeScreen(),
          ),
        ));
        await tester.pump();
      }).then((value) {
        expect(find.byType(MovieCard), findsOneWidget);
      });
    });
  });

  group('Movie Repository', () {
    blocTest<MovieCubit, MovieState>('Successfully get popular movie',
        setUp: () {
          when(() => movieRepository.getPoularMovie(1))
              .thenAnswer((invocation) async => [movie]);
        },
        build: () => movieCubit,
        act: (bloc) => movieCubit.getPopularMovie(1),
        expect: () => <MovieState>[
              const MovieState(status: MovieStatus.loading),
              MovieState(status: MovieStatus.loaded, movies: [movie]),
            ],
        verify: (_) async {
          verify((() => movieRepository.getPoularMovie(1))).called(1);
        });

    blocTest<MovieCubit, MovieState>('Failed to get popular movie',
        setUp: () {
          when(() => movieRepository.getPoularMovie(1)).thenThrow(sampleError);
        },
        build: () => movieCubit,
        act: (bloc) => movieCubit.getPopularMovie(1),
        expect: () => <MovieState>[
              const MovieState(status: MovieStatus.loading),
              MovieState(
                  status: MovieStatus.error, error: sampleError.errorMessage),
            ],
        verify: (_) async {
          verify((() => movieRepository.getPoularMovie(1))).called(1);
        });
  });
}
