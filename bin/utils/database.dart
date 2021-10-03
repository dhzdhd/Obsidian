import 'package:supabase/supabase.dart';

import 'constants.dart';

late SupabaseClient _supabaseClient;

void initDatabase() {
  _supabaseClient = SupabaseClient(Tokens.SUPABASE_URL, Tokens.SUPABASE_KEY);
}

class UserDatabase {
  static Future<bool> add(
      int userId, int guildId, String type, int value) async {
    final response = await _supabaseClient.from('users').insert({
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

  static Future<Map> fetch(int userId, int guildId) async {
    final response = await _supabaseClient
        .from('users')
        .select()
        .eq('id', '$userId$guildId')
        .execute();

    return response.data[0];
  }

  static Future<bool> update(int userId, int guildId, String type) async {
    var viewResponse = await fetch(userId, guildId);
    var value = int.parse(viewResponse[type].toString());
    ++value;

    final updateResponse = await _supabaseClient
        .from('users')
        .update({'$type': value})
        .eq('id', '$userId$guildId')
        .execute();

    var flag = (updateResponse.error == null) ? true : false;
    return flag;
  }

  static Future<bool> delete(int userId, int guildId) async {
    final response = await _supabaseClient
        .from('users')
        .delete()
        .eq('id', '$userId$guildId')
        .execute();

    var flag = (response.error == null) ? true : false;
    return flag;
  }

  static Future<bool> deleteAll() async {
    final response = await _supabaseClient.from('users').delete().execute();

    var flag = (response.error == null) ? true : false;
    return flag;
  }

  // FIXME:
  static Future<List<Map>> viewAll(String amount) async {
    if (amount == '0') amount = '*';
    final response =
        await _supabaseClient.from('users').select(amount).execute();

    return response.data;
  }
}

class LogDatabase {
  static Future<bool> add(int guildId, int channelId) async {
    return true;
  }

  static Future<bool> fetch(int guildId) async {
    return true;
  }

  static Future<bool> update(int guildId, int channelId) async {
    return true;
  }

  static Future<bool> delete(int guildId) async {
    return true;
  }
}
