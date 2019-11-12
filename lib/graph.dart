import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:hpee/screenreducer.dart';

class graph extends StatefulWidget
{
 @override
 Graph createState() => Graph();
}

class Graph extends State<graph>
{
 int Total_Price = 0;
 var data = [0.0, 1.0, 3.0, 4.0, 5.0 ,7.0,0.4, 0.0];


  Calcget(DocumentSnapshot documents)
  {
    for(DocumentSnapshot document in documents )
    {
      Total_Price = Total_Price + int.parse(document.data['price']);
    }
return Total_Price;
  }
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream:
        Firestore.instance.collection("receipts_for_Mpesa").where('Hotelname',isEqualTo: 'Freg Hotel').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot>snapshot) {
          if (snapshot.hasError)
          {
            return Center(
                child:Text("Error occured..")
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height:screenHeight(context,dividedBy: 1),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              );
            default:
              return Scaffold(
                appBar: AppBar(
                  title: Text("Statistics",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 08
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2.0,
                          child:Column(
                            children: <Widget>[
                              Calcget(snapshot.data.documents),
                              Text("Mpesa",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Divider(),
                                Text(Total_Price.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                                ),
                              Padding(padding: EdgeInsets.all(1.0),
                                child: Sparkline(
                                    data: data,
                                  fillMode: FillMode.below,
                                  fillGradient:  new LinearGradient(
                                    begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Color(0xff25242A),Color(0xff182640)],
                                  ),
                                ),
                              )
                            ],
                          )
                      )
                    ],
                  ),

                ),
              );
          }
        }
    );

  }

}