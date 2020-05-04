import 'dart:async';

import 'package:rethinkdb_dart/rethinkdb_dart.dart';

const databaseName = 'testdatabase';
const tableName = 'testtable';

Future<Null> run(bool withInserts) async {
  var r = Rethinkdb();
  var connection = await r.connect();
  await setup(r, connection);
  var feed =
      await r.table(tableName).changes().run(connection).asStream().first;
  feed.listen((data) {
    print('feed data: $data');
  });
  if (withInserts) {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      var record = {'id': 1, 'time': DateTime.now()};
      var count = await r.table(tableName).count().run(connection);
      if (count > 0) {
        await r.table(tableName).update(record).run(connection);
      } else {
        await r.table(tableName).insert(record).run(connection);
      }
    });
  }
}

Future<Null> setup(Rethinkdb r, Connection connection) async {
  if (((await r.dbList().run(connection)) as List).contains(databaseName)) {
    await r.dbDrop(databaseName).run(connection);
  }
  await r.dbCreate(databaseName).run(connection);
  connection.use(databaseName);
  if (((await r.tableList().run(connection)) as List).contains(tableName)) {
    await r.tableDrop(tableName).run(connection);
  }
  await r.tableCreate(tableName).run(connection);
}
