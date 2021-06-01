import bot.client as bot
from dislash.slash_commands import SlashClient


if __name__ == "__main__":
    bot = bot.Bot()
    slash = SlashClient(
        client=bot
    ).overwrite_global_commands(slash_commands=["warn"])
    try:
        bot.run()
    except KeyboardInterrupt:
        bot.close()
