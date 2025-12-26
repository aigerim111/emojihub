part of 'search_bloc.dart';

enum SearchStatus { idle, loading, loadingMore, success, failure }

class SearchState {
  static const int pageSize = 50;

  final SearchStatus status;
  final String query;
  final List<String> categories;
  final String? selectedCategory;

  final SortMode sort;
  final bool desc;

  final List<EmojiItem> items;
  final int total;
  final int skip;

  final String? error;

  const SearchState({
    this.status = SearchStatus.idle,
    this.query = '',
    this.categories = const [],
    this.selectedCategory,
    this.sort = SortMode.alpha,
    this.desc = false,
    this.items = const [],
    this.total = 0,
    this.skip = 0,
    this.error,
  });

  bool get canLoadMore => items.length < total;

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<String>? categories,
    String? selectedCategory,
    SortMode? sort,
    bool? desc,
    List<EmojiItem>? items,
    int? total,
    int? skip,
    String? error,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      sort: sort ?? this.sort,
      desc: desc ?? this.desc,
      items: items ?? this.items,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    query,
    categories,
    selectedCategory,
    sort,
    desc,
    items,
    total,
    skip,
    error,
  ];
}
