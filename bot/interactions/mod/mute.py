import asyncio
import datetime

import discord
from discord.ext import commands

from bot.utils.constants import Colours
from bot.utils.embed import ErrorEmbed


class MuteUnmute(commands.Cog):
    """
    MuteUnmute cog, containing commands related to the mutes and unmutes in text and voice channels.

    Commands
        ├ mute          Mute a given user given the id/name/mention of the user for a given amount of time
                        specified in the command which takes a default of 5 minutes, along with a reason
        └ unmute        ...
    """

    def __init__(self, bot: commands.Bot) -> None:
        self.bot = bot

    @staticmethod
    async def _manage_role(ctx: commands.Context, user: discord.Member) -> discord.Role:
        role: discord.Role = discord.utils.get(ctx.guild.roles, name="Muted")

        if not role:
            role = await ctx.guild.create_role(
                name="Muted",
                permissions=discord.Permissions(send_messages=False),
                colour=discord.Colour.red(),
                reason="A mute role"
            )

        return role

    @commands.command(name="mute")
    @commands.has_permissions(manage_guild=True)
    async def mute(self, ctx: commands.Context, user: discord.Member, time: int = 5, *, reason: str) -> None:
        """Mutes a user for a specified amount of time (defaulted to 5 minutes)"""
        await ctx.message.delete()

        role = await self._manage_role(ctx, user)

        mute_embed = discord.Embed(
            title=f"Muted user: **{user.display_name}**",
            colour=Colours.AUDIT_COLORS["mod"],
            description=f"Time: **{time} minutes**\n\nReason: \n*{reason}*",
            timestamp=datetime.datetime.utcnow(),
        ).set_footer(text=f"Invoked by {ctx.author.name}", icon_url=ctx.author.avatar_url)

        unmute_embed = discord.Embed(
            title=f"Unmuted user: **{user.display_name}**",
            colour=Colours.AUDIT_COLORS["mod"],
            description=f"The mute duration of {time} minutes has ended.",
            timestamp=datetime.datetime.utcnow(),
        ).set_footer(text=f"Invoked by {ctx.author.name}", icon_url=ctx.author.avatar_url)

        perms_embed = discord.Embed(
            title=f"Unmuted user: **{user.display_name}**",
            colour=Colours.AUDIT_COLORS["mod"],
            description=f"The mute duration of {time} minutes has ended.",
            timestamp=datetime.datetime.utcnow(),
        ).set_footer(text=f"Invoked by {ctx.author.name}", icon_url=ctx.author.avatar_url)

        async with self.bot.asyncpg_pool.acquire() as pool:
            result = await pool.fetchrow("SELECT mutes FROM mod WHERE id=$1 AND guild=$2", user.id, user.guild.id)

            if not result:
                await pool.execute(
                    "INSERT INTO mod(id, name, guild, mutes) VALUES($1, $2, $3, $4)",
                    user.id,
                    user.display_name,
                    user.guild.id,
                    1
                )
            else:
                await pool.execute(
                    "UPDATE mod SET mutes=$1 WHERE id=$2 AND guild=$3",
                    int(result["mutes"]) + 1,
                    user.id,
                    user.guild.id
                )

        await ctx.send(embed=mute_embed, delete_after=60)

        await user.add_roles(role)
        await asyncio.sleep(time*60)
        await user.remove_roles(role)

        await ctx.send(embed=unmute_embed, delete_after=60)

    @commands.command(name="unmute")
    @commands.has_permissions(manage_guild=True)
    async def unmute(self, ctx: commands.Context, user: discord.Member) -> None:
        unmute_embed = discord.Embed(
            title=f"Unmuted user: **{user.display_name}**",
            colour=Colours.AUDIT_COLORS["mod"],
            description=f"The mute has been lifted.",
            timestamp=datetime.datetime.utcnow(),
        ).set_footer(text=f"Invoked by {ctx.author.name}", icon_url=ctx.author.avatar_url)
        error_embed = ErrorEmbed(
            "User is not muted!",
            ctx.author
        )

        await ctx.message.delete()
        muted_role = discord.utils.get(ctx.guild.roles, name="Muted")

        if muted_role in user.roles:
            await user.remove_roles(muted_role)
            await ctx.send(embed=unmute_embed, delete_after=15)
        else:
            await ctx.send(embed=error_embed, delete_after=15)


def setup(bot: commands.Bot) -> None:
    """Load the MuteUnmute cog."""
    bot.add_cog(MuteUnmute(bot))
