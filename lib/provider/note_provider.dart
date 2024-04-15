import 'package:flutter/cupertino.dart';

import '../model/note_model.dart';

class NoteProvider with ChangeNotifier {
  List<NoteModel> _notes = [];

  List<NoteModel> get notes {
    return [..._notes];
  }

  void add(NoteModel note) {
    _notes.add(note);
    notifyListeners();
  }

  void remove(NoteModel note) {
    _notes.remove(note);
    notifyListeners();
  }

  void update(NoteModel note) {
    final index = _notes.indexWhere((element) => element.id == note.id);
    if (index >= 0) {
      _notes[index] = note;
      notifyListeners();
    }
  }
}
