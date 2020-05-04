import 'package:rethinkdb_example/rethinkdb_example.dart' as rethinkdb_example;

Future<Null> main(List<String> arguments) async {
  var withInserts = arguments.contains('with_inserts');
  await rethinkdb_example.run(withInserts);
}
