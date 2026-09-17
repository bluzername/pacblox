# Sounds (optional)

No audio files are shipped and the game runs silently by default. Every entry in
`Constants.SOUND_IDS` (`src/shared/Constants.lua`) is an empty string, and
`SoundManager` skips any sound whose id is empty.

To enable a sound:

1. Get or create an audio clip and upload it to Roblox as an Audio asset.
2. Copy the asset id and set it in `Constants.SOUND_IDS`, for example
   `pelletCollect = "rbxassetid://1234567890"`.
3. Play-test in Studio. Sounds you leave empty stay silent.

Keys and when they play:

| Key | Plays when |
|-----|------------|
| `pelletCollect` | Regular pellet collected |
| `powerPelletCollect` | Power pellet collected |
| `ghostEaten` | Ghost eaten during power-up |
| `playerDeath` | Player caught by a ghost |
| `gameStart` | Round starts |
| `victory` | All pellets collected |
| `gameOver` | Game over |
| `backgroundMusic` | Looping, during normal play |
| `powerUpMusic` | Looping, during power-up |
| `movement` | Looping movement sound (defined, not currently triggered) |

Free sound sources:

- [The Motion Monkey retro arcade pack](https://www.themotionmonkey.co.uk/free-resources/retro-arcade-sounds/) (CC0)
- [Pixabay sound effects](https://pixabay.com/sound-effects/) (royalty-free)

Check each source's license before uploading to Roblox.
