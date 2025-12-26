part of 'suggestion_bloc.dart';

enum SuggestStatus { idle, loading, success, failure }

class SuggestState {
  final SuggestStatus status;
  final Suggestion? data;
  final String? error;

  const SuggestState({this.status = SuggestStatus.idle, this.data, this.error});

  SuggestState copyWith({
    SuggestStatus? status,
    Suggestion? data,
    String? error,
  }) {
    return SuggestState(
      status: status ?? this.status,
      data: data ?? this.data,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, data, error];
}
