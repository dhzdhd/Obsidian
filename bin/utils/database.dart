import 'package:postgres/postgres.dart';
import 'package:supabase/supabase.dart';

import 'constants.dart';

// FIXME: Fix weird ass errors from db
class Database {
  static late SupabaseClient supabaseClient;
  // static late PostgreSQLConnection connection;

  Database() {
    // connection = PostgreSQLConnection(
    //   Tokens.POSTGRE_HOST,
    //   Tokens.POSTGRE_PORT,
    //   Tokens.POSTGRE_DATABASE,
    //   username: Tokens.POSTGRE_USER,
    //   password: Tokens.POSTGRE_PASSWORD,
    // );
    // waitFor(connection.open());

    supabaseClient = SupabaseClient(Tokens.SUPABASE_URL, Tokens.SUPABASE_KEY);
  }

  static Future<bool> add(
      int userId, int guildId, String type, int value) async {
    // await connection.transaction((ctx) async {
    //   try {
    //     await ctx.execute(
    //         'INSERT INTO users(id, "user", guild, $type) VALUES(@id, @user, @guild, @value)',
    //         substitutionValues: {
    //           'id': '$userId$guildId',
    //           'user': userId,
    //           'guild': guildId,
    //           'value': value,
    //         });
    //   } catch (err) {
    //     await update(userId, guildId, type);
    //   }
    // });

    final response = await supabaseClient.from('users').insert({
      'id': '$userId$guildId',
      'user': userId,
      'guild': guildId,
      '$type': value,
    }).execute();

    if (response.error == null) {
      return true;
    } else {
      var flag = (await update(userId, guildId, type)) ? true : false;
      return flag;
    }
  }

  // TODO: Check map for null
  static Future<Map<String, int>> view(int userId, int guildId) async {
    // var response = await connection.query(
    //   'SELECT * FROM users WHERE id=@id',
    //   substitutionValues: {'id': '$userId$guildId'},
    // );
    // print(response.first.toString());
    // final map = response.first.asMap();
    // print(map);
    // return {
    //   'user': map[1],
    //   'guild': map[2],
    //   'warns': map[3],
    //   'mutes': map[4],
    //   'bans': map[5]
    // };

    final response = await supabaseClient
        .from('users')
        .select()
        .eq('id', '$userId$guildId')
        .execute();
    print(response.data);

    return {};
  }

  static Future<bool> delete(int userId, int guildId) async {
    // await connection.transaction((ctx) async {
    //   await ctx.execute(
    //     'DELETE FROM users WHERE id=@id',
    //     substitutionValues: {'id': '$userId$guildId'},
    //   );
    // });

    final response = await supabaseClient
        .from('users')
        .delete()
        .eq('id', '$userId$guildId')
        .execute();

    if (response.error == null) {
      return true;
    }
    return false;
  }

  static Future<bool> update(int userId, int guildId, String type) async {
    final viewResponse = await view(userId, guildId);
    var value = viewResponse['$type'] as int;
    ++value;

    // await connection.transaction((ctx) async {
    //   var response = await ctx.execute(
    //       'UPDATE users SET $type=@value WHERE id=@id',
    //       substitutionValues: {
    //         'value': value,
    //         'id': '$userId$guildId',
    //       });
    //   print(response.toString());
    // });

    final updateResponse = await supabaseClient
        .from('users')
        .update({'$type': value})
        .eq('id', '$userId$guildId')
        .execute();

    if (updateResponse.error == null) {
      return true;
    }
    return false;
  }
}
