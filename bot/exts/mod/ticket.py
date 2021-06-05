import discord
from discord.ext import commands
from collections import namedtuple
from bot.utils.embed import ErrorEmbed
import datetime

Struct = namedtuple(
    "TicketStruct",
    [
        "obj"
    ]
)


class TicketCommands(commands.Cog):
    def __init__(self, bot: commands.Bot) -> None:
        self.bot = bot
        self.check_dict = {}

    @commands.group(name="ticket", aliases=("t",), invoke_without_command=True)
    async def ticket_group(self, ctx: commands.Context) -> None:
        await ctx.send_help(ctx.command)

    @ticket_group.command(name="new", aliases=("n", "open", "o"))
    async def ticket_new(self, ctx: commands.Context, user: discord.Member = None) -> None:
        mod_role = discord.utils.get(ctx.guild.roles, permissions=discord.Permissions(manage_guild=True))
        print(mod_role)

        error_embed = ErrorEmbed(
            description="You have a ticket channel open! Close it to make a new one.",
            author=ctx.author
        )
        common_embed = discord.Embed(
            title="Welcome to the ticket channel",
            colour=discord.Colour.dark_green(),
            description="Please wait patiently for the mods/admins to help you.\n"
                        "Use `>ticket close` or the `ticket close` slash command to close the channel.",
            timestamp=datetime.datetime.utcnow()
        ).set_footer(text=f"Invoked by {ctx.author.name}", icon_url=ctx.author.avatar_url)

        await ctx.message.delete()
        if user is not None and ctx.author.guild_permissions.manage_guild is not True:
            embed = ErrorEmbed(
                description="A non moderator/admin cannot create tickets for other users!",
                author=ctx.author
            )
            await ctx.send(embed=embed, delete_after=15)
            return

        if user is None:
            if (ctx.author.id, ctx.guild.id) in self.check_dict.keys():
                await ctx.send(embed=error_embed, delete_after=15)
                return

            permissions = {
                ctx.author: discord.PermissionOverwrite(read_messages=True),
                ctx.guild.default_role: discord.PermissionOverwrite(
                    read_messages=False,
                    send_messages=False
                )
            }

            channel = await ctx.guild.create_text_channel(
                f"help-{ctx.author.name}",
                permissions=permissions
            )
            self.check_dict[(ctx.author.id, ctx.guild.id)] = Struct(
                channel
            )
            await channel.send(f"{ctx.author.mention}", embed=common_embed)

        else:
            if (user.id, ctx.guild.id) in self.check_dict.keys():
                await ctx.send(embed=error_embed, delete_after=15)

            permissions = {
                ctx.author: discord.PermissionOverwrite(read_messages=True),
                user: discord.PermissionOverwrite(read_messages=True),
                ctx.guild.default_role: discord.PermissionOverwrite(
                    read_messages=False,
                    send_messages=False
                )
            }

            channel = await ctx.guild.create_text_channel(
                f"help-{user.name}",
                permissions=permissions
            )
            self.check_dict[(user.id, ctx.guild.id)] = Struct(
                channel
            )
            await channel.send(f"{ctx.author.mention} | {user.mention}", embed=common_embed)

    @ticket_group.command(name="close", aliases=("c",))
    async def close_ticket(self, ctx: commands.Context, user: discord.Member = None) -> None:
        await ctx.message.delete()

        error_embed = ErrorEmbed(
            description=f"You do not have a ticket channel open! Create a new one by `>ticket new`.",
            author=ctx.author
        )

        if user is None:
            check = (ctx.author.id, ctx.guild.id)

            if check not in self.check_dict.keys():
                await ctx.send(embed=error_embed, delete_after=15)
                return

            await self.check_dict[check].obj.delete()
            self.check_dict.pop(check)

        else:
            check = (user.id, ctx.guild.id)

            if check not in self.check_dict.keys():
                await ctx.send(embed=error_embed, delete_after=15)
                return

            await self.check_dict[check].obj.delete()
            self.check_dict.pop(check)


def setup(bot: commands.Bot) -> None:
    bot.add_cog(TicketCommands(bot))
