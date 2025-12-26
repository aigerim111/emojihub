import 'package:json_annotation/json_annotation.dart';

part 'emoji.g.dart';

@JsonSerializable()
class EmojiItem {
  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String category;

  @JsonKey(defaultValue: '')
  final String group;

  @JsonKey(defaultValue: <String>[])
  final List<String> htmlCode;

  @JsonKey(defaultValue: <String>[])
  final List<String> unicode;

  // Мы это поле отдаём с ASP.NET (у нас emoji уже декодирован из htmlCode).
  @JsonKey(defaultValue: '')
  final String emoji;

  const EmojiItem({
    required this.name,
    required this.category,
    required this.group,
    required this.htmlCode,
    required this.unicode,
    required this.emoji,
  });

  factory EmojiItem.fromJson(Map<String, dynamic> json) =>
      _$EmojiItemFromJson(json);
  Map<String, dynamic> toJson() => _$EmojiItemToJson(this);
}

@JsonSerializable()
class EmojiPage {
  @JsonKey(defaultValue: 0)
  final int total;

  @JsonKey(defaultValue: 0)
  final int skip;

  @JsonKey(defaultValue: 0)
  final int take;

  @JsonKey(defaultValue: <EmojiItem>[])
  final List<EmojiItem> items;

  const EmojiPage({
    required this.total,
    required this.skip,
    required this.take,
    required this.items,
  });

  factory EmojiPage.fromJson(Map<String, dynamic> json) =>
      _$EmojiPageFromJson(json);
  Map<String, dynamic> toJson() => _$EmojiPageToJson(this);
}
