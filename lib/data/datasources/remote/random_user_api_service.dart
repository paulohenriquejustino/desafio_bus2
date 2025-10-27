import 'package:dio/dio.dart';

import '../../../core/exceptions/app_exception.dart';
import '../../../domain/models/user.dart';
import '../../../core/constants/api_constants.dart';

class RandomUserApiService {
  RandomUserApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.baseUrl,
                contentType: 'application/json',
              ),
            );

  final Dio _dio;

  Future<User> fetchRandomUser() async {
    try {
      final response = await _dio.get(ApiConstants.randomUserPath);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw AppException('Resposta inesperada do servidor');
      }

      final results = data['results'];
      if (results is! List || results.isEmpty) {
        throw AppException('Nenhuma pessoa encontrada na resposta da API');
      }

      final userJson = results.first;
      if (userJson is! Map<String, dynamic>) {
        throw AppException('Formato inválido ao converter usuário');
      }

      return User.fromApiJson(userJson);
    } on DioException catch (error) {
      final message = error.message ?? 'Erro de rede ao buscar usuário';
      throw AppException(message);
    }
  }
}
