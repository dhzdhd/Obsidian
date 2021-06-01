import datetime
import random
from typing import Optional

import discord

from bot.utils.constants import Names, Colours


class ErrorEmbed(discord.Embed):
    def __init__(self, description: str, author: discord.Member) -> None:
        super().__init__(
            title=random.choice(Names.ERROR_LIST),
            description=description,
            colour=discord.Colour.red(),
            timestamp=datetime.datetime.utcnow(),
        )
        self.set_footer(text=f"Error made by {author.name}", icon_url=author.avatar_url)


class SuccessEmbed(discord.Embed):
    def __init__(self, description: str, author: discord.Member) -> None:
        super().__init__(
            title=random.choice(Names.SUCCESS_LIST),
            description=description,
            colour=discord.Colour.green(),
            timestamp=datetime.datetime.utcnow(),
        )
        self.set_footer(text=f"Requested by {author.name}", icon_url=author.avatar_url)


class Audit(discord.Embed):
    def __init__(
        self, title: str, description: str, author: discord.Member, _type: str = "mod"
    ) -> None:
        super().__init__(
            title=title,
            description=description,
            colour=Colours.AUDIT_COLORS[_type],
            timestamp=datetime.datetime.utcnow(),
        )
        self.set_footer(
            text=f"{Names.AUDIT_EMBED_FOOTER[_type]} {author.name}",
            icon_url=author.avatar_url,
        )
