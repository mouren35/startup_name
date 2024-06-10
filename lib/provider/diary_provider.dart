import 'package:flutter/material.dart';
import 'package:startup_namer/db/diary_db.dart';
import 'package:startup_namer/model/diary_model.dart';

class DiaryProvider with ChangeNotifier {
  List<DiaryEntry> _entries = [];

  List<DiaryEntry> get entries => _entries;

  Future<void> fetchEntries() async {
    _entries = await DatabaseHelper().getDiaryEntries();
    notifyListeners();
  }

  Future<void> addEntry(DiaryEntry entry) async {
    await DatabaseHelper().insertDiaryEntry(entry);
    fetchEntries();
  }

  Future<void> updateEntry(DiaryEntry entry) async {
    await DatabaseHelper().updateDiaryEntry(entry);
    fetchEntries();
  }

  Future<void> deleteEntry(int id) async {
    await DatabaseHelper().deleteDiaryEntry(id);
    fetchEntries();
  }
}
