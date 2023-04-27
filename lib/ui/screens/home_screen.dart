import 'package:bigpay_movie/ui/screens/movie_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../cubit/movie/movie_cubit.dart';
import '../../model/movie_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  RefreshController? _refreshController;
  List<MovieModel> movies = [];
  int page = 0;

  bool _lock = false;
  bool _isMax = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _refreshController = RefreshController(initialRefresh: false);
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= 50) {
        if (_lock || _isMax) return;
        _lock = true;
        fetchMovies();
      }
    });
    fetchMovies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  fetchMovies() {
    BlocProvider.of<MovieCubit>(context).getPopularMovie(page + 1);
  }

  showError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ));
    });
  }

  @override
  Widget build(BuildContext gContext) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Popular Movies",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 20,
        ),
        body: Scrollbar(
          controller: _scrollController,
          thickness: 10.0,
          interactive: true,
          child: SmartRefresher(
            controller: _refreshController!,
            scrollController: _scrollController,
            enablePullDown: true,
            onRefresh: () {
              page = 0;
              _isMax = false;
              fetchMovies();
            },
            child: SingleChildScrollView(
              child: _blocBuilder(),
            ),
          ),
        ));
  }

  Widget _blocBuilder() {
    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        if (state.status == MovieStatus.loading && movies.isEmpty) {
          return const SizedBox(
              height: 200, child: Center(child: CircularProgressIndicator()));
        } else if (state.status == MovieStatus.loaded) {
          page++;
          if (page == 1) {
            movies = state.movies;
          } else {
            movies.addAll(state.movies);
          }
          if (state.movies.isEmpty) {
            _isMax = true;
          }

          _lock = false;
        } else if (state.status == MovieStatus.error) {
          showError(state.error);
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _refreshController?.refreshCompleted();
        });

        return Column(
          children: [
            _movieList(),
            if (!_isMax)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                    child: state.status != MovieStatus.error
                        ? const CircularProgressIndicator()
                        : IconButton(
                            onPressed: fetchMovies,
                            icon: const Icon(Icons.refresh))),
              )
          ],
        );
      },
    );
  }

  Widget _movieList() {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(5),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: movies.map((e) {
        return MovieCard(
          model: e,
          key: Key(e.id.toString()),
        );
      }).toList(),
    );
  }
}
