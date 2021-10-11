import 'package:nyxx/nyxx.dart';

import '../../obsidian_dart.dart' show bot;
import '../../utils/database.dart' show LogDatabase;
import '../../utils/embed.dart';

class ModEventsInteractions {
  ModEventsInteractions() {
    initEvents();
  }

  void initEvents() {
    bot.onGuildMemberAdd.listen((event) async {
      final guild = event.guild.getFromCache()!;
      final member = event.member;

      final response = await LogDatabase.fetch(guildId: guild.id.id);

      if (response != []) {
        final channelId = response[0]['channel'];
        final channel = bot.fetchChannel(channelId) as TextGuildChannel;

        await channel.sendMessage(MessageBuilder.embed(auditEmbed(
          'Member joined!',
          '${member.nickname} has joined the server!',
          bot.self,
          'member',
        )));
      }
    });

    bot.onGuildMemberRemove.listen((event) async {
      final guild = event.guild.getFromCache()!;
      final user = event.user;

      final response = await LogDatabase.fetch(guildId: guild.id.id);

      if (response != []) {
        final channelId = response[0]['channel'];
        final channel = bot.fetchChannel(channelId) as TextGuildChannel;

        await channel.sendMessage(MessageBuilder.embed(auditEmbed(
          'Member left!',
          '${user.username} has left the server!',
          bot.self,
          'member',
        )));
      }
    });

    // TODO: get channel name for embed title
    bot.onMessageDelete.listen((event) async {
      final channel = event.channel.getFromCache()! as GuildChannel;
      final message = event.message!;
      final guildId = channel.guild.id.id;

      final response = await LogDatabase.fetch(guildId: guildId);

      if (response.isNotEmpty) {
        final channelId = response[0]['channel'];
        final channel =
            (await bot.fetchChannel(Snowflake(channelId))) as TextChannel;

        await channel.sendMessage(MessageBuilder.embed(auditEmbed(
          'Message deleted in channel: ${channel.toString()})}',
          message.content,
          message.author as User,
          'msg_delete',
        )));
      }
    });
  }
}
