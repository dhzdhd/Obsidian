import 'package:nyxx/nyxx.dart';
import 'dart:math';

import 'constants.dart';

final _random = Random();
final _success = Names.SUCCESS_LIST;
final _error = Names.ERROR_LIST;

EmbedBuilder successEmbed(String desc, User? author) {
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

EmbedBuilder errorEmbed(String desc, User? author) {
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
    String title, String desc, Member author, String _type) {
  return EmbedBuilder()
    ..title = title
    ..description = desc
    ..color = Colors.AUDIT_COLORS[_type]
    ..timestamp = DateTime.now()
    ..addFooter((footer) {
      footer.text = '${Names.AUDIT_EMBED_FOOTER[_type]} ${author.nickname}';
      footer.iconUrl = author.user.getFromCache()?.avatarURL();
    });
}
