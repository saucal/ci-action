# saucal-ci-action

To use add a GH actions workflow file, for example:

```
.github/workflows/cibot.yml
```

With the contents:

```
name: Run CI Bot
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
          repository_owner: ${{ github.repository_owner }}
          repository_name: ${{ github.event.repository.name }}
          bot_token: ${{ secrets.CI_BOT_TOKEN }}
          pr_head_sha: ${{ github.event.pull_request.head.sha }}
          phpcs_enabled: true
          linting_enabled: true
```