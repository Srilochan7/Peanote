part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class NotesLoading extends HomeState {}

final class NotesLoaded extends HomeState {
  final List<NoteModel> notes;

  const NotesLoaded(this.notes);

  @override
  List<Object> get props => [notes];
}


final class NotesError extends HomeState {
  final String error;

  const NotesError(this.error);

  @override
  List<Object> get props => [error];
}