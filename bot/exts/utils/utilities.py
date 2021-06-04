import discord
from discord.ext import commands


class Utilities(commands.Cog):
    def __init__(self, bot: commands.Bot) -> None:
        self.bot = bot

    @commands.command(name="say")
    @commands.has_permissions(manage_guild=True)
    async def say_message(
            self,
            ctx: commands.Context,
            channel: discord.TextChannel,
            *,
            message: str
    ) -> None:
        await ctx.message.delete()

        await channel.send(message)


def setup(bot: commands.Bot) -> None:
    bot.add_cog(Utilities(bot))
