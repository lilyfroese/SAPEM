import 'package:flutter/material.dart';

class Meta {
  int id;
  String title;
  String description;
  String? category;
  int? goalValue;
  DateTime? deadline;
  Color color;
  IconData icon;
  bool feita; // <- NECESSÁRIO

  Meta({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    this.goalValue,
    this.deadline,
    required this.color,
    required this.icon,
    this.feita = false, // padrão: não feita
  });

  Meta copyWith({
    String? title,
    String? description,
    String? category,
    int? goalValue,
    DateTime? deadline,
    Color? color,
    IconData? icon,
    bool? feita,
  }) {
    return Meta(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      goalValue: goalValue ?? this.goalValue,
      deadline: deadline ?? this.deadline,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      feita: feita ?? this.feita,
    );
  }
}
