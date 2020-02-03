import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organizer/bloc/crud_bloc.dart';
import 'package:organizer/fragments/floating_action_list.dart';
import 'package:organizer/repository/territory.dart';
import 'package:usage/uuid/uuid.dart';

class TerritoriesPage extends StatelessWidget {
  TerritoriesPage({Key key, this.territoryBloc}) : super(key: key);

  final CrudListBloc<Territory> territoryBloc;

  @override
  Widget build(BuildContext context) {
    final floatingButtonRef = GlobalKey<FloatingActionListState>();
    final scaffold = GlobalKey<ScaffoldState>();

    final addTerritory = () {
      floatingButtonRef.currentState.toggle();
      final form = GlobalKey<FormState>();

      showDialog(
          context: context,
          builder: (context) {
            return addTerritoryDialog(
                context: context,
                form: form,
                addItem: (val) => territoryBloc.events.add(Created(state: Territory(id: Uuid().toString(), name: val)))
            );
          });
    };

    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        title: Text("Organiser"),
        actions: [
          IconButton(
              icon: Icon(Icons.cloud, color: Theme
                  .of(context)
                  .cardColor),
              onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: Scaffold(
          appBar: AppBar(
            title: Text("menu"),
          ),
          body: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text('Rapports'),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Studies'),
              ),
              ListTile(
                leading: Icon(Icons.perm_identity),
                title: Text('Visits'),
              ),
              ListTile(
                leading: Icon(Icons.business),
                title: Text('Territories'),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<List<Territory>>(
        stream: territoryBloc.stream,
        initialData: territoryBloc.initialState,
        builder: (ctx, snp) {
          if (!snp.hasData) {
            return Text("Loading...");
          }
          final territories = snp.data;
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                // removing the item at oldIndex will shorten the list by 1.
                newIndex -= 1;
              }

              final Territory element = territories.removeAt(oldIndex);
              territories.insert(newIndex, element);
            },

            children: territories.map((Territory t) =>
                ListTile(
                    key: Key(t.id),
                    onTap: () {
                      Navigator.of(context).pushNamed("/territory", arguments: {"territoryId": t.id});
                    },
                    title: Text(t.name),
                    leading: t.active
                        ? Icon(Icons.check_circle_outline)
                        : Icon(Icons.radio_button_unchecked),
                    trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: Text(
                                        "Are you sure you want to delete this item?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: new Text("Cancel"),
                                        onPressed: Navigator
                                            .of(context)
                                            .pop,
                                      ),
                                      FlatButton(
                                        color: Colors.red[900],
                                        child: Text("Delete",
                                            style: TextStyle(
                                                color: Colors.white)),
                                        onPressed: () {
                                          territoryBloc.events.add(Deleted(id: t.id));
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ]);
                              });
                        })))
                .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionList(
        key: floatingButtonRef,
        icon: Icons.add,
        actions: [
          FloatingActionButton.extended(
              onPressed: () {
                //TODO
//                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ))
              },
              heroTag: null,
              elevation: 4.0,
              backgroundColor: Theme
                  .of(context)
                  .cardColor,
              icon:
              Icon(Icons.assignment, color: Theme
                  .of(context)
                  .accentColor),
              label: Text("Rapport",
                  style: TextStyle(color: Theme
                      .of(context)
                      .accentColor))),
          FloatingActionButton.extended(
              onPressed: () {},
              heroTag: null,
              elevation: 4.0,
              backgroundColor: Theme
                  .of(context)
                  .cardColor,
              icon: Icon(Icons.person, color: Theme
                  .of(context)
                  .accentColor),
              label: Text("Study",
                  style: TextStyle(color: Theme
                      .of(context)
                      .accentColor))),
          FloatingActionButton.extended(
              onPressed: () {},
              heroTag: null,
              elevation: 4.0,
              backgroundColor: Theme
                  .of(context)
                  .cardColor,
              icon: Icon(Icons.accessibility,
                  color: Theme
                      .of(context)
                      .accentColor),
              label: Text("Visit",
                  style: TextStyle(color: Theme
                      .of(context)
                      .accentColor))),
          FloatingActionButton.extended(
              elevation: 4.0,
              onPressed: addTerritory,
              heroTag: null,
              backgroundColor: Theme
                  .of(context)
                  .cardColor,
              icon: Icon(Icons.business, color: Theme
                  .of(context)
                  .accentColor),
              label: Text("Territory",
                  style: TextStyle(color: Theme
                      .of(context)
                      .accentColor))),
        ],
      ),
    );
  }


}

addTerritoryDialog({
  BuildContext context,
  GlobalKey<FormState> form,
  void Function(String) addItem
}) =>
    Form(
      key: form,
      child: AlertDialog(
        title: Text("My Super title"),
        content: TextFormField(
            onSaved: (val) {
              if (form.currentState.validate()) {
                addItem(val);
                Navigator.of(context).pop();
              }
            },
            autofocus: true,
            validator: (val) {
              if (val.isEmpty) {
                return "Please enter the territory name";
              }

              return null;
            }),
        actions: [
          FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: new Text("Save"),
            onPressed: () {
              form.currentState.save();
            },
          ),
        ],
      ),
    );
