const fs = require('fs');
const showdown = require('showdown');

const converter = new showdown.Converter({ metadata: true });

fs.readFile('dist/pages/docs.md', (_, data) => {
    const html = converter.makeHtml(data.toString());

    let boilerplate = `<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Obsidian Documentation</title>
    <link rel="stylesheet" href="./css/docs.css">
</head>
<body>
    <main>
${html}
    </main>
</body>
</html>`;

    fs.writeFile('dist/pages/docs.html', boilerplate, (_) => {});
});
