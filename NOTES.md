# Notes

At least wrt to `meshes`, default compression doesn't seem to save that much more over `-fast` compression
4.74 GB vs 4.31 GB

same with Textures

## Recreate base anomaly splits

└ ┌ ├ ─ ┬ │

where are particles?
VERSIONS?

gamedata
├──files.db
│  ├─ gamdedata\particles
│  └─ gamdedata\*.*
├──shaders.db
│  └─ gamedata\shaders\*
├──levels
│  └─ level_*.db
├──configs
│  ├─ all of these are their own gamedata\* dir, not nested in gamedata\configs
│  ├─ ai.db
│  ├─ configs.db
│  ├─ scripts.db
│  └─ spawns.db
├──meshes
│  ├─ anims is gamedata\anims, not nested in gamedata\meshes
│  ├─ anims.db
│  ├─ meshes.db
│  ├─ meshes_actors.db
│  ├─ meshes_dynamics.db
│  └─ meshes_weapons.db
├──meshes
│  ├─ anims.db
│  ├─ meshes.db
│  ├─ meshes_actors.db
│  ├─ meshes_dynamics.db
│  └─ meshes_weapons.db
├──textures
│  ├─ textures.db
│  ├─ textures_actors.db
│  ├─ textures_concrete.db
│  ├─ textures_detail.db
│  ├─ textures_metal.db
│  ├─ textures_sky.db
│  ├─ textures_stone.db
│  └─ textures_weapons.db
├──sounds
│  ├─ sounds.db
│  ├─ sounds_ambient.db
│  ├─ sounds_music.db
│  └─ sounds_voices.db
