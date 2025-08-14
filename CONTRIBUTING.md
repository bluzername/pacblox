# Contributing to PacBlox

First off, thank you for considering contributing to PacBlox! It's people like you that make PacBlox such a great educational tool for the Roblox community.

## Code of Conduct

By participating in this project, you are expected to uphold our Code of Conduct:
- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive criticism
- Accept responsibility and apologize to those affected by mistakes

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When you create a bug report, include:

- **Clear title and description**
- **Steps to reproduce**
- **Expected behavior**
- **Actual behavior**
- **Screenshots if applicable**
- **Roblox Studio version**
- **Device and OS information**

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, include:

- **Clear title and description**
- **Step-by-step description of the enhancement**
- **Explain why this enhancement would be useful**
- **List any similar features in other games**

### Pull Requests

1. Fork the repo and create your branch from `main`
2. Make your changes following our coding standards
3. Test your changes thoroughly
4. Update documentation if needed
5. Submit your pull request

## Development Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/yourusername/pacblox.git
   cd pacblox
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Changes**
   - Edit scripts in your preferred editor
   - Test in Roblox Studio

4. **Commit Changes**
   ```bash
   git add .
   git commit -m "Add: Description of your changes"
   ```

5. **Push to GitHub**
   ```bash
   git push origin feature/your-feature-name
   ```

## Coding Standards

### Lua Style Guide

```lua
-- Use descriptive variable names
local playerScore = 0  -- Good
local ps = 0           -- Bad

-- Constants in UPPER_CASE
local MAX_SPEED = 16
local DEFAULT_LIVES = 3

-- Functions in camelCase
function calculateScore(pellets, multiplier)
    return pellets * multiplier
end

-- Tables/Classes in PascalCase
local PlayerController = {}

-- Use meaningful comments
-- Calculate the ghost's target position based on player movement
function getTargetPosition(player, ghost)
    -- Implementation
end
```

### File Organization

- Server scripts go in `src/server/`
- Client scripts go in `src/client/`
- Keep modules focused on a single responsibility
- Name files clearly based on their function

### Testing Requirements

Before submitting, ensure:
- [ ] Game starts without errors
- [ ] All controls work properly
- [ ] No script errors in output
- [ ] Features work on both PC and mobile
- [ ] Multiplayer functionality intact

## Commit Message Guidelines

Use clear, descriptive commit messages:

- `Add: New feature or file`
- `Fix: Bug fix`
- `Update: Enhancement to existing feature`
- `Remove: Removal of feature or file`
- `Refactor: Code improvement without changing functionality`
- `Docs: Documentation changes`
- `Style: Formatting, missing semicolons, etc.`
- `Test: Adding or updating tests`

Examples:
```
Add: Ghost scatter mode behavior
Fix: Player collision detection with walls
Update: Increase power-up duration to 12 seconds
Docs: Add installation instructions for Mac users
```

## Areas We Need Help

### High Priority
- 🔊 **Sound Implementation**: Adding actual sound effects
- 🎮 **Level Progression**: Multiple maze layouts
- 📊 **Leaderboard System**: Global high scores
- 🎨 **Visual Polish**: Particle effects and animations

### Medium Priority
- 📱 **Mobile Optimization**: Better touch controls
- 🤖 **AI Enhancement**: Smarter ghost behaviors
- 🌍 **Localization**: Multi-language support
- ⚡ **Performance**: Optimization for lower-end devices

### Low Priority
- 🎭 **Customization**: Player skins/themes
- 🏆 **Achievements**: In-game accomplishments
- 💬 **Social Features**: Chat, friends list
- 📈 **Analytics**: Gameplay statistics

## Questions?

Feel free to:
- Open an issue for discussion
- Contact maintainers
- Join our Discord (if available)
- Check existing documentation

## Recognition

Contributors will be:
- Listed in the README
- Credited in release notes
- Given collaborator access (for regular contributors)

Thank you for contributing to PacBlox! 🎮