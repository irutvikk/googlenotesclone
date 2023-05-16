import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:googlenotesclone/addnote.dart';
import 'package:googlenotesclone/dbhelper.dart';
import 'package:googlenotesclone/updatenote.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MaterialApp(
    home: mainpage(),
    debugShowCheckedModeBanner: false,
  ));
}

class mainpage extends StatefulWidget {

  @override
  State<mainpage> createState() => _mainpageState();
}
class _mainpageState extends State<mainpage> {
  bool loading = false;
  bool view=false;
  Icon gridview = Icon(Icons.grid_view);
  Icon linearview = Icon(Icons.view_agenda_outlined);
  Icon show = Icon(Icons.view_agenda_outlined);

  List data = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatabase();
  }

Database? db;
  getdatabase(){

    dbhelper().getdatabase().then((value){
      setState(() {
        db=value;
      });
        setState(() {
          dbhelper().viewdata(db!).then((value) {
            data=value.reversed.toList();
            //print("mainpage data got from database==============$data=============");
            setState(() {
              loading = true;
            });
          });
        });
    });

  }

  iconmethod(){
    setState(() {
      if(view == false){
        show = gridview;
        view=true;
      }
      else{
        show = linearview;
        view=false;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    GlobalKey<ScaffoldState> _globalkey = GlobalKey();
    return loading ? Scaffold(
      key: _globalkey,
      backgroundColor: Color(0xfff5f5fa),
      body: Column(
        children: [
          const SizedBox(
            height: 45,
          ),
          // Container(
          //   margin: const EdgeInsets.only(left: 20, right: 20),
          //   decoration: BoxDecoration(
          //     color: const Color(0xf0ecebeb),
          //     borderRadius: BorderRadius.circular(30)
          //   ),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //
          //       Expanded(
          //         child: InkWell(
          //           onTap: () {
          //
          //           },
          //           child: Container(
          //             alignment: Alignment.centerLeft,
          //             width: 215,
          //             height: 40,
          //             child: Row(children: [
          //               Expanded(child: Container(margin: EdgeInsets.only(left: 5),decoration: BoxDecoration(color: Colors.red.withOpacity(0.9),borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20))),)),
          //               Expanded(child: Container(color: Colors.green.withOpacity(0.9),)),
          //               Expanded(child: Container(color: Colors.orange.withOpacity(0.9),)),
          //               Expanded(child: Container(decoration: BoxDecoration(color: Colors.blue.withOpacity(0.9),borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20))),)),
          //
          //             ],),
          //           ),
          //         ),
          //       ),
          //       IconButton(
          //         highlightColor: Colors.transparent,
          //         splashColor: Colors.transparent,
          //         onPressed: () {
          //           iconmethod();
          //
          //         }, icon: show,),
          //       CircleAvatar(
          //         backgroundImage: AssetImage("images/profile.jpeg"),
          //         minRadius: 14,
          //       ),
          //       const SizedBox(width: 10,)
          //     ],
          //   ),
          // ),
          const SizedBox(
            height: 2,
          ),
          Expanded(
            child: view ? ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(5),
              itemCount: data.length,
              itemBuilder: (context, index) {
              return InkWell(
                customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                splashFactory: NoSplash.splashFactory,
                onTap: () {
                  int id=data[index]['ID'];
                  print("Passing id for update page = $id");
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return updatenotepage(id);
                  },));
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(35)
                  ),
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 10),
                  child: Stack(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.all(5),
                        title: Text("${data[index]['TITLE']}",
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                        subtitle: Text("${data[index]['NOTES']}",
                          maxLines: 5,
                          style: TextStyle(fontSize: 18,color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ),
                      Positioned(
                          height: 40,
                          width: 40,
                          bottom:10,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              dbhelper().deletedata(data[index]['ID'],db!).then((value){
                                setState(() {
                                  getdatabase();
                                });
                              });
                            },
                            child: Container(alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.red.shade900.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              height: 40,
                              width: 40,
                              child: Icon(Icons.delete_forever_rounded,size: 30,color: Colors.white),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              );
            },) : GridView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(5),
              itemCount: data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisExtent: 190,crossAxisCount: 2),
              itemBuilder: (context, index) {
                return InkWell(
                  customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  splashFactory: NoSplash.splashFactory,
                  onTap: () {
                    int id=data[index]['ID'];
                    print("Passing id for update page = $id");
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return updatenotepage(id);
                    },));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(35)
                    ),
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 10),
                    height: 70,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${data[index]['TITLE']}",
                              maxLines: 2,
                              style: TextStyle(fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Expanded(
                              child: Text("${data[index]['NOTES']}",
                                maxLines: 6,
                                style: TextStyle(fontSize: 18,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          height: 40,
                          width: 40,
                          bottom:0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              dbhelper().deletedata(data[index]['ID'],db!).then((value){
                                setState(() {
                                  getdatabase();
                                });
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red.shade900.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(15)
                            ),
                              height: 40,
                              width: 40,
                              child: Icon(Icons.delete_forever_rounded,size: 30,color: Colors.white),
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 20,right: 20),
        child: InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return addnote();
            },));
          },
          child: SvgPicture.asset("icons/iconadd.svg",height: 70,width: 70,
          ),
        ),
    ),
    ) : Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
    ),
    );
  }
}