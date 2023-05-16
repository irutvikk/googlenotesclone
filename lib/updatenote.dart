import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:googlenotesclone/main.dart';
import 'package:sqflite/sqflite.dart';

import 'dbhelper.dart';

class updatenotepage extends StatefulWidget {
  int id;
  updatenotepage(this.id);


  @override
  State<updatenotepage> createState() => _updatenotepageState();

}

class _updatenotepageState extends State<updatenotepage> {
  Database? db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdatabase();
  }

  getdatabase(){
    dbhelper().getdatabase().then((value){
      setState(() {
        db=value;
      });
      dbhelper().passdatatoupdate(widget.id,db!).then((value){
        setState(() {
          usertitle.text = "${value[0]['TITLE']}";
          usernote.text = "${value[0]['NOTES']}";
        });
      });
    });

  }
  TextEditingController usertitle = TextEditingController();
  TextEditingController usernote = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(onPressed: () {
                  String usertitlee = usertitle.text;
                  String usernotee = usernote.text;

                  setState(() {
                    if(usertitlee.isNotEmpty || usernotee.isNotEmpty){
                      //update where id......
                      dbhelper().updatedata(widget.id,usertitlee,usernotee,db!);
                    }
                  });
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return mainpage();
                  },));
                }, icon: const Icon(Icons.arrow_back_rounded,size: 26),),
                Expanded(child: SizedBox()),
                SvgPicture.asset("icons/modeonedit.svg",height: 25,
                ),
                SizedBox(width: 10,),
              ],
            ),
          ),
          // const SizedBox(
          //   height: 30,
          // ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 15,left: 20,right: 20),
                    child: TextField(
                      controller: usertitle,
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                      textCapitalization: TextCapitalization.sentences,
                      cursorWidth: 1,
                      //clipBehavior: Clip.antiAlias,
                      cursorColor: Color(0xFF8C8585),
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration.collapsed(
                        hintText: "Title",
                        hintStyle: TextStyle(
                            fontSize: 24,
                            color: Color(0xFF8C8585),
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20,right: 20),
                    child: TextField(
                      controller: usernote,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 35,
                      style: TextStyle(fontSize: 18,),
                      cursorWidth: 1,
                      //clipBehavior: Clip.antiAlias,
                      cursorColor: Color(0xFF8C8585),
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration.collapsed(
                        hintText: "Note",
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF8C8585),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
}
