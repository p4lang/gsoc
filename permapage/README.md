# P4 GSoC Permapage

P4 Google Summer of Code (GSoC) permapages are Markdown pages with stable permalinks for successfully completed P4 GSoC projects.

## Rationale

For GSoC's official archive, a project link must be provided upon completion of each project. This link cannot be updated once submitted. This could be a problem if the provided project link has to change for some reason. For example, in P4 GSoC 2024, we asked our contributors to provide a link to their project report in this repo. But later in 2026, we wanted to change our directory structure. That change would break those submitted project links.

Permapage is our solution to this problem. We use permapages as a layer of indirection. We keep the permalinks absolutely stable and submit them to the GSoC archive. The actual project links on the permapages can then be freely updated without breaking the archive. As a bonus, multiple project links can be provided instead of just one. 

## Key design decisions

1. **Minimal dependency.** We want the permalinks to be stable as long as possible, so we want as few dependencies as possible. Our decision is to write plain Markdown files in this GitHub repo, with stable file paths. No wiki pages, no separate website — the GitHub repo itself is enough.
2. **Intentional isolation.** We created a `permapage/` directory dedicated to hosting permapages to make the boundary clear that files within this directory should have absolutely stable paths. This means we can freely reorganize things outside of this directory.

## Rules

1. Each successfully completed P4 GSoC project gets assigned a unique project slug in this format: `{year}-{lowercase-project-name}`.
   - Example: `2024-container-migration`
2. That project's permapage is `{year}-{lowercase-project-name}.md` under this directory.
   - Example: [2024-container-migration.md](2024-container-migration.md)
3. The corresponding permalink becomes https://github.com/p4lang/gsoc/blob/main/permapage/{year}-{lowercase-project-name}.md.
   - Example: https://github.com/p4lang/gsoc/blob/main/permapage/2024-container-migration.md
