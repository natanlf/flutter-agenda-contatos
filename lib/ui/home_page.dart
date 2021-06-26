import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_agenda_contatos/helpers/contact_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    helper.getAllContacts().then((value) => {
      setState((){
        contacts = value;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context,index){
            return _contactCard(context, index);
      }),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector( //usamos porque o card não permite evento de clique
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null ?
                      FileImage(File(contacts[index].img)) :
                      AssetImage("images/person.png"),
                    fit: BoxFit.cover
                  )
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(contacts[index].name ?? "",
                      style: TextStyle(fontSize: 22.0,
                          fontWeight: FontWeight.bold)),
                      Text(contacts[index].email ?? "",
                        style: TextStyle(fontSize: 18.0)),
                      Text(contacts[index].phone ?? "",
                        style: TextStyle(fontSize: 18.0))
                    ],
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
