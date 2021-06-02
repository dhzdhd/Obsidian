import datetime
from typing import Tuple, Union

from discord import Embed
from discord.ext import commands
from yarl import URL

from bot.utils.constants import Names, Tokens
from bot.utils.embed import ErrorEmbed

IMAGE_PARAMS = {
    "appid": Tokens.WOLFRAM_ID,
    "background": "2F3136",
    "foreground": "white",
    "layout": "labelbar",
    "fontsize": "23",
    "width": "700",
}

SHORT_PARAMS = {"appid": Tokens.WOLFRAM_ID}


class WolframCommands(commands.Cog):
    """
    Wolfram Category cog, containing commands related to the WolframAlpha API.

    Commands
        └ wolfram / wa
            ├ image         Fetch the response to a query in the form of an image.
            └ text          Fetch the response to a query in a short phrase.
    """

    def __init__(self, bot: commands.Bot) -> None:
        self.bot = bot
        self.image_url = "http://api.wolframalpha.com/v1/simple"
        self.short_url = "http://api.wolframalpha.com/v1/result"

    async def web_request(self, url: str, params: dict) -> Tuple[Union[URL, str, dict], int]:
        """Web request handler for wolfram group of commands."""
        async with self.bot.http_session.get(url=url, params=params) as resp:
            if resp.status == 200:
                try:
                    return await resp.text(), resp.status
                except Exception:
                    return resp.url, resp.status
            elif resp.status == 501:
                return "Sorry, the API could not understand your input", resp.status
            elif resp.status == 400:
                return "Sorry, the API did not find any input to interpret", resp.status

    @commands.group(name="wolfram", aliases=("wa",), invoke_without_command=True)
    async def wolfram_group(self, ctx: commands.Context) -> None:
        """Commands for wolfram."""
        await ctx.send_help(ctx.command)

    @wolfram_group.command(name="image", aliases=("i", "im"))
    async def wolfram_image(self, ctx: commands.Context, *, query: str) -> None:
        """Sends wolfram image corresponding to the given query."""
        await ctx.message.delete()
        IMAGE_PARAMS["i"] = query

        async with ctx.typing():
            response = await self.web_request(url=self.image_url, params=IMAGE_PARAMS)

            if isinstance(response[0], str):
                embed = ErrorEmbed(
                    description=response[0], author=ctx.author
                )
            else:
                embed = Embed(
                    title=f"Query: {query}",
                    timestamp=datetime.datetime.utcnow()
                ).set_footer(text=f"Invoked by {ctx.author.name}", icon_url=ctx.author.avatar_url)

                embed.set_image(url=response[0])
                embed.add_field(
                    name="Cannot see image?",
                    value=f"[Click here](https://www.wolframalpha.com/input/?i={query.replace(' ', '+')})",
                )
            await ctx.send(embed=embed, delete_after=60)

    @wolfram_group.command(name="short", aliases=("s", "sh"))
    async def wolfram_short(self, ctx: commands.Context, *, query: str) -> None:
        """Sends wolfram image corresponding to the given query."""
        await ctx.message.delete()
        SHORT_PARAMS["i"] = query

        async with ctx.typing():
            response = await self.web_request(url=self.short_url, params=SHORT_PARAMS)

            if response[1] in [400, 501]:
                embed = ErrorEmbed(
                    description=response[0], author=ctx.author
                )
            else:
                embed = Embed(
                    title=f"Query: {query}",
                    description=f"[**{response[0]}**](https://www.wolframalpha.com/input/?i={query.replace(' ', '+')})",
                    timestamp=datetime.datetime.utcnow()
                ).set_footer(text=f"Invoked by {ctx.author.name}", icon_url=ctx.author.avatar_url)

            await ctx.send(embed=embed, delete_after=60)


def setup(bot: commands.Bot) -> None:
    """Load the Wolfram cog."""
    bot.add_cog(WolframCommands(bot))


# Add function to hide the token
