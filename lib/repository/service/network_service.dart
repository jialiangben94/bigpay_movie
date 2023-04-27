import 'dart:convert';

import 'package:bigpay_movie/repository/service/exceptions.dart';
import 'package:http/http.dart' as http;

abstract class NetworkService {
  final String baseUrl = 'https://api.themoviedb.org/3/';
  final String apiKey = '4f751929ba0c82c8e35abab56a5a3992';

  Future<Map<String, dynamic>> get(String url, int page) async {
    try {
      final uri = Uri.parse('$baseUrl$url?api_key=$apiKey&page=$page');
      final response = await http.get(uri).timeout(const Duration(seconds: 20),
          onTimeout: () {
        throw TimeOutException();
      });

      switch (response.statusCode) {
        case 200:
          return jsonDecode(response.body);
        case 400:
          throw InvalidRequestException();
        case 404:
          throw NotFoundException();
        case 500:
          throw InternalServerErrorException();
        default:
          throw NoConnectionException();
      }
    } catch (e) {
      throw NoConnectionException();
    }
  }
}
