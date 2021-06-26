import 'package:flutter/material.dart';
import 'package:flutter_agenda_contatos/helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;

  ContactPage({this.contact}); //entre chaves deixa o parâmetro opcional

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  Contact _editedContact;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.contact == null) { //para acessar a variável de outra classe usamos o widget, pois representa a ContactPage
      _editedContact = Contact(); //se não receber um contato, vamos criar um
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editedContact.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
    );
  }
}
