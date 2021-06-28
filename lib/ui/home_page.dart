import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter_agenda_contatos/ui/contact_page.dart';

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
    _getAllContacts();
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
        onPressed: () {
          _showContactPage();
        },
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
                      AssetImage("images/avatar.jpg"),
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
      onTap: (){
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){},
            builder: (context){
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, //ocupa o mínimo de espaço possível no eixo principal
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Ligar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          Navigator.pop(context); //fecha o BottomSheet
                          _showContactPage(contact: contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text("Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: (){
                          helper.deleteContact(contacts[index].id); //remove do banco
                          setState(() {
                            contacts.removeAt(index); //remove da lista da tela
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
    );
  }

  void _showContactPage({Contact contact}) async { //quando for criar não vai passar um contato, quando for editar passa o contato
    final recContact = await Navigator.push(context, //recebe um contato da ContactPage, após salvar ou editar
        MaterialPageRoute(builder: (context)=>ContactPage(contact: contact,)));
    if(recContact != null) { //se houve criação ou edicão
      if(contact != null){ //se o contact != null, quer dizer que enviamos um contato, então é edição
        await helper.updateContact(recContact);
      } else { //recebemos o contato mas não enviamos, então é criação
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((value) => {
      setState((){
        contacts = value;
      })
    });
  }
}
