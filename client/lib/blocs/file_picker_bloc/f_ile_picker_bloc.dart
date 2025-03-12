import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'f_ile_picker_event.dart';
part 'f_ile_picker_state.dart';

class FIlePickerBloc extends Bloc<FIlePickerEvent, FIlePickerState> {
  FIlePickerBloc() : super(FIlePickerInitial()) {
    on<FIlePickerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
