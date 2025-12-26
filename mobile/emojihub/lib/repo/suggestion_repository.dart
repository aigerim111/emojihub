import 'package:dio/dio.dart';
import 'package:emojihub/api/api.dart';
import 'package:emojihub/models/suggestion.dart';
import 'api_failure.dart';

class SuggestionRepository {
  final ApiClient _api;
  SuggestionRepository(this._api);

  Future<Suggestion> getSuggestions({String? topic}) async {
    try {
      final t = topic?.trim();
      return await _api.getSuggestions(
        topic: (t == null || t.isEmpty) ? null : t,
      );
    } on DioException catch (e) {
      throw ApiFailure.fromDio(e);
    }
  }
}
