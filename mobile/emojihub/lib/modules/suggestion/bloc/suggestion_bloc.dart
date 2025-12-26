import 'package:bloc/bloc.dart';
import 'package:emojihub/models/suggestion.dart';
import 'package:emojihub/repo/suggestion_repository.dart';
import 'package:equatable/equatable.dart';

part 'suggestion_event.dart';
part 'suggestion_state.dart';

class SuggestBloc extends Bloc<SuggestEvent, SuggestState> {
  final SuggestionRepository _repo;

  SuggestBloc(this._repo) : super(const SuggestState()) {
    on<SuggestRequested>(_onRequested);
  }

  Future<void> _onRequested(
    SuggestRequested event,
    Emitter<SuggestState> emit,
  ) async {
    emit(state.copyWith(status: SuggestStatus.loading, error: null));

    try {
      final dto = await _repo.getSuggestions(topic: event.topic);
      emit(state.copyWith(status: SuggestStatus.success, data: dto));
    } catch (e) {
      emit(state.copyWith(status: SuggestStatus.failure, error: e.toString()));
    }
  }
}
