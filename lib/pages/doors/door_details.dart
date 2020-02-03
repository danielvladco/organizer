import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:organizer/bloc/crud_bloc.dart';
import 'package:organizer/bloc/door_details.dart';
import 'package:organizer/bloc/territories.dart';
import 'package:organizer/repository/territory.dart';

class DoorPage extends HookWidget {
  const DoorPage({
    Key key,
    @required this.door,
    @required this.bloc,
  }) : super(key: key);

  final Door door;
  final CrudBloc<Door> bloc;

  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    final scaffold = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: AppBar(title: Text("Door details"), actions: <Widget>[
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              bloc.events.add(Deleted(id: door.id));
              Navigator.of(context).pop();
            })
      ]),
      body: StreamBuilder(
        stream: bloc.stream,
        initialData: bloc.initialState,
        builder: (ctx, snap) {
          if (!snap.hasData) {
            return Center(child: Text("No data :("));
          }

          final door = snap.data;

          return Container(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(
                        right: 30, left: 30, top: 20, bottom: 20),
                    child: Center(
                        child: Form(
                      key: _form,
                      child: TextFormField(
                          initialValue: door.name,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Plese write a valid name";
                            }
                            if (value.length > 6) {
                              return "The name is too long";
                            }

                            return null;
                          },
                          onFieldSubmitted: (String value) {
                            if (_form.currentState.validate()) {
                              door.name = value;
                              bloc.events.add(Updated(state: door));

                              scaffold.currentState.showSnackBar(SnackBar(
                                content: Text('Name changed'),
                              ));
                            }
                          }),
                    ))),
                Expanded(
                    child: ListView(
                  children: DoorStatus.values.map<Widget>((DoorStatus s) {
                    return ListTile(
                        leading: Radio<DoorStatus>(
                            value: s,
                            activeColor: door.status != DoorStatus.none
                                ? door.status != DoorStatus.not_at_home
                                    ? doorStatusColors[door.status]
                                    : Theme.of(context).primaryColor
                                : Theme.of(context).accentColor,
                            groupValue: door.status,
                            onChanged: (DoorStatus newStatus) {
                              door.status = newStatus;
                              bloc.events.add(Updated(state: door));
                            }),
                        title: Text(doorStatusNames[s]));
                  }).toList(),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}
