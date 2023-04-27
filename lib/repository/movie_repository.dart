import 'package:bigpay_movie/repository/service/exceptions.dart';

import '../model/movie_model.dart';
import 'service/network_service.dart';

class MovieRepository extends NetworkService {
  Future<List<MovieModel>> getPoularMovie(int page) async {
    try {
      final json = await get('movie/popular', page);
      return MovieModelList.fromMap(json).results;
    } on RequestException catch (e) {
      throw RequestException(e.errorMessage);
    } catch (e) {
      throw RequestException(e.toString());
    }
  }
}
