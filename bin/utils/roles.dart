import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../obsidian_dart.dart';
import 'constants.dart';

class UtilsRolesInteractions {
  late Message? message;
  late Role? role;

  UtilsRolesInteractions() {
    botInteractions
      ..registerSlashCommand(SlashCommandBuilder(
        'role',
        'Role group of commands',
        [
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'add',
            'Add users to an existing role.',
            options: [
              CommandOptionBuilder(
                  CommandOptionType.role, 'role', 'Name of role',
                  required: true)
            ],
          )..registerHandler(addToRoleSlashCommand),
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'delete',
            'Delete a role.',
            options: [
              CommandOptionBuilder(
                  CommandOptionType.role, 'role', 'Name of role.',
                  required: true)
            ],
          )..registerHandler(deleteRoleSlashCommand)
        ],
      ))
      ..registerButtonHandler('roleAdd', addRoleButtonHandler)
      ..registerButtonHandler('roleRemove', removeRoleButtonHandler)
      ..registerButtonHandler('roleCancel', cancelButtonHandler);
  }

  Future<void> addToRoleSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    role = event.interaction.resolved?.roles.first;

    final addRoleEmbed = EmbedBuilder()
      ..title = 'Add the below role to yourself'
      ..description = '${role?.mention}'
      ..color = DiscordColor.aquamarine
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    message = await event.sendFollowup(MessageBuilder.embed(addRoleEmbed));
  }

  Future<void> addRoleButtonHandler(ButtonInteractionEvent event) async {
    await event.acknowledge();

    await event.interaction.memberAuthor?.addRole(role!);

    await event.interaction.userAuthor
        ?.sendMessage(MessageBuilder.content('Added ${role?.name} to you!'));
  }

  Future<void> removeRoleButtonHandler(ButtonInteractionEvent event) async {}

  Future<void> cancelButtonHandler(ButtonInteractionEvent event) async {
    await event.acknowledge();
  }

  Future<void> deleteRoleSlashCommand(
      SlashCommandInteractionEvent event) async {
    await event.acknowledge();

    await message?.delete();
  }
}
