from dataclasses import dataclass
from os import getenv

from discord import Colour
from dotenv import load_dotenv


@dataclass
class Colours:
    """Colors for each embed type."""

    AUDIT_COLORS = {
        "mod": Colour.from_rgb(224, 108, 117),
        "msg_delete": Colour.from_rgb(198, 120, 221),
        "msg_edit": Colour.from_rgb(97, 175, 239),
        "say_cmd": Colour.from_rgb(26, 179, 246),
    }


@dataclass
class Emojis:
    """Cool custom emojis for the bot."""

    RIGHT = "➡️"
    LEFT = "⬅️"
    X = ":x:"
    CANCEL = "<:redTick:596576672149667840>"
    TICK = "<:tick:822469654710190080>"
    BLOBPAT = "<:blobpats:596576796594667521>"
    BLOBSTOP = "<:blobstop:749111017778184302>"
    VERYCOOL = "<:verycool:739613733474795520>"
    ANGRY = "<:angery:822470572855918602>"


@dataclass
class Tokens:
    """Tokens for various services/API's."""

    load_dotenv()

    BOT_TOKEN = getenv("BOT_TOKEN")

    HOST = getenv("POSTGRE_HOST")
    PASSWORD = getenv("POSTGRE_PASSWORD")
    USER = getenv("POSTGRE_USER")
    PORT = getenv("POSTGRE_PORT")
    DSN = getenv("POSTGRE_DSN")
    DATABASE = getenv("POSTGRE_DATABASE")

    WOLFRAM_ID = getenv("WA_ID")


@dataclass
class Names:
    """Titles for embeds."""

    ERROR_LIST = [
        f"{Emojis.ANGRY} {_}"
        for _ in ["Hold on there!", "Umm...", "Uhh, what are you doing..."]
    ]
    SUCCESS_LIST = [f"{Emojis.TICK} {_}" for _ in ["Success!", "Yay!", "Woot!"]]
    AUDIT_EMBED_FOOTER = {
        "mod": "Command invoked by",
        "msg_delete": "Message deleted by",
        "msg_edit": "Message edited by",
        "say_msg": "Command invoked by",
    }
