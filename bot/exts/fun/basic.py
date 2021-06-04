import discord
from discord.ext import commands


class BasicCommands(commands.Cog):
    def __init__(self, bot: commands.Bot) -> None:
        self.bot = bot

    @commands.command(name="avatar", aliases=("av",))
    async def user_avatar(self, ctx: commands.Context, user: discord.Member = None) -> None:
        await ctx.message.delete()

        if user is not None:
            await ctx.send(user.avatar_url, delete_after=30)
            return
        await ctx.send(ctx.author.avatar_url, delete_after=30)

    @commands.command(name="ping")
    async def latency(self, ctx: commands.Context) -> None:
        await ctx.message.delete()

        await ctx.send(f"Pong! : **{round(self.bot.latency*1000)} ms**", delete_after=10)


def setup(bot: commands.Bot) -> None:
    bot.add_cog(BasicCommands(bot))
