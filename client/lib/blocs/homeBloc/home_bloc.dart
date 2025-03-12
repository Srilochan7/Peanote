import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<PickFileEvent>((event, emit) {
      emit(FilePickedState(event.filePath));
    });
    on<GenerateReportEvent>((event, emit) async {
      emit(ReportGeneratingState());
      await Future.delayed(const Duration(seconds: 2));
      emit(ReportGeneratedState());
    });
  }
}
