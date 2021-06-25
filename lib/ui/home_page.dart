import 'package:flutter/material.dart';
import 'package:flutter_agenda_contatos/helpers/contact_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*Contact c = Contact();
    c.name = "Natan";
    c.email = "natan@gmail.com";
    c.phone = "555556658";
    c.img = "imgtest";
    helper.saveContact(c);*/

    helper.getAllContacts().then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
