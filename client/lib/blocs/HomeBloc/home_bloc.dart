import 'package:bloc/bloc.dart';
import 'package:counter_x/models/NotesModel/notes_model.dart';
import 'package:counter_x/services/FirestoreServices/firestore_service.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final FirestoreService _firestoreService = FirestoreService(); // Instance of FirestoreService
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instance of FirebaseAuth
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? ""; // Get the current user's ID

  HomeBloc() : super(HomeInitial()) {
    on<FetchNotesEvent>(_onFetchNotes);
    // on<SearchNotesEvent>(_onSearchNotes);
    // on<SortNotesEvent>(_onSortNotes);
    // on<DeleteNoteEvent>(_onDeleteNote);
  }

  Future<void> _onFetchNotes(FetchNotesEvent event, Emitter<HomeState> emit) async {
    if(userId.isEmpty) {
      emit(NotesError("User not authenticated"));
      return;
    }
    emit(NotesLoading());
    try {
      await emit.forEach<List<NoteModel>>(
        _firestoreService.getNotesStream(uid: userId),
        onData: (notes) => NotesLoaded(notes),
        onError: (error, _) => NotesError(error.toString()),
      );
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _onSearchNotes(SearchNotesEvent event, Emitter<HomeState> emit) async {
    // Implement search logic here
  }


}
