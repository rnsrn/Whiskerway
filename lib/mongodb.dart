import 'dart:developer';

import 'package:flutter_mobile_whiskerway/cons.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    var status = db.serverStatus();

    var collection = db.collection(COLLECTION_NAME);
  }

  static create(String cName, Map<String, dynamic> data) async {
    var db = await Db.create(MONGO_URL);
    var collection = db.collection(cName);

    await collection.insertOne(data);
  }
}
