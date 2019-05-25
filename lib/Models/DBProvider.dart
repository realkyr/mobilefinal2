import 'package:sqflite/sqflite.dart';
import './User.dart';

final String _primekey = '_id';
final String _username = 'username';
final String _name = 'name';
final String _age = 'age';
final String _password = 'password';

class DBProvider {
  Database db;

  Future initDB() async {
    String path = "User.db";

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table user (
        $_primekey integer primary key autoincrement,
        $_username text not null unique,
        $_name text not null,
        $_age text not null,
        $_password text not null
      )
      ''');
    });
  }

  Future<User> insertUser(User user) async {
    user.id = await db.insert('User', user.toMap());
    return user;
  }

  Future<User> getUser(int id) async {
    List<Map<String, dynamic>> maps = await db.query('User',
        columns: [_primekey, _username, _name, _age, _password],
        where: '$_primekey = ?',
        whereArgs: [id]);
    return maps.length > 0 ? new User.fromMap(maps.first) : null;
  }

  Future<int> deleteUser(int id) async {
    return await db.delete('User', where: '$_primekey = ?', whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    return db.update('User', user.toMap(),
        where: '$_primekey = ?', whereArgs: [user.id]);
  }

  Future<List<User>> getAllUser() async {
    var res = await db
        .query('User', columns: [_primekey, _username, _name, _age, _password]);
    List<User> userList =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : [];
    return userList;
  }

  Future close() async => db.close();
}
