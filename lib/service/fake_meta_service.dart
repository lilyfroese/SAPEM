import 'package:tcc/models/meta.dart';
import 'package:flutter/material.dart';

class FakeMetaService {
  FakeMetaService._();
  static final FakeMetaService instance = FakeMetaService._();

  final List<Meta> metas = [];

  int _idCounter = 1;


  void addMeta({
    required String title,
    required String description,
    String? category,
    int? goalValue,
    DateTime? deadline,
    required Color color,
    required IconData icon,
    bool notify = false,
  }) {
    metas.add(
      Meta(
        id: _idCounter++,
        title: title,
        description: description,
        category: category,
        goalValue: goalValue,
        deadline: deadline,
        color: color,
        icon: icon,
      ),
    );
  }


  void updateMeta(Meta old, Meta newData) {
    final index = metas.indexWhere((m) => m.id == old.id);
    if (index != -1) {
      metas[index] = newData.copyWith();
    }
  }


  void deleteMeta(Meta meta) {
    metas.removeWhere((m) => m.id == meta.id);
  }


  void toggleFeita(Meta meta) {
    final index = metas.indexWhere((m) => m.id == meta.id);
    if (index == -1) return;

    metas[index] = metas[index].copyWith(
      feita: !metas[index].feita,
    );
  }
}
