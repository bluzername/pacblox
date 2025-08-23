# Sound Assets

This directory contains sound assets for PacBlox. 

## Required Sounds

Replace the placeholder sound IDs in `src/shared/Constants.lua` with actual Roblox asset IDs:

- **pellet_collect.mp3** - Sound when collecting regular pellets
- **power_up.mp3** - Sound when collecting power pellets  
- **ghost_eaten.mp3** - Sound when eating a ghost during power-up
- **player_death.mp3** - Sound when player dies
- **victory.mp3** - Sound when level is completed
- **game_start.mp3** - Sound when game begins
- **ghost_siren.mp3** - Looping ghost chase music

## Recommended Free Sound Sources

### The Motion Monkey - Retro Arcade Sound Pack
- **URL**: https://www.themotionmonkey.co.uk/free-resources/retro-arcade-sounds/
- **License**: CC0 (Public Domain) - No attribution required
- **Format**: 24-bit WAV, OGG, M4A
- **Content**: 300+ original retro arcade sounds
- **Perfect for**: Game developers seeking authentic 16-bit arcade sounds

### Pixabay Sound Effects
- **URL**: https://pixabay.com/sound-effects/search/pac-man/
- **License**: Royalty-free with no attribution required
- **Format**: MP3 downloads
- **Content**: Pac-Man style sound effects

### Sample Focus
- **URL**: https://samplefocus.com/samples/pacman-type-fx
- **License**: Varies by sample (check individual licenses)
- **Content**: Pac-Man type sound effects

## Temporary Assets

Using Roblox's default sounds (ID: 131961136) as placeholders.

## How to Replace

1. Download sounds from recommended sources above
2. Upload your sound files to Roblox as Audio assets
3. Copy the asset ID (format: rbxassetid://XXXXXXXXX)
4. Replace the placeholder IDs in Constants.lua
5. Test in-game to ensure sounds work correctly

## Sound Mapping Suggestions

From The Motion Monkey pack, consider these mappings:
- **pellet_collect** → Use pickup/item collection sounds
- **power_up** → Use power-up/enhancement sounds  
- **ghost_eaten** → Use destruction/defeat sounds
- **player_death** → Use death/fail sounds
- **victory** → Use success/completion sounds
- **game_start** → Use start/begin sounds
- **ghost_siren** → Use ambient/chase sounds (loop enabled)