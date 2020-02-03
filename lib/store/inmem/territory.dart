import 'package:organizer/repository/territory.dart';

class TerritoryRepositoryInmem implements TerritoryRepository {
  var _state = {
    "1": Territory(id: "1", name: "Territory nr1", active: true),
    "2": Territory(id: "2", name: "Territory nr2", active: false),
    "3": Territory(id: "3", name: "Territory nr3", active: true, doors: [
      Door(id: "1", name: "1", status: DoorStatus.none),
      Door(id: "2", name: "2", status: DoorStatus.not_at_home),
      Door(id: "3", name: "3", status: DoorStatus.none),
      Door(id: "4", name: "4", status: DoorStatus.none),
      Door(id: "5", name: "5", status: DoorStatus.none),
      Door(id: "6", name: "6", status: DoorStatus.not_interested),
      Door(id: "7", name: "7", status: DoorStatus.not_at_home),
      Door(id: "8", name: "8", status: DoorStatus.other_language),
      Door(id: "9", name: "9", status: DoorStatus.showed_interest),
      Door(id: "10", name: "10", status: DoorStatus.study),
      Door(id: "11", name: "11", status: DoorStatus.visit),
      Door(id: "12", name: "12", status: DoorStatus.showed_interest),
      Door(id: "13", name: "13", status: DoorStatus.showed_interest),
      Door(id: "14", name: "14", status: DoorStatus.not_interested),
    ]),
  };

  @override
  List<Territory> loadAll() {
    return _state.values.toList();
  }

  @override
  remove(String id) {
    _state.remove(id);
  }

  @override
  store(Territory t) {
    _state[t.id] = t;
  }

  @override
  Territory loadById(String id) {
    return _state[id];
  }
}
