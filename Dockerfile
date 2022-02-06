# Specify the Dart SDK base image version using dart:<version>
FROM dart:2.16.0

# Resolve app dependencies.
COPY pubspec.* ./
RUN dart pub get

# Copy app source code.
COPY . .

# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline

ENTRYPOINT ["dart"]
CMD ["run"]
