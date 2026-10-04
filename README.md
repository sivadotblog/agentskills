# agentskills

Agent skills and plugins by [sivadotblog](https://github.com/sivadotblog). Install them in Claude Code today. Support for other tools is coming.

## Plugins

| Plugin | What it does |
|---|---|
| [sop-kit](plugins/sop-kit) | Walks people through SOPs and runbooks one step at a time, and turns docs into SOPs. |

See it end to end: [demo — drafting a runbook, turning it into an SOP, and running it](docs/sop-kit/demo-github-ssh-signing/) (real transcript included).

## Install (Claude Code)

Add this marketplace once:
```
/plugin marketplace add sivadotblog/agentskills
```

Then install any plugin from it:
```
/plugin install sop-kit@sivadotblog
```

To get new plugins and updates:
```
/plugin marketplace update sivadotblog
```

## Uninstall
```
/plugin uninstall sop-kit@sivadotblog
/plugin marketplace remove sivadotblog   # optional: removes the marketplace too
```

## Other tools
Every skill is a standard `SKILL.md` folder (`plugins/<plugin>/skills/<skill>/`). Install steps for Cursor, GitHub Copilot, and others are coming.

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md).

## License
[MIT](LICENSE)
