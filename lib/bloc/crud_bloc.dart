
import 'dart:async';

class CrudListBloc<StateType> {
  final StreamController<List<StateType>> _stateChannel = StreamController.broadcast();
  final StreamController<CrudEvent> _eventChannel = StreamController();

  final void Function(StateType state) updateFn;
  final void Function(StateType state) createFn;
  final List<StateType> Function() loadFn;
  final Function(String) removeFn;

  CrudListBloc({this.loadFn, this.updateFn, this.createFn, this.removeFn}) {
    _eventChannel.stream.listen(_eventHandler);
  }

  get initialState => loadFn();

  get events => _eventChannel.sink;

  get stream => _stateChannel.stream.asBroadcastStream();

  _eventHandler(CrudEvent e) {
    if (e is Created) {
      createFn(e.state);
    }

    if (e is Updated) {
      updateFn(e.state);
    }

    if (e is Deleted) {
      removeFn(e.id);
    }

    final newState = loadFn();

    _stateChannel.sink.add(newState);
  }

  void dispose() {
    _eventChannel.close();
    _stateChannel.close();
  }
}

class CrudBloc<StateType> {
  final StreamController<StateType> _stateChannel = StreamController();
  final StreamController<CrudEvent> _eventChannel = StreamController();

  final void Function(StateType state) updateFn;
  final void Function(StateType state) createFn;
  final StateType Function() loadFn;
  final Function(String) removeFn;

  CrudBloc({this.loadFn, this.updateFn, this.createFn, this.removeFn}) {
    _eventChannel.stream.listen(_eventHandler);
  }

  get initialState => loadFn();

  get events => _eventChannel.sink;

  get stream => _stateChannel.stream;

  _eventHandler(CrudEvent e) {
    if (e is Created) {
      createFn(e.state);
    }

    if (e is Updated) {
      updateFn(e.state);
    }

    if (e is Deleted) {
      removeFn(e.id);
    }

    final newState = loadFn();

    _stateChannel.sink.add(newState);
  }

  void dispose() {
    _eventChannel.close();
    _stateChannel.close();
  }
}

abstract class CrudEvent {}

class Updated<StateType> extends CrudEvent {
  Updated({this.state});

  StateType state;
}

class Created<StateType> extends CrudEvent {
  Created({this.state});

  StateType state;
}

class Deleted<StateType> extends CrudEvent {
  Deleted({this.id});

  String id;
}
