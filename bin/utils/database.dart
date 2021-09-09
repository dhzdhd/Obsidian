import 'dart:cli';

import 'package:postgres/postgres.dart';

import 'constants.dart';

// FIXME: Fix weird ass errors from db
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
    waitFor(connection.open());
  }

  static Future<bool> add(
      int userId, int guildId, String type, int value) async {
    // var result = await view(userId, guildId);

    // if (result['user'] == userId && result['guild'] == guildId) return false;

    await connection.transaction((ctx) async {
      await ctx.query(
          'INSERT INTO users("user", guild, $type) VALUES(@user, @guild, @value)',
          substitutionValues: {
            'user': userId,
            'guild': guildId,
            'value': value,
          });
    });
    return true;
  }

  // TODO: Check map for null
  static Future<Map<String, int>> view(int userId, int guildId) async {
    var response = await connection.query(
      'SELECT * FROM users WHERE "user"=@user AND guild=@guild',
      substitutionValues: {'user': userId, 'guild': guildId},
    );
    print(response.first.toString());
    final map = response.first.asMap();
    print(map);
    return {
      'user': map[1],
      'guild': map[2],
      'warns': map[3],
      'mutes': map[4],
      'bans': map[5]
    };
  }

  static Future<void> delete(int userId, int guildId) async {
    await connection.transaction((ctx) async {
      await ctx.query(
        'DELETE FROM users WHERE "user"=@user AND guild=@guild',
        substitutionValues: {'user': userId, 'guild': guildId},
      );
    });
  }

  static Future<void> update(
      int userId, int guildId, String type, int value) async {
    await connection.transaction((ctx) async {
      var response = await ctx.query(
          'UPDATE users SET $type=@value WHERE "user"=@user AND guild=@guild',
          substitutionValues: {
            'value': value,
            'user': userId,
            'guild': guildId
          });
      print(response.toString());
    });
  }
}
