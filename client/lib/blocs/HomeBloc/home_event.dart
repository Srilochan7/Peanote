part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];

  
}

final class FetchNotesEvent extends HomeEvent {
  const FetchNotesEvent();

  @override
  List<Object> get props => [];
}


final class SearchNotesEvent extends HomeEvent {
  final String query;

  const SearchNotesEvent(this.query);

  @override
  List<Object> get props => [query];
}

final class SortNotesEvent extends HomeEvent {
  final String sortBy;

  const SortNotesEvent(this.sortBy);

  @override
  List<Object> get props => [sortBy];
}


final class DeleteNoteEvent extends HomeEvent {
  final String noteId;

  const DeleteNoteEvent(this.noteId);

  @override
  List<Object> get props => [noteId];
}


