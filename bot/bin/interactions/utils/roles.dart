import 'package:nyxx/nyxx.dart';
import 'package:nyxx_interactions/nyxx_interactions.dart';

import '../../obsidian_dart.dart';
import '../../utils/constraints.dart';
import '../../utils/embed.dart';

class UtilsRolesInteractions {
  Map<int, IRole?> roleMap = {};
  Map<int, List> embedRolesMap = {};

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
                CommandOptionType.role,
                'role',
                'Name of the role.',
                required: true,
              )
            ],
          )..registerHandler(addToRoleSlashCommand),
          CommandOptionBuilder(
            CommandOptionType.subCommand,
            'delete',
            '<MOD ONLY> Delete a role.',
            options: [
              CommandOptionBuilder(
                CommandOptionType.role,
                'role',
                'Name of role.',
                required: true,
              )
            ],
          )..registerHandler(deleteRoleSlashCommand)
        ],
      ))
      ..registerButtonHandler('role-add-button', addRoleButtonHandler)
      ..registerButtonHandler('role-remove-button', removeRoleButtonHandler)
      ..registerButtonHandler('role-cancel-button', cancelButtonHandler);
  }

  Future<void> addToRoleSlashCommand(
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final role = event.interaction.resolved!.roles.first;

    if (!(await checkForMod(event))) {
      await deleteMessageWithTimer(
        message: await event.sendFollowup(MessageBuilder.embed(
          errorEmbed('Permission Denied!', event.interaction.userAuthor),
        )),
      );
      return;
    }

    final embed = EmbedBuilder()
      ..title = 'Add the role to yourself | ${role.name}'
      ..color = DiscordColor.aquamarine
      ..timestamp = DateTime.now()
      ..addFooter((footer) {
        footer.text = 'Requested by ${event.interaction.userAuthor?.username}';
        footer.iconUrl = event.interaction.userAuthor?.avatarURL();
      });

    final message = await event.sendFollowup(MessageBuilder.embed(embed));

    final componentMessageBuilder = ComponentMessageBuilder();
    final componentRow = ComponentRowBuilder()
      ..addComponent(
          ButtonBuilder('Add role', 'role-add-button', ButtonStyle.primary))
      ..addComponent(ButtonBuilder(
          'Remove role', 'role-remove-button', ButtonStyle.secondary))
      ..addComponent(
          ButtonBuilder('Delete', 'role-cancel-button', ButtonStyle.danger));
    componentMessageBuilder.addComponentRow(componentRow);

    await event.respond(componentMessageBuilder);

    roleMap[message.id.id] = role;
    embedRolesMap[message.id.id] = <void>[];
  }

  Future<void> addRoleButtonHandler(IButtonInteractionEvent event) async {
    await event.acknowledge(hidden: true);

    final messageId = event.interaction.message!.id.id;
    final role = roleMap[messageId];

    // ! Sort out Cacheable matching
    if (event.interaction.memberAuthor!.roles.contains(role?.id)) {
      await event.interaction.userAuthor?.sendMessage(
        MessageBuilder.content('You already have the role - ${role?.name}!'),
      );
      return;
    }

    await event.interaction.memberAuthor?.addRole(SnowflakeEntity(role!.id));

    // var oldField = embed.fields.first;

    embedRolesMap[messageId]!.add(event.interaction.userAuthor?.mention);

    final content = StringBuffer();
    for (var element in embedRolesMap[messageId]!) {
      content.write('$element');
    }

    // await event.editOriginalResponse(
    //   MessageBuilder.embed(
    //     embed..replaceField(name: oldField.name, content: content.toString()),
    //   ),
    // );

    await event.interaction.userAuthor?.sendMessage(
      MessageBuilder.embed(successEmbed(
          'Added role - ${role?.name} to you!', event.interaction.userAuthor)),
    );
  }

  Future<void> removeRoleButtonHandler(IButtonInteractionEvent event) async {
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

    // var oldField = embed.fields.first;
    // print(oldField);

    embedRolesMap[messageId]!.remove(event.interaction.userAuthor?.mention);

    final content = StringBuffer();
    for (var element in embedRolesMap[messageId]!) {
      content.write('$element');
    }

    // await event.editOriginalResponse(
    //   MessageBuilder.embed(
    //     embed..replaceField(name: oldField.name, content: content.toString()),
    //   ),
    // );

    await event.interaction.userAuthor?.sendMessage(
      MessageBuilder.embed(successEmbed(
          'Removed role - ${role?.name} from you!',
          event.interaction.userAuthor)),
    );
  }

  Future<void> cancelButtonHandler(IButtonInteractionEvent event) async {
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
      ISlashCommandInteractionEvent event) async {
    await event.acknowledge();
    final role = event.interaction.resolved?.roles.first;

    if (!(await checkForMod(event))) {
      await event.respond(MessageBuilder.embed(
        errorEmbed('Permission Denied!', event.interaction.userAuthor),
      ));
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
