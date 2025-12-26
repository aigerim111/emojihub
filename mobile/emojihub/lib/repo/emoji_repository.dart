import 'package:dio/dio.dart';
import 'package:emojihub/api/api.dart';
import 'package:emojihub/models/emoji.dart';
import 'api_failure.dart';

enum SortMode { alpha, category }

extension SortModeX on SortMode {
  String toApi() => this == SortMode.alpha ? 'alpha' : 'category';
}

class EmojiRepository {
  final ApiClient _api;
  EmojiRepository(this._api);

  Future<List<String>> categories() async {
    try {
      return await _api.getCategories();
    } on DioException catch (e) {
      throw ApiFailure.fromDio(e);
    }
  }

  Future<EmojiPage> search({
    required String query,
    String? category,
    SortMode sort = SortMode.alpha,
    bool desc = false,
    int skip = 0,
    int take = 50,
  }) async {
    try {
      return await _api.getEmojis(
        query: query.trim().isEmpty ? null : query.trim(),
        category: (category == null || category.trim().isEmpty)
            ? null
            : category.trim(),
        sort: sort.toApi(),
        order: desc ? 'desc' : 'asc',
        skip: skip,
        take: take,
      );
    } on DioException catch (e) {
      throw ApiFailure.fromDio(e);
    }
  }
}
