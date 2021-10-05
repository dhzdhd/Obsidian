# Obsidian

Obsidian is a multipurpose discord bot made using the nyxx discord API wrapper in the dart language.

## Features

1) Moderation
2) Fun
3) Utilities

## Dev Installation

- Downloading the repository

    - Open your terminal and run the following:

        ```shell
        $ git clone https://github.com/dhzdhd/Obsidian.git
        $ cd Obsidian
        ```

- (Optional) Install and run Lavalink server for music

  - Install [Java JDK 13](https://www.oracle.com/java/technologies/javase/jdk13-archive-downloads.html). JDK 11 or 14 are also fine but they have bugs with lavalink. A minimum of JDK 11 is required.

  - Add java-JDK-13 to PATH environment variable as JAVA_HOME

  - Change the directory to `lavalink_server` and run the `Lavalink.jar` file

    ```shell
    $ cd lavalink_server
    $ java -jar Lavalink.jar
    ```

- Running the bot

  - Open a new terminal window/tab.

  - Install [Dart](https://dart.dev/get-dart) and necessary plugins for your editor. Make sure you are running the latest version of dart.

  - Run the following:

    ```shell
    $ cd Obsidian   # If you are not already in the directory
    $ dart pub upgrade
    $ dart pub get
    ```

  - Run the bot:

    ```shell
    $ dart run
    ```

## Contributing

...
