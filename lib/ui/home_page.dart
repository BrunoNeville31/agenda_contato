import 'dart:io';

import 'package:agenda_contato/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  List<Contact> contact = List();

  @override
  void initState(){
    super.initState();
    _getAllContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contact.length,
          itemBuilder: (context, index){
            return _contactCard(context, index);
          },
          ),
    );
  }
  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: contact[index].img != null ? 
                      FileImage(File(contact[index].img)) :
                        AssetImage("images/person.jpeg")
                    ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(contact[index].name ?? "",
                      style: TextStyle(color: Colors.black, 
                                       fontSize: 22.0, 
                                       fontWeight: FontWeight.bold),
                      ),
                      Text(contact[index].email ?? "",
                      style: TextStyle(color: Colors.black, 
                                       fontSize: 15.0, 
                                       ),
                      ),
                      Text(contact[index].phone ?? "",
                      style: TextStyle(color: Colors.black, 
                                       fontSize: 18.0, 
                                       ),
                      ),
                  ],
                ),
                ),
            ],
          ),
          ),
      ),
      onTap: (){
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext contex, int index){
    showModalBottomSheet(
      context: context, 
      builder: (context){
        return BottomSheet(
          onClosing: (){}, 
          builder: (context){
            return Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: FlatButton(
                      onPressed: null, 
                      child: Text("Ligar",
                      style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                      onLongPress: (){
                        print(contact[index].phone);
                        launch("tel:" + contact[index].phone);
                        Navigator.pop(context);
                      },
                      ),                      
                    ),
                     Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: null, 
                        child: Text("Editar",
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onLongPress: (){
                          Navigator.pop(context);
                          _showContactPage(contact: contact[index]);
                        },
                        ),                      
                      ),  
                     Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          onPressed: null, 
                          child: Text("Apagar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                          onLongPress: (){
                            helper.deleteContact(contact[index].id);
                            setState(() {
                              contact.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                          ),                      
                        ),                  
                ],
              ),
            );
          } 
          );
      }
      );
  }

  void _showContactPage({Contact contact})async {
    final recContact = await Navigator.push(context, 
      MaterialPageRoute(
        builder: (context)=>ContactPage(contact: contact)
       )
    );
    if(recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);        
      }else{
        await helper.saveContact(recContact);
      }
      _getAllContact();
    }
  }

  void _getAllContact() {

    helper.getAllContacts().then((list){
      setState(() {
        contact = list;
      });
    });

  }

}

