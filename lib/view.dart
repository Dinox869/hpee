import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hpee/screenreducer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';


class product extends StatefulWidget{

  final url;
  final name;
  final details;
  final price;
  final ID;


  product({Key key,
    @required
    this.url, this.name, this.details, this.price,this.ID
  }):
        super (key : key);
  @override
  products createState()=> products();
}

class products extends State<product> {
  String checkoutIds = '';
  int _itemCount = 0;
  int total = 0;
// Future<File> imagefile;

  _pickimagefromgallery(ImageSource source) async
  {
    File imagefile = await ImagePicker.pickImage(source: ImageSource.gallery);
    //basename() function will give you the filename
    String fileName = basename(imagefile.path);

    //passing your path with the filename to Firebase Storage Reference
    StorageReference reference = FirebaseStorage.instance.ref().child("$fileName");

    //upload the file to Firebase Storage
    StorageUploadTask uploadTask = reference.putFile(imagefile);

    //Snapshot of the uploading task
    StorageTaskSnapshot taskSnapshot = (await uploadTask.onComplete);

    //...//...
    var URL = (await taskSnapshot.ref.getDownloadURL());
    print("Url is $URL");
    print(widget.ID);
    Upload(URL);

  }
  Upload( String st){
    final Fb = Firestore.instance.collection('Freg leaves hotel');
    Fb.document(widget.ID).updateData({'url': st });
    print("Done for now");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
          builder: (context)=>SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Hero(
                          tag: widget.url,
                          child: new FadeInImage(
                            placeholder: new AssetImage("album/cons.jpg"),
                            image: new NetworkImage(widget.url),
                            fit: BoxFit.fill,
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              color: Colors.white,
                              iconSize: 25,
                              onPressed: (){
                                //action on press
                                Navigator.pop(context);
                              },
                            ),
                            Text(widget.name!=null?widget.name:'',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'PressStart2P-Regular.ttf'
                                )
                            ),
                            IconButton(
                                icon: Icon(Icons.favorite),
                                color: Colors.white,
                                onPressed: (){
                                  //action on press
                                }),

                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 220,
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton.extended(
                            onPressed: ()
                            {
                              _pickimagefromgallery(ImageSource.gallery);
                            },
                            label: Text("Change Pic",
                              style: TextStyle(
                                  fontSize: 05
                              ),
                            ),
                            backgroundColor: Colors.black54,
                            icon: Icon(Icons.photo_camera,
                                color: Colors.white
                            ),
                          ),
                        ),
                      )

                    ],
                  ),
                  SizedBox(height: 05),
                  Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.only(top: 10,right: 10, left: 10),
                    child: Column(
                      children: <Widget>[
                        Text("Details.",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(widget.details),
                            IconButton(icon: Icon(Icons.border_color ,
                            color: Colors.black,
                            ),
                                onPressed: ()
                            {


                            })
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Price: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                              ),
                            ),
                            SizedBox(width: 20),
                            Text('\$ '+widget.price,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                            )
                          ],
                        )                        ,
                        SizedBox(height: 15),
                        SizedBox(height: 80),
                        SizedBox(height: 20)
                      ],
                    ),
                  ),
                  SizedBox(height: 10)
                ]
            ),
          )
      ) ,
    );
  }
}