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
      final flag = (await update(userId, guildId, type)) ? true : false;
      return flag;
    }
  }

  static Future<List> fetch({int? userId, int? guildId, int? amount}) async {
    late final PostgrestResponse response;

    if (userId == null) {
      response = await _supabaseClient.from('users').select().execute();
    } else {
      response = await _supabaseClient
          .from('users')
          .select()
          .eq('id', '$userId$guildId')
          .execute();
    }

    if (response.data == null) return [];

    if (amount == null) {
      return response.data;
    } else {
      try {
        return (response.data as List).sublist(0, amount);
      } catch (err) {
        return response.data;
      }
    }
  }

  static Future<bool> update(int userId, int guildId, String type) async {
    var viewResponse = await fetch(userId: userId, guildId: guildId);
    var value = int.parse(viewResponse[0][type].toString());
    ++value;

    final updateResponse = await _supabaseClient
        .from('users')
        .update({'$type': value})
        .eq('id', '$userId$guildId')
        .execute();

    var flag = (updateResponse.error == null) ? true : false;
    return flag;
  }

  static Future<bool> delete([int? userId, int? guildId]) async {
    late final PostgrestResponse response;

    if (userId == null) {
      response = await _supabaseClient.from('users').delete().execute();
    } else {
      response = await _supabaseClient
          .from('users')
          .delete()
          .eq('id', '$userId$guildId')
          .execute();
    }

    var flag = (response.error == null) ? true : false;
    return flag;
  }
}

class LogDatabase {
  static Future<bool> add(int guildId, int channelId) async {
    final response = await _supabaseClient.from('log').insert({
      'guild': guildId,
      'channel': channelId,
    }).execute();

    if (response.error == null) {
      return true;
    } else {
      var flag = (await update(guildId, channelId)) ? true : false;
      return flag;
    }
  }

  static Future<List> fetch({int? guildId, int? amount}) async {
    late final PostgrestResponse response;

    if (guildId == null) {
      response = await _supabaseClient.from('log').select().execute();
    } else {
      response = await _supabaseClient
          .from('log')
          .select()
          .eq('guild', guildId)
          .execute();
    }

    if (response.data == null) return [];

    if (amount == null) {
      return response.data;
    } else {
      try {
        return (response.data as List).sublist(0, amount);
      } catch (err) {
        return response.data;
      }
    }
  }

  static Future<bool> update(int guildId, int channelId) async {
    final response = await _supabaseClient
        .from('log')
        .update({'channel': channelId})
        .eq('guild', guildId)
        .execute();

    var flag = (response.error == null) ? true : false;
    return flag;
  }

  static Future<bool> delete([int? guildId]) async {
    late final PostgrestResponse response;

    if (guildId == null) {
      response = await _supabaseClient.from('log').delete().execute();
    } else {
      response = await _supabaseClient
          .from('log')
          .delete()
          .eq('guild', guildId)
          .execute();
    }

    var flag = (response.error == null) ? true : false;
    return flag;
  }
}
