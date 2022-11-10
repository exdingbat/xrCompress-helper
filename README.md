# xrCompress

Copied from the xrCompress readme found on moddb? and https://xray-engine.org/index.php?title=xrCompress translated via google

## Instructions:

Unpacking

- Drop the desired .dbl-archive into the gamedata folder.
- Run Unpack_Dead_Air.cmd
- Unpacked files will be in the folder Dead_Air
- Do not mess with the "fake" folder

## Resource packaging

### Team:

```bat
xrCompress.exe < data_dir > -ltx < file_name.ltx > [options]
```

Options can be:

    -diff /? (option to get information about created differences)
    -fast (fast compression)
    -store (save files without compression)
    -ltx <file_name.ltx> (config with paths for packed files)

ltx file format:

```ini
[config]
;<path> = <recurse>
.\ = false
textures = true

```

## Getting differences (creating a patch)

Team:

```cmd
xrCompress.exe -diff < new_data > <old_data > -out < diff_resulf > [options]
```

The <new_data> , <old_data> , and <diff_resulf> parameters must be directory names.
Options can be:

    -nofileage (don't check for file modification date)
    -crc (do not perform CRC32 check)
    -nobinary (don't check binary files)
    -nosize (don't check file size)

Note: the compressor from 2215 could unpack the archives of some builds; unpacker does not work in modern versions.

## Practice

### Resource packaging

1. Let's create a batch file of the following form:

```bat
: : start the packer with a delay
@ start /wait bin\designer\compressor\xrCompress.exe gamedata -ltx datapack.ltx
: : move and rename the log file from the root folder to $logs
move /YX:\engine.log X:\ logs\xrCompress* %username% .log
: : move the dump (if any) to $logs
move /YX:\xrCompress*\*.mdmp X:\logs\
 pause
```

2. Create an ltx file with the following content:

```ini
[options]
exclude_exts = _.ncb,_.sln,_.vcproj,_.old,_.rc,_.scc,_.vssscc,_.bmp,_.smf,_.uvm,_.prj,_ .tga,_.txt,_.log,\*.tmp

[include_folders]
;<path> = <recurse>
.\ = false
configs = true

[exclude_folders]
textures\ed = true

[header]
auto_load = true
level_name = single
level_ver = 1.0
entry_point = $fs_root$\gamedata\
creator = "gsc game world"
link = "www.gsc-game.com"
```

Everything is clear here - the sections indicate the files and folders that are taken into account / not taken into account. The header indicates the type of archive, version, entry point and the possibility of autoloading at the start of the game:

    for a single game - single, autoload is allowed;
    for network it must match the name of the card, autoload is disabled.

With the above config, a gamedata.pack\_#0 archive will be created containing \*.xr files and configs from the gamedata folder. Now it needs to be renamed to gamedata.dbNN , where NN is the serial number of the archive, and sent to the game folder.

## Creating a patch

### Team:

```bat
@ start /wait bin\designer\compressor\xrCompress.exe -diff gamedata gamedata*old -out patch* %date%
move /YX:\engine.log X:\logs\xrCompress* %username% .log
move /YX:\xrCompress*\*. mdmp X:\logs\
 pause
```

Gamedata contains the files of the working version of the project, gamedata*old contains the original (unchanged) resources of the game. As a result, we get a folder with our mod/patch ( patch*%date% ), ready for packing.
