import 'package:dio/dio.dart';
import 'package:emojihub/models/emoji.dart';
import 'package:emojihub/models/suggestion.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  // Search page
  @GET('/api/categories')
  Future<List<String>> getCategories();

  @GET('/api/emojis')
  Future<EmojiPage> getEmojis({
    @Query('query') String? query,
    @Query('category') String? category,
    @Query('sort') String sort = 'alpha',
    @Query('order') String order = 'asc',
    @Query('skip') int skip = 0,
    @Query('take') int take = 50,
  });

  // Suggestions page (LLM -> backend -> cached 24h)
  @GET('/api/suggestions')
  Future<Suggestion> getSuggestions({@Query('topic') String? topic});
}
