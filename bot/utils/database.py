import discord
from typing import Optional


class Database:
    @staticmethod
    async def get_textchannel_id(bot, guild: discord.Guild) -> Optional[discord.TextChannel]:
        async with bot.asyncpg_pool.acquire() as pool:
            try:
                id_tuple = await pool.fetchrow(
                    "SELECT tc FROM audit WHERE guild=$1", guild.id
                )
                return discord.utils.get(guild.channels, id=id_tuple[0])
            except Exception:
                return None
