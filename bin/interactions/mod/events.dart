import 'package:nyxx/nyxx.dart';

import '../../obsidian_dart.dart' show bot;
import '../../utils/constants.dart';
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

      if (response.isNotEmpty) {
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

      if (response.isNotEmpty) {
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

    bot.onMessageDelete.listen((event) async {
      final channel = event.channel.getFromCache()! as TextGuildChannel;
      final message = event.message!;
      final guildId = channel.guild.id.id;

      if (message.author.bot) return;

      final response = await LogDatabase.fetch(guildId: guildId);

      if (response.isNotEmpty) {
        final channelId = response[0]['channel'];
        final logChannel =
            (await bot.fetchChannel(Snowflake(channelId))) as TextGuildChannel;

        await logChannel.sendMessage(MessageBuilder.embed(auditEmbed(
          'Message deleted in channel: ${channel.name}',
          message.content,
          message.author as User,
          'msg_delete',
        )));
      }
    });

    bot.onMessageUpdate.listen((event) async {
      final channel = event.channel.getFromCache()! as TextGuildChannel;
      final oldMessage = await event.channel.fetchMessage(event.messageId);
      final updatedMessage = event.updatedMessage!;
      final guildId = channel.guild.id.id;

      if (updatedMessage.author.bot) return;

      final response = await LogDatabase.fetch(guildId: guildId);

      if (response.isNotEmpty) {
        final channelId = response[0]['channel'];
        final logChannel =
            (await bot.fetchChannel(Snowflake(channelId))) as TextGuildChannel;

        await logChannel.sendMessage(MessageBuilder.embed(auditEmbed(
          'Message edited in channel: ${channel.name}',
          '''
          **Old:**\n${oldMessage.content}
          **New:**\n${updatedMessage.content}
          ''',
          oldMessage.author as User,
          'msg_edit',
        )));
      }
    });

    bot.onGuildBanAdd.listen((event) {});

    bot.onDmReceived.listen((event) async {
      final owner = await bot.fetchUser(Snowflake(Tokens.BOT_OWNER));
      final user = event.message.author as User;

      if (user == bot.self) return;

      await owner.sendMessage(MessageBuilder.embed(
        EmbedBuilder()
          ..title = 'DM recieved!'
          ..description = '''
          Author: ${user.mention}
          Message:\n ${event.message.content}
          '''
          ..color = DiscordColor.goldenrod
          ..timestamp = DateTime.now()
          ..addFooter((footer) {
            footer.text = 'Message sent by ${user.username}';
            footer.iconUrl = user.avatarURL();
          }),
      ));
    });
  }
}
