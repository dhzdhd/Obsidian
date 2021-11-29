import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/interactions.dart';

import '../../obsidian_dart.dart';
import '../../utils/constraints.dart';
import '../../utils/embed.dart';

class UtilsRolesInteractions {
  Map<int, Role?> roleMap = {};
  Map<int, List> embedRolesMap = {};
  late EmbedBuilder embed;

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
      ..registerButtonHandler('role-add', addRoleButtonHandler)
      ..registerButtonHandler('role-remove', removeRoleButtonHandler)
      ..registerButtonHandler('role-cancel', cancelButtonHandler);
  }

  Future<void> addToRoleSlashCommand(SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final role = event.interaction.resolved?.roles.first;

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.content(
          'You do not have the permissions to use this command!'));
      return;
    }

    embed = EmbedBuilder()
      ..title = 'Add the below role to yourself - ${role?.name}'
      ..color = DiscordColor.aquamarine
      ..timestamp = DateTime.now()
      ..addField(name: 'Members who added the role to themselves:')
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    final message = await event.sendFollowup(MessageBuilder.embed(embed));

    final componentMessageBuilder = ComponentMessageBuilder();
    final componentRow = ComponentRowBuilder()
      ..addComponent(
          ButtonBuilder('Add role', 'role-add', ComponentStyle.primary))
      ..addComponent(
          ButtonBuilder('Remove role', 'role-remove', ComponentStyle.secondary))
      ..addComponent(
          ButtonBuilder('Delete', 'role-cancel', ComponentStyle.danger));
    componentMessageBuilder.addComponentRow(componentRow);

    await event.respond(componentMessageBuilder);
    roleMap[message.id.id] = role;
    embedRolesMap[message.id.id] = [];
  }

  Future<void> addRoleButtonHandler(ButtonInteractionEvent event) async {
    await event.acknowledge(hidden: true);
    final role = roleMap[event.interaction.message!.id.id];
    final messageId = event.interaction.message!.id.id;

    if (event.interaction.memberAuthor!.roles.contains(role)) {
      await event.interaction.userAuthor?.sendMessage(
        MessageBuilder.content('You already have the role - ${role?.name}!'),
      );
      return;
    }

    await event.interaction.memberAuthor?.addRole(role as SnowflakeEntity);

    var oldField = embed.fields.first;

    embedRolesMap[messageId]!.add(event.interaction.userAuthor?.mention);
    var content = '';
    embedRolesMap[messageId]!.forEach((element) {
      content += '${element.toString()}';
    });

    await event.editOriginalResponse(
      MessageBuilder.embed(
        embed..replaceField(name: oldField.name, content: content),
      ),
    );

    await event.interaction.userAuthor?.sendMessage(
      MessageBuilder.embed(successEmbed(
          'Added role - ${role?.name} to you!', event.interaction.userAuthor)),
    );
  }

  Future<void> removeRoleButtonHandler(ButtonInteractionEvent event) async {
    await event.acknowledge(hidden: true);
    final role = roleMap[event.interaction.message!.id.id];
    final messageId = event.interaction.message!.id.id;

    try {
      await event.interaction.memberAuthor?.removeRole(role as SnowflakeEntity);
    } catch (err) {
      await event.interaction.userAuthor?.sendMessage(
        MessageBuilder.content('You already have the role - ${role?.name}!'),
      );
      return;
    }

    var oldField = embed.fields.first;
    print(oldField);

    embedRolesMap[messageId]!.remove(event.interaction.userAuthor?.mention);
    var content = '';
    embedRolesMap[messageId]!.forEach((element) {
      content += '${element.toString()}';
    });

    await event.editOriginalResponse(
      MessageBuilder.embed(
        embed..replaceField(name: oldField.name, content: content),
      ),
    );

    await event.interaction.userAuthor?.sendMessage(
      MessageBuilder.embed(successEmbed(
          'Removed role - ${role?.name} from you!',
          event.interaction.userAuthor)),
    );
  }

  Future<void> cancelButtonHandler(ButtonInteractionEvent event) async {
    await event.acknowledge(hidden: true);

    if (!(await checkForMod(event))) {
      await event.interaction.userAuthor
          ?.sendMessage(MessageBuilder.embed(errorEmbed(
        'You do not have the permissions to use this button!',
        event.interaction.userAuthor,
      )));
      return;
    }

    roleMap.remove(event.interaction.message!.id.id);
    await event.interaction.message?.delete();
  }

  Future<void> deleteRoleSlashCommand(
      SlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final role = event.interaction.resolved?.roles.first;

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
