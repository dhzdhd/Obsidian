import asyncio
import os
import ssl
from pathlib import Path

import asyncpg
import discord
from aiohttp import ClientSession
from discord.ext import commands

from utils.constants import Tokens


class Bot(commands.Bot):
    """Obsidian bot initiator."""

    def __init__(self) -> None:
        intents = discord.Intents.all()

        super().__init__(
            command_prefix=commands.when_mentioned_or(">"), intents=intents
        )
        self.load_extensions()

    def load_extensions(self) -> None:
        # Search for .py files in /exts/ and load it.
        for ext in Path("exts/").glob("*/[!_]*.py"):
            path = str(ext).replace(os.sep, ".")[:-3]
            self.load_extension(path)
        for ext in Path("interactions/").glob("*/[!_]*.py"):
            path = str(ext).replace(os.sep, ".")[:-3]
            self.load_extension(path)
        self.load_extension("jishaku")

    def run(self) -> None:
        super().run(Tokens.BOT_TOKEN)

    async def wait_until_ready(self) -> None:
        await super().wait_until_ready()

    async def _init_asyncpg(self) -> None:
        """Create a asyncpg database connection as a bot attribute."""
        ssl_object = ssl.create_default_context(capath=r"MyPath\concat.pem")
        ssl_object.check_hostname = False
        ssl_object.verify_mode = ssl.CERT_NONE

        self.asyncpg_pool = await asyncpg.create_pool(
            host="localhost",
            password="root",
            user="postgres",
            port=5432,
            database="obsidian",
            # ssl=ssl_object,
        )

    def _init_http_session(self) -> None:
        """Create a aiohttp ClientSession bot attribute."""
        self.http_session = ClientSession()

    async def on_ready(self) -> None:
        await asyncio.ensure_future(self._init_asyncpg())
        self._init_http_session()

        print("Bot online")

    async def close(self) -> None:
        await self.asyncpg_pool.close()
        await self.http_session.close()
        await super().close()
