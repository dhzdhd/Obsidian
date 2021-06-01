import random
from typing import Optional

from discord import Embed
from dislash import slash_commands
from dislash import Option, Type
from discord.ext import commands
from yarl import URL

from bot.utils.constants import Names, Tokens

IMAGE_PARAMS = {
    "appid": Tokens.WOLFRAM_ID,
    "background": "2F3136",
    "foreground": "white",
    "layout": "labelbar",
    "fontsize": "23",
    "width": "700",
}


class WolframInteractions(commands.Cog):
    """
    Wolfram Category cog, containing interactions related to the WolframAlpha API.

    Commands
        ├ image         Fetch the response to a query in the form of an image.
        ├ text          Fetch the response to a query in a short phrase.
        └ chat          Fetch the response of the Wolfram AI based on the given question/statement.
    """

    def __init__(self, bot: commands.Bot) -> None:
        self.bot = bot
        self.image_url = "http://api.wolframalpha.com/v1/simple"

    # async def web_request(self, url: str, params: dict) -> Optional[URL, str]:
    #     """Web request handler for wolfram group of commands."""
    #     async with self.bot.http_session.get(url=url, params=params) as resp:
    #         if resp.status == 200:
    #             return resp.url
    #         elif resp.status == 501:
    #             return "Sorry, the API could not understand your input"
    #         elif resp.status == 400:
    #             return "Sorry, the API did not find any input to interpret"
    #
    # @slash_commands.command(
    #     description="Wolfram command.",
    #     options=[
    #         Option(
    #             "image",
    #             "Sends an image based on query",
    #             Type.SUB_COMMAND
    #         )
    #     ]
    # )
    # async def wolfram_group(self, ctx: commands.Context) -> None:
    #     """Commands for wolfram."""
    #     ...
    #
    # @command(name="image", aliases=("i", "im"))
    # async def wolfram_image(self, ctx: commands.Context, *, query: str) -> None:
    #     """Sends wolfram image corresponding to the given query."""
    #     await ctx.message.delete()
    #     IMAGE_PARAMS["i"] = query
    #
    #     async with ctx.typing():
    #         response = await self.web_request(url=self.image_url, params=IMAGE_PARAMS)
    #
    #         if isinstance(response, str):
    #             embed = Embed(
    #                 title=random.choice(Names.ERROR_LIST), description=response
    #             )
    #         else:
    #             embed = Embed(title=f"Query: {query}")
    #             embed.set_image(url=response)
    #             embed.add_field(
    #                 name="Cannot see image?",
    #                 value=f"[Click here](https://www.wolframalpha.com/input/?i={query.replace(' ', '+')})",
    #             )
    #         await ctx.send(embed=embed)


def setup(bot: commands.Bot) -> None:
    """Load the Wolfram cog."""
    bot.add_cog(WolframInteractions(bot))

