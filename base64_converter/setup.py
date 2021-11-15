import base64
from dotenv import load_dotenv
from os import getenv


class Converter:
    ENV_LIST = [
        "BOT_OWNER",
        "BOT_TOKEN",
        "BOT_ID",
        "SUPABASE_URL",
        "SUPABASE_KEY",
        "WA_ID",
        "YT_KEY",
        "MOVIE_API_KEY",
    ]

    def __init__(self) -> None:
        self.env_list: list[str] = []
        self.encoded_list: list[str] = []

        load_dotenv("../.env")
        self.read_env()
        self.convert()

    def read_env(self) -> None:
        self.env_list = list(map(lambda x: getenv(x), Converter.ENV_LIST))

    def convert(self) -> None:
        self.encoded_list = [
            base64.b64encode(_.encode('utf-8')).decode() for _ in self.env_list
        ]
        print(self.encoded_list)
