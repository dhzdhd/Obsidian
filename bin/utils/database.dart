import 'package:postgres/postgres.dart';

import 'constants.dart';

class Database {
  static late PostgreSQLConnection connection;

  Database() {
    connection = PostgreSQLConnection(
      Tokens.POSTGRE_HOST,
      Tokens.POSTGRE_PORT,
      Tokens.POSTGRE_DATABASE,
      username: Tokens.POSTGRE_USER,
      password: Tokens.POSTGRE_PASSWORD,
    );
  }

  static Future<void> add(
      int userId, int guildId, String type, int value) async {
    await connection.open();

    var response = await connection.query(
        'INSERT INTO users("user", guild, $type) VALUES(@user, @guild, @value)',
        substitutionValues: {
          'user': userId,
          'guild': guildId,
          'value': value,
        });
    print(response.toString());

    await connection.close();
  }

  static Future<void> view(int userId, int guildId) async {
    await connection.open();

    var response = await connection.query(
      'SELECT * FROM users WHERE "user"=@user AND guild=@guild',
      substitutionValues: {'user': userId, 'guild': guildId},
    );
    print(response.first.asMap());

    await connection.close();
  }

  static Future<void> delete(int userId, int guildId) async {}

  static Future<void> update() async {}
}
