part of 'search_bloc.dart';

sealed class SearchEvent {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

final class SearchStarted extends SearchEvent {
  const SearchStarted();
}

final class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

final class SearchCategoryChanged extends SearchEvent {
  final String? category; // null = All
  const SearchCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

final class SearchSortChanged extends SearchEvent {
  final SortMode sort;
  const SearchSortChanged(this.sort);

  @override
  List<Object?> get props => [sort];
}

final class SearchToggleOrder extends SearchEvent {
  const SearchToggleOrder();
}

final class SearchLoadMoreRequested extends SearchEvent {
  const SearchLoadMoreRequested();
}
