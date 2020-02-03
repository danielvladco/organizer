import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:organizer/bloc/crud_bloc.dart';
import 'package:organizer/repository/territory.dart';
import 'package:reorderables/reorderables.dart';
import 'package:usage/uuid/uuid.dart';

class TerritoryPage extends StatelessWidget {
  final CrudBloc<Territory> bloc;

  TerritoryPage({Key key, @required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Territory details")),
      body: StreamBuilder<Territory>(
          stream: bloc.stream,
          initialData: bloc.initialState,
          builder: (ctx, snap) {
            if (!snap.hasData) {
              return Center(child: Text("No content :("));
            }

            final territory = snap.data;

            Widget createButton = IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  var n = await showDialog<int>(
                      context: context,
                      builder: (ctx) => NumberPickerDialog.integer(
                            minValue: 1,
                            maxValue: 200,
                            initialIntegerValue: 20,
                          ));
                  if (n == null) {
                    return;
                  }

                  if (territory.doors != null && territory.doors.length > 0) {
                    territory.doors.addAll(List.generate(
                        n,
                        (i) =>
                            Door(id: Uuid().generateV4(), name: '${i + 1}')));
                    bloc.events.add(Updated(state: territory));
                    return;
                  }

                  territory.doors = List.generate(n,
                      (i) => Door(id: Uuid().generateV4(), name: '${i + 1}'));
                  bloc.events.add(Updated(state: territory));
                });

            List<Widget> items = territory.doors == null
                ? []
                : territory.doors
                    .map<Widget>((Door d) => SizedBox(
              key: Key(d.id),
                        width: 50,
                        height: 50,
                        child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, "/territory/door",
                                  arguments: {
                                    "territoryId": territory.id,
                                    "doorId": d.id
                                  });
                            },
                            child: Card(
                                color: doorStatusColors[d.status],
                                child: Center(child: Text(d.name))))))
                    .toList()..add(createButton);
//                : territory.doors
//                    .map<Widget>((Door d) => Padding(
//                          padding: const EdgeInsets.all(2.0),
//                          child: InkWell(
//                              onTap: () {
//                                Navigator.pushNamed(context, "/territory/door",
//                                    arguments: {
//                                      "territoryId": territory.id,
//                                      "doorId": d.id
//                                    });
//                              },
//                              child: Hero(
//                                  tag: d.id,
//                                  child: Card(
//                                      color: doorStatusColors[d.status],
//                                      child: Center(child: Text(d.name))))),
//                        ))
//                    .toList()
//              ..add(createButton);
//            items.map(()i => ReorderableTableRow())
//            return Text("S");
//            Icons.filter_1
//            Icons.filter_2
            return Center(
                heightFactor: 1,
                child: ReorderableWrap(
                    children: items,
//                alignment: WrapAlignment.center,
//                crossAxisAlignment: WrapCrossAlignment.center,
                    onReorder: (oldIndex, newIndex) {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }

                      final door = territory.doors.removeAt(oldIndex);
                      territory.doors.insert(newIndex, door);
                    }));
//            GridView.count(
//                crossAxisCount: 7,
//                children: items);
          }),
    );
  }
}
