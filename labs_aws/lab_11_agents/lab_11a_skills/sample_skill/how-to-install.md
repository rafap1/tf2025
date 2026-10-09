# How to install the `corporate-projects-terraform` skill

The skill is the whole `corporate-projects-terraform/` folder (`SKILL.md` plus `assets/`). Always copy the folder, not just `SKILL.md`, because the skill points to the skeleton files under `assets/`.

## Claude Code

Claude Code loads skills from a `skills` directory and picks them up automatically.

**Personal (all projects):**

```bash
mkdir -p ~/.claude/skills
cp -r corporate-projects-terraform ~/.claude/skills/
```

**Project (shared with the team via git):**

```bash
mkdir -p .claude/skills
cp -r corporate-projects-terraform .claude/skills/
```

Restart Claude Code so the new skill is picked up:

- **Terminal:** type `/exit` (or press Ctrl+C twice), then run `claude` again. Use `claude --continue` to resume your last conversation, or `claude --resume` to pick an earlier one.
- **VS Code extension:** start a new conversation. If that doesn't work, run "Developer: Reload Window" from the command palette.

Verify by asking "what terraform skills can you see?", or by typing `/corporate-projects-terraform`.

## GitHub Copilot

Copilot supports Agent Skills in VS Code (agent mode), Copilot CLI and the Copilot coding agent. It uses the same folder format.

**Project (shared with the team via git):**

```bash
mkdir -p .github/skills
cp -r corporate-projects-terraform .github/skills/
```

**Personal (all projects):**

```bash
mkdir -p ~/.copilot/skills
cp -r corporate-projects-terraform ~/.copilot/skills/
```

Copilot also reads `.claude/skills/`, so a project that already has the skill there needs no second copy.

Reload VS Code. In Copilot Chat, use agent mode. The skill loads automatically when the request matches its `description`.

> Skills support in Copilot is still evolving. If the skills directory is not recognised in your version, check the current Copilot docs for the supported paths, or enable the agent skills setting in VS Code.

## Notes

- Keep `SKILL.md` and `assets/` together in the same folder.
- The skill is meant to be used alongside the general `terraform-skill`. On style and layout, this one takes precedence.
- Update the skill by re-copying the folder over the installed copy.
