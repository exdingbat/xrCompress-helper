using module .\xrCompress.psm1

param (
    [ValidateNotNullOrEmpty()]
    [Parameter(
        Position = 0,
        Mandatory = $true,
        HelpMessage = "'gamedataPath' should be the absolute path to the " +
        "gamedata you wish to compress.`n    e.g C:\anomaly\gamedata`n`n" +
        'This script provides TAB file path autocompletion before you press ' +
        'ENTER, though the current help prompt does not allow TAB ' +
        'autocompletion. If you wish to use the autocomplete feature, KILL ' +
        'the current script with CTRL + C.`n`n' +
        'If you wish view the output of a dry-run, call this script with ' +
        '-WhatIf`n    e.g. > xrCompress.ps1 C:\anomaly\gamedata -Whatif'

    )]
    [System.IO.FileInfo]$GamedataPath,
    [Parameter()][switch]$WhatIf,
    [Parameter( HelpMessage = 'Write .ltx config. Do not compress gamedata to .dbX.')][switch]$CfgOnly,
    [Parameter()][switch]$Silent
)
$global:Silent = $Silent
$global:WhatIf = $WhatIf
$global:CfgOnly = $CfgOnly

$gd = $GamedataPath
[XrCompress[]]$levels = @(
    # probably just use the base anomaly dbs?
    # [XrCompress]::new($gd, @('fake_start', 'levels'), '-fast', @('levels\fake_start = true'), $null)
    # [XrCompress]::new($gd, @('jupiter', 'levels'), '-fast', @('levels\jupiter = true'), $null)
    # [XrCompress]::new($gd, @('jupiter_underground', 'levels'), '-fast', @('levels\jupiter_underground = true'), $null)
    # [XrCompress]::new($gd, @('k00_marsh', 'levels'), '-fast', @('levels\k00_marsh = true'), $null)
    # [XrCompress]::new($gd, @('k01_darkscape', 'levels'), '-fast', @('levels\k01_darkscape = true'), $null)
    # [XrCompress]::new($gd, @('k02_trucks_cemetery', 'levels'), '-fast', @('levels\k02_trucks_cemetery = true'), $null)
    # [XrCompress]::new($gd, @('l01_escape', 'levels'), '-fast', @('levels\l01_escape = true'), $null)
    # [XrCompress]::new($gd, @('l02_garbage', 'levels'), '-fast', @('levels\l02_garbage = true'), $null)
    # [XrCompress]::new($gd, @('l03u_agr_underground', 'levels'), '-fast', @('levels\l03u_agr_underground = true'), $null)
    # [XrCompress]::new($gd, @('l03_agroprom', 'levels'), '-fast', @('levels\l03_agroprom = true'), $null)
    # [XrCompress]::new($gd, @('l04u_labx18', 'levels'), '-fast', @('levels\l04u_labx18 = true'), $null)
    # [XrCompress]::new($gd, @('l04_darkvalley', 'levels'), '-fast', @('levels\l04_darkvalley = true'), $null)
    # [XrCompress]::new($gd, @('l05_bar', 'levels'), '-fast', @('levels\l05_bar = true'), $null)
    # [XrCompress]::new($gd, @('l06_rostok', 'levels'), '-fast', @('levels\l06_rostok = true'), $null)
    # [XrCompress]::new($gd, @('l07_military', 'levels'), '-fast', @('levels\l07_military = true'), $null)
    # [XrCompress]::new($gd, @('l08u_brainlab', 'levels'), '-fast', @('levels\l08u_brainlab = true'), $null)
    # [XrCompress]::new($gd, @('l08_yantar', 'levels'), '-fast', @('levels\l08_yantar = true'), $null)
    # [XrCompress]::new($gd, @('l09_deadcity', 'levels'), '-fast', @('levels\l09_deadcity = true'), $null)
    # [XrCompress]::new($gd, @('l10u_bunker', 'levels'), '-fast', @('levels\l10u_bunker = true'), $null)
    # [XrCompress]::new($gd, @('l10_limansk', 'levels'), '-fast', @('levels\l10_limansk = true'), $null)
    # [XrCompress]::new($gd, @('l10_radar', 'levels'), '-fast', @('levels\l10_radar = true'), $null)
    # [XrCompress]::new($gd, @('l10_red_forest', 'levels'), '-fast', @('levels\l10_red_forest = true'), $null)
    # [XrCompress]::new($gd, @('l11_hospital', 'levels'), '-fast', @('levels\l11_hospital = true'), $null)
    # [XrCompress]::new($gd, @('l11_pripyat', 'levels'), '-fast', @('levels\l11_pripyat = true'), $null)
    # [XrCompress]::new($gd, @('l12u_control_monolith', 'levels'), '-fast', @('levels\l12u_control_monolith = true'), $null)
    # [XrCompress]::new($gd, @('l12u_sarcofag', 'levels'), '-fast', @('levels\l12u_sarcofag = true'), $null)
    # [XrCompress]::new($gd, @('l12_stancia', 'levels'), '-fast', @('levels\l12_stancia = true'), $null)
    # [XrCompress]::new($gd, @('l12_stancia_2', 'levels'), '-fast', @('levels\l12_stancia_2 = true'), $null)
    # [XrCompress]::new($gd, @('l13u_warlab', 'levels'), '-fast', @('levels\l13u_warlab = true'), $null)
    # [XrCompress]::new($gd, @('l13_generators', 'levels'), '-fast', @('levels\l13_generators = true'), $null)
    # [XrCompress]::new($gd, @('labx8', 'levels'), '-fast', @('levels\labx8 = true'), $null)
    # [XrCompress]::new($gd, @('pripyat', 'levels'), '-fast', @('levels\pripyat = true'), $null)
    # [XrCompress]::new($gd, @('y04_pole', 'levels'), '-fast', @('levels\y04_pole = true'), $null)
    # [XrCompress]::new($gd, @('zaton', 'levels'), '-fast', @('levels\zaton = true'), $null)
)

[XrCompress[]]$textures = @(
    # [XrCompress]::new($gd, @('textures_weapons', 'textures'), '-fast', @('textures\wpn = true'), $null)
    # [XrCompress]::new($gd, @('textures_actors', 'textures'), '-fast', @('textures\act = true'), $null)
    # [XrCompress]::new($gd, @('textures_ui', 'textures'), '-fast', @('textures\ui = true'), $null)
    # [XrCompress]::new($gd, @('textures_metal', 'textures'), '-fast', @('textures\mtl = true'), $null)
    # [XrCompress]::new($gd, @('textures_detail', 'textures'), '-fast', @('textures\detail = true'), $null)
    # [XrCompress]::new($gd, @('textures_concrete', 'textures'), '-fast', @('textures\crete = true'), $null)
    # [XrCompress]::new($gd, @('textures_sky', 'textures'), '-fast', @('textures\sky = true'), $null)
    # # lfo is tree shit
    # [XrCompress]::new($gd, @('textures_lfo', 'textures'), '-fast', @('textures\lfo = true'), $null)
    # [XrCompress]::new($gd, @('textures_stone', 'textures'), '-fast', @('textures\ston = true'), $null)
    # [XrCompress]::new($gd, @('textures', 'textures'), '-fast', @('textures = true'), @(
    #         # exclude above dirs
    #         'textures\wpn = true',
    #         'textures\act = true',
    #         'textures\ui = true',
    #         'textures\mtl = true',
    #         'textures\detail = true',
    #         'textures\crete = true',
    #         'textures\sky = true',
    #         'textures\lfo = true',
    #         'textures\ston = true'
    #     ))
)

[XrCompress[]]$meshes = @(
    # [XrCompress]::new($gd, @('anims', 'meshes'), $null, @('anims = true'), $null)
    # [XrCompress]::new($gd, @('meshes_dynamics', 'meshes'), '-fast', @('meshes\dynamics = true'), $null)
    # [XrCompress]::new($gd, @('meshes_weapons', 'meshes'), '-fast', @('meshes\anomaly_weapons = true'), $null)
    # [XrCompress]::new($gd, @('meshes_actors', 'meshes'), '-fast', @('meshes\actors = true'), $null)
    # [XrCompress]::new($gd, @('meshes', 'meshes'), '-fast', @('meshes = true'), @(
    #         # exclude above dirs
    #         'meshes\dynamics = true',
    #         'meshes\anomaly_weapons = true',
    #         'meshes\actors = true'
    #     ))
)

[XrCompress[]]$configs = @(
    #     [XrCompress]::new($gd, @('configs', 'configs'), $null, @('configs = true'), $null)
    #     [XrCompress]::new($gd, @('ai', 'configs'), $null, @('ai = true'), $null)
    #     [XrCompress]::new($gd, @('spawns', 'configs'), $null, @('spawns = true'), $null)
    #     [XrCompress]::new($gd, @('scripts', 'configs'), $null, @('scripts = true'), $null)
)

[XrCompress[]]$sounds = @(
    # potentially big, little to no gains with compression
    # [XrCompress]::new($gd, @('sounds_voices', 'sounds'), '-store', @('sounds\characters_voice = true'), $null)
    # [XrCompress]::new($gd, @('sounds_music', 'sounds'), '-store', @('sounds\music = true'), $null)
    # [XrCompress]::new($gd, @('sounds_ambient', 'sounds'), '-store', @('sounds\ambient = true'), $null)
    [XrCompress]::new($gd, @('sounds_radio_addon', 'sounds'), '-store', @('sounds\anomaly_radio_addon = true'), $null)
    [XrCompress]::new($gd, @('sounds', 'sounds'), '-store', $('sounds = true'), [String[]]@(
            'sounds\characters_voice = true'
            'sounds\music = true'
            'sounds\ambient = true'
            'sounds\anomaly_radio_addon = true'
        ))
)

[XrCompress[]]$misc = @(
    # [XrCompress]::new($gd, @('files', ''), $null, @('.\ = false', 'particles = true') , $null)
    # [XrCompress]::new($gd, @('shaders', ''), $null, @('shaders = true'), $null)
)


# $misc + $configs | ForEach-Object { $_.Run() }
$misc + $configs + $levels + $sounds + $meshes + $textures | ForEach-Object { $_.Run() }

Write-Host "`nDone!`n"
