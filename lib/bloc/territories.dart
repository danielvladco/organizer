import 'package:organizer/repository/territory.dart';
import 'dart:async';

import 'package:usage/uuid/uuid.dart';

class TerritoriesBloc {

  TerritoryRepository _repo;

  final StreamController<List<Territory>> _stateChannel = StreamController();
  final StreamController<TerritoriesEvent> _eventChannel = StreamController();

  TerritoriesBloc({TerritoryRepository repo}) {
    _repo = repo;
    _eventChannel.stream.listen(_eventHandler);
  }


  get initialState => _repo.loadAll();

  get events => _eventChannel.sink;

  get stream => _stateChannel.stream;

  _eventHandler(TerritoriesEvent e) {
    if (e is TerritoryAdded) {
      _repo.store(new Territory(
        id: Uuid().generateV4(),
        name: e.name,
      ));
    }

    if (e is TerritoryRemoved) {
      _repo.remove(e.id);
    }

    // TODO it is not so performant because it loads all the items for every action but for now it's ok especially if it works with inmem or local storage
    final newState = _repo.loadAll();

    _stateChannel.sink.add(newState);
  }

  void dispose() {
    _eventChannel.close();
    _stateChannel.close();
  }
}

abstract class TerritoriesEvent {}

class TerritoryAdded extends TerritoriesEvent {
  TerritoryAdded({this.name});

  String name;
}

class TerritoryRemoved extends TerritoriesEvent {
  TerritoryRemoved({this.id});

  String id;
}
