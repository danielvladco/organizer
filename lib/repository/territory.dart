import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:organizer/bloc/territories.dart';
import 'package:usage/uuid/uuid.dart';

abstract class TerritoryRepository {
  store(Territory t);

  remove(String id);

  List<Territory> loadAll();

  Territory loadById(String id);
}

class Territory {
  Territory({@required this.id, this.name, this.doors, this.active = false});

  String id;
  String name;
  bool active;
  List<Door> doors;
}

enum DoorStatus {
  none,
  not_at_home,
  not_interested,
  visit,
  study,
  showed_interest,
  other_language
}

const Map<DoorStatus, String> doorStatusNames = {
  DoorStatus.none: "None",
  DoorStatus.not_at_home: "Not at home",
  DoorStatus.not_interested: "Not interested",
  DoorStatus.visit: "Visit",
  DoorStatus.study: "Study",
  DoorStatus.showed_interest: "Showed interest",
  DoorStatus.other_language: "Other language"
};

const Map<DoorStatus, Color> doorStatusColors = {
  DoorStatus.none: Colors.white70,
  DoorStatus.not_at_home: Colors.white12,
  DoorStatus.not_interested: Colors.redAccent,
  DoorStatus.visit: Colors.lightBlueAccent,
  DoorStatus.study: Colors.lightGreenAccent,
  DoorStatus.showed_interest: Colors.purpleAccent,
  DoorStatus.other_language: Colors.orangeAccent
};

class Door {
  Door({
    @required this.id,
    @required this.name,
    this.status = DoorStatus.none,
    this.description = "",
  });

  String id;
  String name;
  DoorStatus status;
  String description;
}
