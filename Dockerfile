FROM Fedora

RUN dnf update
RUN dnf install dart
RUN dnf install java

COPY . /opt/source

ENTRYPOINT BOT=/opt/source/bin/obsidian_dart.dart dart run