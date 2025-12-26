import 'package:json_annotation/json_annotation.dart';

part 'suggestion.g.dart';

@JsonSerializable()
class Suggestion {
  @JsonKey(defaultValue: '')
  final String topic;
  @JsonKey(defaultValue: '')
  final String generatedAtUtc;
  @JsonKey(defaultValue: <String>[])
  final List<String> emojis;
  @JsonKey(defaultValue: false)
  final bool fromCache;

  const Suggestion({
    required this.topic,
    required this.generatedAtUtc,
    required this.emojis,
    required this.fromCache,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) =>
      _$SuggestionFromJson(json);
  Map<String, dynamic> toJson() => _$SuggestionToJson(this);
}
