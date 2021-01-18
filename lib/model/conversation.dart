import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Conversation extends Equatable {
  final String hash;
  final String name;
  final String topic;
  final String displayPicture;

  @override
  List<Object> get props => [hash, name, topic, displayPicture];

  Conversation({
    @required this.hash,
    @required this.name,
    this.topic = "",
    this.displayPicture,
  });

  // TodoEntity toEntity() {
  //   return TodoEntity(task, id, note, complete);
  // }

  // static Todo fromEntity(TodoEntity entity) {
  //   return Todo(
  //     entity.task,
  //     complete: entity.complete ?? false,
  //     note: entity.note,
  //     id: entity.id ?? Uuid().generateV4(),
  //   );
  // }
}