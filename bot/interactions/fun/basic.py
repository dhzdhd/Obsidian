import random

from discord.ext import commands
from dislash import Option, Type
from dislash import slash_commands
from dislash.interactions import SlashInteraction


class BasicCommands(commands.Cog):
    def __init__(self, bot: commands.Bot) -> None:
        self.bot = bot

    @slash_commands.command(
        name="avatar",
        description="Shows user avatar",
        options=[
            Option("user", "The server member", Type.USER, required=False)
        ]
    )
    async def user_avatar(self, ctx: SlashInteraction) -> None:
        user = ctx.get("user")

        if user is not None:
            await ctx.reply(user.avatar_url, delete_after=30)
            return
        await ctx.reply(ctx.author.avatar_url, delete_after=30)

    @slash_commands.command(
        name="ping",
        description="Shows bot latency",
    )
    async def latency(self, ctx: SlashInteraction) -> None:
        await ctx.reply(f"Pong! : **{round(self.bot.latency*1000)} ms**", delete_after=10)

    @slash_commands.command(name="flip", description="Flip a coin")
    async def flip_a_coin(self, ctx: SlashInteraction) -> None:
        await ctx.reply(random.choice(["Heads!", "Tails!"]))

    @slash_commands.command(name="roll", description="Roll a die")
    async def roll_a_die(self, ctx: SlashInteraction) -> None:
        await ctx.reply(f"You got a **{random.randint(1, 6)}**")


def setup(bot: commands.Bot) -> None:
    bot.add_cog(BasicCommands(bot))
