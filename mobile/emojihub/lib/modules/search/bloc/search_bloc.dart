import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:emojihub/models/emoji.dart';
import 'package:emojihub/repo/emoji_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_event.dart';
part 'search_state.dart';

const _debounce = Duration(milliseconds: 350);

EventTransformer<E> debounceRestartable<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final EmojiRepository _repo;

  SearchBloc(this._repo) : super(const SearchState()) {
    on<SearchStarted>(_onStarted);
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: debounceRestartable(_debounce),
    );
    on<SearchCategoryChanged>(_onCategoryChanged);
    on<SearchSortChanged>(_onSortChanged);
    on<SearchToggleOrder>(_onToggleOrder);
    on<SearchLoadMoreRequested>(_onLoadMore, transformer: droppable());
  }

  Future<void> _onStarted(
    SearchStarted event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: SearchStatus.loading, error: null));
    try {
      final cats = await _repo.categories();
      emit(state.copyWith(categories: cats));
      await _fetch(reset: true, emit: emit);
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(query: event.query));
    await _fetch(reset: true, emit: emit);
  }

  Future<void> _onCategoryChanged(
    SearchCategoryChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(selectedCategory: event.category));
    await _fetch(reset: true, emit: emit);
  }

  Future<void> _onSortChanged(
    SearchSortChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(sort: event.sort));
    await _fetch(reset: true, emit: emit);
  }

  Future<void> _onToggleOrder(
    SearchToggleOrder event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(desc: !state.desc));
    await _fetch(reset: true, emit: emit);
  }

  Future<void> _onLoadMore(
    SearchLoadMoreRequested event,
    Emitter<SearchState> emit,
  ) async {
    if (!state.canLoadMore) return;
    await _fetch(reset: false, emit: emit);
  }

  Future<void> _fetch({
    required bool reset,
    required Emitter<SearchState> emit,
  }) async {
    if (state.status == SearchStatus.loadingMore && !reset) return;

    emit(
      state.copyWith(
        status: reset ? SearchStatus.loading : SearchStatus.loadingMore,
        error: null,
        items: reset ? const [] : state.items,
        skip: reset ? 0 : state.skip,
        total: reset ? 0 : state.total,
      ),
    );

    try {
      final page = await _repo.search(
        query: state.query,
        category: state.selectedCategory,
        sort: state.sort,
        desc: state.desc,
        skip: reset ? 0 : state.skip,
        take: SearchState.pageSize,
      );

      final merged = reset ? page.items : [...state.items, ...page.items];

      emit(
        state.copyWith(
          status: SearchStatus.success,
          items: merged,
          total: page.total,
          skip: page.skip + page.take,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SearchStatus.failure, error: e.toString()));
    }
  }
}
