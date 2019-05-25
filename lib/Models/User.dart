final String _primekey = '_id';
final String _username = 'username';
final String _name = 'name';
final String _age = 'age';
final String _password = 'password';

class User {
  int id;
  String username;
  String password;
  String name;
  int age;

  User({int id, String username, String name, String password, int age}) {
    this.id = id;
    this.username = username;
    this.password = password;
    this.name = name;
    this.age = age;
  }

  User.fromMap(dynamic json) {
    id = json[_primekey];
    username = json[_username];
    password = json[_password];
    name = json[_name];
    age = int.parse(json[_age]);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      _primekey: id,
      _username: username,
      _name: name,
      _age: age,
      _password: password,
    };
    if (id != null) {
      map[_primekey] = id; 
    }
    return map;
  }

  String userDetail() {
    return '$_name $age $password $username';
  }

}