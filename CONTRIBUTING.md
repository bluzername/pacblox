# Contributing

1. Fork and branch from `main`.
2. Make the change. Keep modules focused; server code in `src/server/`, client in
   `src/client/`, shared in `src/shared/`.
3. Run `stylua src` and `selene src` (install with `aftman install`). CI runs
   `stylua --check src`, `selene src`, and `rojo build`.
4. Test in Roblox Studio (Play, and Test > Start Server for multiplayer).
5. Open a pull request with a `type: description` title (feat, fix, docs,
   refactor, chore, ci) and a short summary of what changed and how you tested.

Style: descriptive names, `UPPER_CASE` for module constants, `camelCase` for
functions and locals, `PascalCase` for module tables. Comment the why, not the what.

Bug reports: include steps to reproduce, expected and actual behavior, and the
Output window contents from Studio.
