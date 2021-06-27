import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_agenda_contatos/helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact}); //entre chaves deixa o parâmetro opcional

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;
  Contact _editedContact;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.contact == null) {
      //para acessar a variável de outra classe usamos o widget, pois representa a ContactPage
      _editedContact = Contact(); //se não receber um contato, vamos criar um
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //WillPopScope => chama uma função antes de tentar sair da tela
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editedContact.name ?? "Novo Contato"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
            //passa para a tela anterior o contato editado
            Navigator.pop(context,
                _editedContact); //pop => volta para a tela anterior. Navigator = esquema de pilha
          } else {
            FocusScope.of(context).requestFocus(_nameFocus);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedContact.img != null
                            ? FileImage(File(_editedContact.img))
                            : AssetImage("images/avatar.jpg"),
                        fit: BoxFit.cover)),
              ),
            ),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editedContact.name = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
              onChanged: (text) {
                _userEdited = true;
                _editedContact.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Phone"),
              onChanged: (text) {
                _userEdited = true;
                _editedContact.phone = text;
              },
              keyboardType: TextInputType.phone,
            )
          ],
        ),
      ),
    ),
    onWillPop: _requestPop);
  }

  Future<bool> _requestPop(){
    if(_userEdited) { //se editou algo perguntar se quer descartar
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text("Descartar Alterações?"),
          content: Text("Se sair as alterações serão perdidas"),
          actions: [
            FlatButton(onPressed: (){ //tira o dialog
              Navigator.pop(context);
            }, child: Text("Cancelar")),
            FlatButton(onPressed: (){
              Navigator.pop(context); //tira o dialog
              Navigator.pop(context); //tira contact_page
            }, child: Text("Sim"))
          ],
        );
      });
      return Future.value(false); //não permite sair automaticamente da tela, caso modificou algo
    } else {
      return Future.value(true); //permite sair automaticamente da tela
    }
  }
}
