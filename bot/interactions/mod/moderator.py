import datetime

import discord
from discord.ext import commands
from dislash import slash_commands, Option, Type
from dislash.interactions import SlashInteraction

from bot.utils.constants import Colours
from bot.utils.embed import SuccessEmbed


class Moderator(commands.Cog):
    """
    Moderator cog, containing commands related to the moderation.

    Commands
        ├ mute          Mute a given user given the id/name/mention of the user for a given amount of time
                        specified in the command which takes a default of 5 minutes, along with a reason
        └ chat          Fetch the response of the Wolfram AI based on the given question/statement.
    """

    def __init__(self, bot: commands.Bot) -> None:
        self.bot = bot

    @slash_commands.command(
        name="warn",
        description="Warn a user",
        options=[
            Option("user", "A user id/name/mention", Type.USER, required=True),
            Option("reason", "Reason for warn", Type.STRING, required=True)
        ]
    )
    @slash_commands.has_permissions(manage_guild=True)
    async def warn(self, ctx: SlashInteraction) -> None:
        """Warns a user and stores the warn count in the database."""
        user = ctx.get("user")
        reason = ctx.get("reason")

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

        await ctx.reply(embed=embed)

    @slash_commands.command(
        name="purge",
        description="Delete certain amount of messages",
        options=[
            Option("amount", "Number of messages to be deleted", Type.INTEGER, required=True)
        ]
    )
    @slash_commands.has_permissions(manage_guild=True)
    async def clear_messages(self, ctx: SlashInteraction) -> None:
        """Deletes given number of messages."""
        amount = ctx.get("amount")

        await ctx.channel.purge(limit=amount)
        return

    @slash_commands.command(
        name="slowmode",
        description="Set channel slow mode",
        options=[
            Option("time", "Slow mode delay amount in seconds", Type.INTEGER, required=False)
        ]
    )
    @slash_commands.has_permissions(manage_guild=True)
    async def slow_mode(self, ctx: SlashInteraction) -> None:
        time = ctx.get("time")
        await ctx.channel.edit(slowmode_delay=time)

        embed = SuccessEmbed(
            description=f"Set channel slowmode to {time} seconds.",
            author=ctx.author
        )
        await ctx.reply(embed=embed, delete_after=20)


def setup(bot: commands.Bot) -> None:
    """Load the Moderator cog."""
    bot.add_cog(Moderator(bot))
