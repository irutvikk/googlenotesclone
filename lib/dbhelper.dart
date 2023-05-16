import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class dbhelper{

  Future<Database> getdatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              "create table Notesdata (ID integer primary key autoincrement, TITLE text, NOTES text) ");
        });
    return database;
  }

  Future<void> insertdata(String usertitlee, String usernotee, Database db) async {
      String insertrecord = "insert into Notesdata (TITLE,NOTES) values ('$usertitlee','$usernotee') ";
      int aa= await db.rawInsert(insertrecord);

  }

  Future<List> passdatatoupdate(id,Database db) async {
    String view= "select * from Notesdata where ID = '$id' ";
    List selected_id_value= await db.rawQuery(view);
    print("getting values of selected id=======$selected_id_value");
    // print("data from database page::::::::===========$ll=======");
    return selected_id_value;
  }

   Future<List> viewdata(Database db) async {
    String view= "select * from Notesdata";
   List ll= await db.rawQuery(view);
   // print("data from database page::::::::===========$ll=======");
   return ll;
  }

  Future<void> updatedata(int id, String usertitlee, String usernotee, Database db) async {
    String update = "update Notesdata set TITLE = '$usertitlee', NOTES = '$usernotee' where ID = '$id' ";
    int aa = await db.rawUpdate(update);
  }

  Future<void> deletedata(id, Database db) async {
    String delete = "delete from Notesdata where ID = '$id' ";
    int aa = await db.rawDelete(delete);
  }

}