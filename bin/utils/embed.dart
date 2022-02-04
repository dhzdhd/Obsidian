import 'dart:async';

import 'package:nyxx/nyxx.dart';
import 'dart:math';

import 'constants.dart';

final _random = Random();
final _success = Names.successList;
final _error = Names.errorList;

Future<void> deleteMessageWithTimer(
    {required IMessage message, int time = 10}) async {
  Timer(Duration(seconds: time), () async {
    await message.delete();
  });
}

EmbedBuilder confirmEmbed(String desc, IUser? author) {
  return EmbedBuilder()
    ..title = '${Emojis.question} Confirmation'
    ..description = desc
    ..color = DiscordColor.yellow
    ..timestamp = DateTime.now()
    ..addFooter((footer) {
      footer.text = 'Requested by ${author?.username}';
      footer.iconUrl = author?.avatarURL();
    });
}

EmbedBuilder successEmbed(String desc, IUser? author) {
  return EmbedBuilder()
    ..title = _success[_random.nextInt(_success.length)]
    ..description = desc
    ..color = DiscordColor.green
    ..timestamp = DateTime.now()
    ..addFooter((footer) {
      footer.text = 'Requested by ${author?.username}';
      footer.iconUrl = author?.avatarURL();
    });
}

EmbedBuilder errorEmbed(String desc, IUser? author) {
  return EmbedBuilder()
    ..title = _error[_random.nextInt(_error.length)]
    ..description = desc
    ..color = DiscordColor.red
    ..timestamp = DateTime.now()
    ..addFooter((footer) {
      footer.text = 'Error made by ${author?.username}';
      footer.iconUrl = author?.avatarURL();
    });
}

EmbedBuilder auditEmbed(
    String title, String desc, IUser? author, String _type) {
  return EmbedBuilder()
    ..title = '${Emojis.staff} $title'
    ..description = desc
    ..color = Colors.auditColors[_type]
    ..timestamp = DateTime.now()
    ..addFooter((footer) {
      footer.text = '${Names.auditEmbedFooter[_type]} ${author?.username}';
      footer.iconUrl = author?.avatarURL();
    });
}

EmbedBuilder musicEmbed(String title, String desc, IUser? author) {
  return EmbedBuilder()
    ..title = '${Emojis.music} $title'
    ..description = desc
    ..color = DiscordColor.sapGreen
    ..timestamp = DateTime.now()
    ..addFooter((footer) {
      footer.text = 'Requested by ${author?.username}';
      footer.iconUrl = author?.avatarURL();
    });
}
