import 'package:flutter/material.dart';
import '../models/databaseclient.dart';
import '../models/item.dart';
import '../view/customtext.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String nouvelleTache = "";
  List<Item> itemsList = [];
  Map<String, dynamic> map = {};
  var id = 0;
  DatabaseClient databaseClient = DatabaseClient();
  Item item = Item();

  @override
  void initState() {
    super.initState();
    databaseClient.createDB().then((value) => showItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
              onPressed: () => ajouter(
                  function: (item) => databaseClient
                      .insertItem(item)
                      .then((value) => showItems()),
                  title: 'Ajouter une tache',
                  hintText: 'Entrer une tache'),
              child: CustomText(
                "Ajouter",
                color: Colors.white,
              ))
        ],
      ),
      body: (itemsList.isEmpty)
          ? emptyItem()
          : ListView.builder(
              itemCount: itemsList.length,
              itemBuilder: (context, i) {
                return SizedBox(
                  height: 70,
                  child: Card(
                    elevation: 2.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CustomText(
                            itemsList[i].name,
                            fontSize: 18.0,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: Colors.indigo,
                                onPressed: () {
                                  setState(() {
                                    // item = itemsList[i];
                                    // print(item.id);
                                    ajouter(
                                        function: (item) => databaseClient
                                            .updateItem(item)
                                            .then((value) => showItems()),
                                        id: itemsList[i].id,
                                        title: 'Modifier la tache',
                                        hintText:
                                            'modififier la tache actuelle ',
                                        helperText:
                                            'La tache actuelle est: ${itemsList[i].name}');
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    if (itemsList[i].id != null) {
                                      id = itemsList[i].id!;
                                      // print(" the value of id= $id");
                                      databaseClient
                                          .deleteItem(id)
                                          .then((value) => showItems());
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }

  void ajouter(
      {required String title,
      required String hintText,
      required Future<void> Function(Item item) function,
      int? id,
      String helperText = ""}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: CustomText(
              title,
              color: Colors.indigo,
            ),
            content: TextField(
              decoration: InputDecoration(
                  labelText: 'à faire',
                  hintText: hintText,
                  helperText: helperText),
              onChanged: (String string) {
                setState(() {
                  nouvelleTache = string;
                });
                // print(nouvelleTache);
              },
            ),
            actions: [
              TextButton(
                  onPressed: ((() => Navigator.pop(buildContext))),
                  child: CustomText(
                    'Annuler',
                    color: Colors.red,
                  )),
              ElevatedButton(
                  onPressed: () {
                    if (nouvelleTache.isNotEmpty) {
                      setState(() {
                        map['name'] = nouvelleTache;
                        if (id != null) {
                          map['id'] = id;
                        }
                        item.fromMap(map);
                        // print(item);
                        function(item);
                        nouvelleTache = "";
                      });
                      Navigator.pop(buildContext);
                    } else {
                      // print("no Sumited");
                    }
                  },
                  child: CustomText('Valider', color: Colors.white))
            ],
          );
        });
  }

  Widget emptyItem() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/todo.png'),
        CustomText('Aucune tache ajoutée', color: Colors.grey[600], factor: 1.1)
      ],
    ));
  }

  void showItems() {
    databaseClient.getItem().then((value) {
      setState(() {
        itemsList = value;
        // print(itemsList);
      });
    });
  }
}
