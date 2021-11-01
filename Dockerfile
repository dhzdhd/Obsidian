# Specify the Dart SDK base image version using dart:<version>
FROM dart:stable

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code.
COPY . .

# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline

ENTRYPOINT ["dart"]
CMD ["run"]
