import 'package:rethinkdb_example/rethinkdb_example.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(run(), 42);
  });
}
