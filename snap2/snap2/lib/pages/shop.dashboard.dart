import 'dart:convert';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Dashboard extends StatefulWidget {
  final token;
  //final email;
  const Dashboard({@required this.token, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String userId;
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
  TextEditingController _todoItemType = TextEditingController();
  TextEditingController _todoPrice = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _itemType = TextEditingController();
  TextEditingController _price = TextEditingController();

  List? items;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    userId = jwtDecodedToken['_id'];
    getTodoList(userId);
  }

  void addTodo() async {
    dev.log("shop dashboard ");
    dev.log("\n add item deatels > \n" +
        _name.text +
        "\n" +
        _description.text +
        "\n" +
        _itemType.text +
        "\n" +
        _price.text +
        "\n");
    if (_name.text.isNotEmpty &&
        _description.text.isNotEmpty &&
        _itemType.text.isNotEmpty &&
        _price.text.isNotEmpty) {
      var regBody = {
        "name": _name.text,
        "description": _description.text,
        "itemType": _itemType.text,
        "price": _price.text,
        "shopId": "6598c19168c78132eaaaa675",
        "shopName": "shop1"
        //"userId": userId,
        //"title": _todoTitle.text,
        //"desc": _todoDesc.text
      };
      dev.log("this is reg body" + regBody.toString());

      dev.log(Uri.parse(addtodo).toString() + "this is url");

      var response = await http.post(Uri.parse(addItem),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));
      dev.log("this is body" + jsonEncode(regBody).toString());

      dev.log("this is response" + response.body.toString());

      var jsonResponse = jsonDecode(response.body);
      dev.log("json response");
      dev.log(jsonResponse.toString());

      print(jsonResponse['status']);

      if (jsonResponse['status']) {
        _todoDesc.clear();
        _todoTitle.clear();
        Navigator.pop(context);
        getTodoList(userId);
      } else {
        print("SomeThing Went Wrong");
      }
    }
  }

  void getTodoList(userId) async {
    var url = Uri.parse(getItems);
    // show url

    url = url.replace(queryParameters: {
      "id": "6598c19168c78132eaaaa675"
    }); // Add userId as a query parameter
    dev.log(url.toString());
    var response = await http.get(url);
    // show response
    dev.log(response.body.toString());

    var regBody = {"userId": userId};
    dev.log("this is get todo list");

    dev.log(regBody.toString());

    // var response = await http.get(Uri.parse(getToDoList)).then((value) => {
    //       dev.log("this is value" + value.body.toString()),
    //     });

    //dev.log("this is response" + response.body.toString());

    //var responseBody = response.body;
    //
    //dev.log(response.headers.toString());
    //dev.log(responseBody.toString());
    dev.log("responseBody.toString()");
    var jsonResponse = jsonDecode(response.body);
    //var jsonResponse = jsonDecode(response.body);
    items = jsonResponse['success'];

    setState(() {});
  }

  void deleteItem(id) async {
    var regBody = {"id": id};

    var response = await http.post(Uri.parse(deleteTodo),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['status']) {
      getTodoList(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CircleAvatar(
                //   child: Icon(
                //     Icons.list,
                //     size: 30.0,
                //   ),
                //   backgroundColor: Colors.white,
                //   radius: 30.0,
                // ),
                //SizedBox(height: 10.0),
                // Text(
                //   'ToDo with NodeJS + Mongodb',
                //   style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
                // ),
                // SizedBox(height: 8.0),
                // Text(
                //   '5 Task',
                //   style: TextStyle(fontSize: 20),
                // ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: items == null
                    ? null
                    : ListView.builder(
                        itemCount: items!.length,
                        itemBuilder: (context, int index) {
                          return Slidable(
                            key: const ValueKey(0),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(onDismissed: () {}),
                              children: [
                                SlidableAction(
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                  onPressed: (BuildContext context) {
                                    print('${items![index]['_id']}');
                                    deleteItem('${items![index]['_id']}');
                                  },
                                ),
                              ],
                            ),
                            child: Card(
                              borderOnForeground: false,
                              child: Text(
                                '${items![index]['name']} \n ${items![index]['description']} \n ${items![index]['itemType']} \n ${items![index]['price']}',
                                style: TextStyle(fontSize: 20),
                              ),
                              /*ListTile(
                                leading: Icon(Icons.task),
                                title: Text('${items![index]['name']}'),
                                subtitle: Text('${items![index]['description']}'),
                                
                                trailing: Icon(Icons.arrow_back),
                              )*/
                              // show all deatels received from server

                              
                            ),
                          );
                        }),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayTextInputDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Add-ToDo',
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Add To-Do'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // text fields for name , description , item type , price

                  TextField(
                    controller: _name,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Name",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  TextField(
                    controller: _description,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Description",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  TextField(
                    controller: _itemType,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Item Type",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  TextField(
                    controller: _price,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Price",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  ElevatedButton(
                      onPressed: () {
                        addTodo();
                        dev.log("add item pressed");
                      },
                      child: Text("Add"))
                ],
              ));
        });
  }
}
