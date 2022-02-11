# Obsidian

Obsidian is a multipurpose discord bot made using the nyxx discord API wrapper in the dart language.

## Features

1) Moderation
2) Fun
3) Utilities

**Read TODO.md for a list of commands and the completeness of each.**

## Dev Installation

- Normal installation
  - Downloading the repository

      - Open your terminal and run the following:

          ```shell
          $ git clone https://github.com/dhzdhd/Obsidian.git
          $ cd Obsidian
          ```

  - Make a `.env` in the working directory as per `.env-example`

  - (Optional) Install and run Lavalink server for music

    - Install latest Java JDK

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

- With docker
  - Download the repository as given in step 1 in the above section.
  - Make a .env file as per step 2
  - Install `docker` and `docker-compose`
  - Run docker-compose to build and run.

    ```shell
    $ docker-compose -f docker-compose.yml up --build -d
    ```

## Self Hosting
You can self host the bot easily using docker

- Install docker and docker-compose from [docker website](https://www.docker.com/products/docker-desktop) for Windows/MacOS and from your preferred package manager in Linux.
- Download the `docker-compose-host.yml` file.
- Make an `.env` file and populate as given in `.env-example`
- Run the bot and music server `docker-compose -f docker-compose-host.yml up`
- Add a `-d` flag to the above command to run it in the detached mode (No logs).

## Contributing

**Note:** If you want to contribute you can open a new issue. The issue should be discussed and accepted before you start working on the issue. Do not open a pull request if you aren't assigned to the issue.

1. Create a new branch using `git checkout -b <name of new local branch> master`. Make sure the branch name is related to the feature or fix you are working for.

2. Don't forget to write [good commits](https://cbea.ms/git-commit/). Please try to avoid making minor commits.

3. Lint and format your code properly and push the changes using `git push -u origin <name of new remote branch>`.
