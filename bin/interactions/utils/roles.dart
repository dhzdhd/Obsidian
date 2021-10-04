import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart';
import '../../utils/constants.dart';
import '../../utils/constraints.dart';
import '../../utils/embed.dart';

// TODO: Make messages ephemeral
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
            '<MOD ONLY> Add users to an existing role.',
            options: [
              CommandOptionBuilder(
                  CommandOptionType.role, 'role', 'Name of role',
                  required: true)
            ],
          )..registerHandler(addToRoleSlashCommand),
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'delete',
            '<MOD ONLY> Delete a role.',
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

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.content(
          'You do not have the permissions to use this command!'));
      return;
    }

    final addRoleEmbed = EmbedBuilder()
      ..title = 'Add the below role to yourself'
      ..description = '${role?.name}'
      ..color = DiscordColor.aquamarine
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    message = await event.sendFollowup(MessageBuilder.embed(addRoleEmbed));

    final componentMessageBuilder = ComponentMessageBuilder();
    final componentRow = ComponentRowBuilder()
      ..addComponent(
          ButtonBuilder('Add role', 'roleAdd', ComponentStyle.primary))
      ..addComponent(
          ButtonBuilder('Remove role', 'roleRemove', ComponentStyle.secondary))
      ..addComponent(
          ButtonBuilder('Delete', 'roleCancel', ComponentStyle.danger));
    componentMessageBuilder.addComponentRow(componentRow);

    await event.respond(componentMessageBuilder);
  }

  Future<void> addRoleButtonHandler(ButtonInteractionEvent event) async {
    await event.acknowledge();

    try {
      await event.interaction.memberAuthor?.addRole(role as SnowflakeEntity);
    } catch (err) {
      await event.respond(
          MessageBuilder.content('You already have the role - ${role?.name}!'),
          hidden: true);
    }

    await event.sendFollowup(
      MessageBuilder.content('Added role - ${role?.name} to you!'),
    );
  }

  Future<void> removeRoleButtonHandler(ButtonInteractionEvent event) async {
    await event.acknowledge();

    await event.interaction.memberAuthor?.removeRole(role as SnowflakeEntity);

    await event.respond(
        MessageBuilder.content('Removed role - ${role?.name} from you!'),
        hidden: true);
  }

  Future<void> cancelButtonHandler(ButtonInteractionEvent event) async {
    await event.acknowledge();

    await message?.delete();
  }

  Future<void> deleteRoleSlashCommand(
      SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    role = event.interaction.resolved?.roles.first;

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.content(
          'You do not have the permissions to use this command!'));
      return;
    }

    try {
      await role?.delete();
      await event.respond(MessageBuilder.embed(successEmbed(
          'The given role was successfully deleted!',
          event.interaction.userAuthor)));
    } catch (err) {
      await event.respond(MessageBuilder.embed(errorEmbed(
          'Error in deleting the given role!', event.interaction.userAuthor)));
    }
  }
}
