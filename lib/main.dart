import 'package:flutter/src/foundation/constants.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:organizer/bloc/crud_bloc.dart';
import 'package:organizer/pages/territories/territory_details.dart';
import 'package:organizer/pages/territories/territories.dart';
import 'package:organizer/store/inmem/territory.dart';
import 'pages/doors/door_details.dart';
import 'package:pwa/client.dart' as pwa;
import 'repository/territory.dart';

void main() {
  if (foundation.kIsWeb) {
    pwa.Client();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final territoryRepo = TerritoryRepositoryInmem();

    return MaterialApp(
      title: 'Organiser',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          primaryColor: Colors.purple[900]),
      initialRoute: "/territories",
      routes: {
        "/territories": (context) {
          final territoryBloc = CrudListBloc<Territory>(
              createFn: territoryRepo.store,
              loadFn: territoryRepo.loadAll,
              removeFn: territoryRepo.remove);

          return TerritoriesPage(
            territoryBloc: territoryBloc,
          );
        },
        "/territory": (context) {
          final String territoryId = (ModalRoute.of(context).settings.arguments
              as Map<String, String>)["territoryId"];

          final territoryBloc = CrudBloc<Territory>(
              createFn: territoryRepo.store,
              loadFn: () => territoryRepo.loadById(territoryId),
              updateFn: territoryRepo.store,
              removeFn: territoryRepo.remove);

          return TerritoryPage(
            bloc: territoryBloc,
          );
        },
        "/territory/door": (context) {
          final Map<String, String> props =
              ModalRoute.of(context).settings.arguments;
          final territory = territoryRepo.loadById(props["territoryId"]);
          final getDoor = () => territory.doors.firstWhere((d) => d.id == props["doorId"]);
          final doorBloc = CrudBloc<Door>(
              loadFn: getDoor,
              removeFn: (id) {
                territory.doors.remove(getDoor());
              },
              updateFn: (d) {
                final doorIndex = territory.doors.indexOf(getDoor());
                territory.doors.insert(doorIndex, territory.doors.removeAt(doorIndex));
                territoryRepo.store(territory);
              },
              createFn: (d) {
                territory.doors.add(d);
                territoryRepo.store(territory);
              });
          return DoorPage(
            door: getDoor(),
            bloc: doorBloc,
          );
        }
      },
    );
  }
}
