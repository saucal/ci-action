# saucal-ci-action

To use add a GH actions workflow file, for example:

```
.github/workflows/cibot.yml
```

With the contents:

```
name: Running CI Bot
on:
  pull_request:

jobs:
  build:
    name: Install & run CI Bot
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2
        with:
          ref: ${{ github.event.pull_request.head.ref }}

      - name: SAU/CAL CI Bot
        uses: saucal/ci-action@main
        with:
          bot_token: ${{ secrets.CI_BOT_TOKEN }}
```