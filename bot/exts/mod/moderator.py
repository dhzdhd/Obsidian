import datetime

import discord
from discord.ext import commands

from bot.utils.constants import Colours
from bot.utils.embed import SuccessEmbed


class Moderator(commands.Cog):
    """
    Moderator cog, containing commands related to the moderation.

    Commands
        ├ warn          ...
        └ chat          ...
    """

    def __init__(self, bot: commands.Bot) -> None:
        self.bot = bot

    @commands.command(name="warn")
    @commands.has_permissions(manage_guild=True)
    async def warn(self, ctx: commands.Context, user: discord.Member, *, reason: str) -> None:
        """Warns a user and stores the warn count in the database."""
        await ctx.message.delete()

        embed = discord.Embed(
            title=f"Warned user: **{user.display_name}**",
            colour=Colours.AUDIT_COLORS["mod"],
            description=f"Reason: \n*{reason}*",
            timestamp=datetime.datetime.utcnow(),
        ).set_footer(text=f"Invoked by {ctx.author.name}", icon_url=ctx.author.avatar_url)

        async with self.bot.asyncpg_pool.acquire() as pool:
            result = await pool.fetchrow("SELECT warns FROM mod WHERE id=$1 AND guild=$2", user.id, user.guild.id)

            if not result:
                await pool.execute(
                    "INSERT INTO mod VALUES($1, $2, $3, $4)",
                    user.id,
                    user.display_name,
                    user.guild.id,
                    1
                )
            else:
                await pool.execute(
                    "UPDATE mod SET warns=$1 WHERE id=$2 AND guild=$3",
                    int(result["warns"]) + 1,
                    user.id,
                    user.guild.id
                )

        await ctx.send(embed=embed)

    @commands.command(name="purge")
    @commands.has_permissions(manage_guild=True)
    async def clear_messages(self, ctx: commands.Context, amount: int) -> None:
        """Deletes given number of messages."""
        await ctx.channel.purge(limit=amount)

    @commands.command(name="slowmode", aliases=("sm",))
    @commands.has_permissions(manage_guild=True)
    async def slow_mode(self, ctx: commands.Context, time: int = 0) -> None:
        await ctx.message.delete()
        await ctx.channel.edit(slowmode_delay=time)

        embed = SuccessEmbed(
            description=f"Set channel slowmode to {time} seconds.",
            author=ctx.author
        )
        await ctx.send(embed=embed, delete_after=20)


def setup(bot: commands.Bot) -> None:
    """Load the Moderator cog."""
    bot.add_cog(Moderator(bot))
