from discord.ext import commands
from dislash import Option, Type
from dislash import slash_commands
from dislash.interactions import SlashInteraction


class Utilities(commands.Cog):
    def __init__(self, bot: commands.Bot) -> None:
        self.bot = bot

    @slash_commands.command(
        name="say",
        description="Say something through the bot in a certain channel",
        options=[
            Option("channel", "The channel you want to send the message", Type.CHANNEL),
            Option("message", "The message", Type.STRING)
        ]
    )
    @slash_commands.has_permissions(manage_guild=True)
    async def say_message(self, ctx: SlashInteraction) -> None:
        channel = ctx.get("channel")
        message = ctx.get("message")

        await channel.send(message)


def setup(bot: commands.Bot) -> None:
    bot.add_cog(Utilities(bot))
