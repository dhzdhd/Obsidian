import base64
from dotenv import load_dotenv


class Converter:
    def __init__(self) -> None:
        load_dotenv("../.env")

    def read_env(self) -> None:
        ...

    def convert(self) -> None:
        ...
