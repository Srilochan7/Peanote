part of 'home_bloc.dart';

@immutable
sealed class HomeEvent extends Equatable {
  List<Object> get props => [];
}


class PickFileEvent extends HomeEvent{
  final String filePath;

  PickFileEvent(this.filePath);
  List<Object> get props => [filePath];
}

class GenerateReportEvent extends HomeEvent{

}