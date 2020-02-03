import 'dart:async';

import 'package:organizer/repository/territory.dart';

class DoorDetailsBloc {
  Door _door;
  Territory _territory;
  TerritoryRepository _repo;

  final StreamController<Door> _stateChannel = StreamController();
  final StreamController<DoorDetailsEvent> _eventChannel = StreamController();

  final void Function(Door state) storeFn;
  final Door Function() loadFn;
  final Function(String) removeFn;

  DoorDetailsBloc({this.loadFn, this.storeFn, this.removeFn}) {
    _eventChannel.stream.listen(_eventHandler);
  }


  get initialState => loadFn();

  get events => _eventChannel.sink;

  get stream => _stateChannel.stream;

  _eventHandler(DoorDetailsEvent e) {
    if (e is DoorAdded) {
      storeFn(e.door);
    }

    if (e is DoorUpdated) {
      storeFn(e.door);
    }

    if (e is DoorRemoved) {
      removeFn(e.id);
    }

    _repo.store(_territory);

    _stateChannel.sink.add(_door);
  }

  void dispose() {
    _eventChannel.close();
    _stateChannel.close();
  }
}

abstract class DoorDetailsEvent {}

class DoorUpdated extends DoorDetailsEvent {
  DoorUpdated({this.door, this.territoryId});

  String territoryId;
  Door door;
}

class DoorAdded extends DoorDetailsEvent {
  DoorAdded({this.territoryId, this.door});

  String territoryId;
  Door door;
}

class DoorRemoved extends DoorDetailsEvent {
  DoorRemoved({this.id, this.territoryId});

  String id;
  String territoryId;
}
