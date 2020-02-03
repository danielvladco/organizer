import 'dart:async';

import 'package:organizer/repository/territory.dart';

class TerritoryDetailsBloc {
  Territory _territory;
  TerritoryRepository _repo;

  final StreamController<Territory> _stateChannel = StreamController();
  final StreamController<TerritoryDetailsEvent> _eventChannel = StreamController();

  TerritoryDetailsBloc({TerritoryRepository repo, Territory territory}) {
    _repo = repo;
    _territory = territory;
    _eventChannel.stream.listen(_eventHandler);
  }


  get initialState => _territory;

  get events => _eventChannel;

  get stream => _stateChannel.stream;

  _eventHandler(TerritoryDetailsEvent e) {

  }

  void dispose() {
    _eventChannel.close();
    _stateChannel.close();
  }
}

abstract class TerritoryDetailsEvent {}
