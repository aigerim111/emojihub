part of 'suggestion_bloc.dart';

sealed class SuggestEvent {
  const SuggestEvent();
  @override
  List<Object?> get props => [];
}

final class SuggestRequested extends SuggestEvent {
  final String? topic;
  const SuggestRequested(this.topic);

  @override
  List<Object?> get props => [topic];
}
