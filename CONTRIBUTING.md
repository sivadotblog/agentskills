# Adding a plugin

Each plugin lives in its own folder under `plugins/`. It can hold one skill or several skills, agents, and commands.

1. Create the folder:
   ```
   plugins/<name>/.claude-plugin/plugin.json
   plugins/<name>/skills/<skill-name>/SKILL.md
   plugins/<name>/README.md
   ```
   Optional: `agents/`, `commands/`, `hooks/`.
2. Add an entry to `.claude-plugin/marketplace.json`:
   ```json
   { "name": "<name>", "source": "./plugins/<name>", "description": "...", "version": "0.1.0" }
   ```
3. Add a row to the plugin table in `README.md`.
4. Validate:
   ```
   claude plugin validate .
   claude plugin validate plugins/<name>
   ```
5. Test locally:
   ```
   claude plugin marketplace add ./
   claude plugin install <name>@sivadotblog
   # try it, then
   claude plugin uninstall <name>@sivadotblog
   claude plugin marketplace remove sivadotblog
   ```

Group skills that are always used together into one plugin. Anything someone might want on its own gets its own plugin.

When you change a plugin, bump its version in both `plugin.json` and `marketplace.json`.
