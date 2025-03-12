part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable{
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}


class FilePickedState extends HomeState{
  final String filePath;

  FilePickedState(this.filePath);
}


class ReportGeneratingState extends HomeState{}

class ReportGeneratedState extends HomeState{}