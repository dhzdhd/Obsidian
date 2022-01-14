import 'package:nyxx/nyxx.dart';

import '../../obsidian_dart.dart' show bot;
import '../../utils/constants.dart';
import '../../utils/database.dart' show LogDatabase;
import '../../utils/embed.dart';

class ModEventsInteractions {
  ModEventsInteractions() {
    bot.eventsWs.onDmReceived.listen(onDmReceived);
    bot.eventsWs.onMessageDelete.listen(onMessageDelete);
    bot.eventsWs.onMessageUpdate.listen(onMessageUpdate);
    bot.eventsWs.onGuildMemberAdd.listen(onGuildMemberAdd);
    bot.eventsWs.onGuildMemberRemove.listen(onGuildMemberRemove);
  }

  Future<void> onDmReceived(IMessageReceivedEvent event) async {
    final owner = await bot.fetchUser(Snowflake(Tokens.botOwner));
    final user = event.message.author as IUser;

    if (user.bot) return;

    final message = event.message;
    final messageCondition = message.content.isNotEmpty
        ? message.content.contains(RegExp(r'\`\`\`(.*?)\`\`\`'))
            ? message.content
            : '```${message.content}```'
        : 'No content';

    final dmEmbed = EmbedBuilder()
      ..title = 'DM recieved!'
      ..description = '''
          Author: ${user.mention}
          Message: $messageCondition
          '''
      ..color = DiscordColor.goldenrod
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Message sent by ${user.username}';
        footer.iconUrl = user.avatarURL();
      });

    if (message.attachments.isNotEmpty) {
      dmEmbed.imageUrl = message.attachments.first.url;
    }

    await owner.sendMessage(MessageBuilder.embed(dmEmbed));
  }

  Future<void> onMessageDelete(IMessageDeleteEvent event) async {
    final channel = event.channel.getFromCache()! as ITextGuildChannel;
    final message = event.message!;
    final guildId = channel.guild.id.id;

    if (message.author.bot) return;

    final response = (await LogDatabase.fetch(guildId: guildId)) as List;

    if (response.isNotEmpty) {
      final dynamic channelId = response[0]['channel'];
      final logChannel =
          (await bot.fetchChannel(Snowflake(channelId))) as ITextGuildChannel;

      final messageCondition = message.content.isNotEmpty
          ? message.content.contains(RegExp(r'\`\`\`(.*?)\`\`\`'))
              ? message.content
              : '```${message.content}```'
          : 'No content';
      final delEmbed = auditEmbed(
        'Message deleted in channel: ${channel.name}',
        '''
          Author: ${(message.author as IUser).mention}
          Message: $messageCondition
          ''',
        message.author as IUser,
        'msg_delete',
      );

      if (message.attachments.isNotEmpty) {
        delEmbed.imageUrl = message.attachments.first.url;
      }

      await logChannel.sendMessage(MessageBuilder.embed(delEmbed));
    }
  }

  Future<void> onMessageUpdate(IMessageUpdateEvent event) async {
    /// ! Commented out for now. To be implemented after the API is ready.
    /*
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
        oldMessage.author as IUser,
        'msg_edit',
      )));
    }
    */
  }

  Future<void> onGuildMemberAdd(IGuildMemberAddEvent event) async {
    final guild = event.guild.getFromCache()!;
    final member = event.member;

    final response = (await LogDatabase.fetch(guildId: guild.id.id)) as List;

    if (response.isNotEmpty) {
      final dynamic channelId = response[0]['channel'];
      final channel =
          bot.fetchChannel(Snowflake(channelId)) as ITextGuildChannel;

      await channel.sendMessage(MessageBuilder.embed(auditEmbed(
        'Member joined!',
        '${member.nickname} has joined the server!',
        bot.self,
        'member',
      )));
    }
  }

  Future<void> onGuildMemberRemove(IGuildMemberRemoveEvent event) async {
    final guild = event.guild.getFromCache()!;
    final user = event.user;

    final List response =
        (await LogDatabase.fetch(guildId: guild.id.id)) as List;

    if (response.isNotEmpty) {
      final dynamic channelId = response[0]['channel'];
      final channel =
          bot.fetchChannel(Snowflake(channelId)) as ITextGuildChannel;

      await channel.sendMessage(MessageBuilder.embed(auditEmbed(
        'Member left!',
        '${user.username} has left the server!',
        bot.self,
        'member',
      )));
    }
  }
}
