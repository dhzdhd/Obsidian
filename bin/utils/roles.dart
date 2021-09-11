import 'package:nyxx_interactions/interactions.dart';

import '../obsidian_dart.dart';

class UtilsRolesInteractions {
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
                  CommandOptionType.role, 'role', 'Name of role')
            ],
          )..registerHandler(addToRoleSlashCommand),
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'delete',
            'Delete a role.',
            options: [
              CommandOptionBuilder(
                  CommandOptionType.role, 'role', 'Name of role.')
            ],
          )..registerHandler(deleteRoleSlashCommand)
        ],
      ))
      ..registerButtonHandler('roleadd', addRoleButtonHandler)
      ..registerButtonHandler('roleremove', removeRoleButtonHandler)
      ..registerButtonHandler('cancelrole', cancelButtonHandler);
  }

  Future<void> addToRoleSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
  }

  Future<void> addRoleButtonHandler(ButtonInteractionEvent event) async {}

  Future<void> removeRoleButtonHandler(ButtonInteractionEvent event) async {}

  Future<void> cancelButtonHandler(ButtonInteractionEvent event) async {}

  Future<void> deleteRoleSlashCommand(
      SlashCommandInteractionEvent event) async {
    await event.acknowledge();
  }
}
