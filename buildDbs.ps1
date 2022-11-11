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
        '-WhatIf`n    e.g. > buildDbs.ps1 C:\anomaly\gamedata -Whatif'

    )]
    [System.IO.FileInfo]$GamedataPath,
    [Parameter()][switch]$WhatIf,
    [Parameter( HelpMessage = 'Write .ltx config. Do not compress gamedata to .db files.')][switch]$CfgOnly,
    [Parameter()][switch]$Silent
)

$global:Silent = $Silent
$global:WhatIf = $WhatIf
$global:CfgOnly = $CfgOnly


# TODO: iterate over target dir/levels and dynamically generate level params
# TODO: use array or map of params so it's clearer what the constructor args actually are
# TODO: generate excludes arrays based on existing includes arrays

$f = [XrCompressFactory]::new($GamedataPath)

$levels = @(
    # probably just use the vanilla anomaly levels and load the loose levels data with MO2?
    $f.GetXRC('fake_start', 'levels', '-fast', @('levels\fake_start = true'))
    $f.GetXRC('jupiter', 'levels', '-fast', @('levels\jupiter = true'))
    $f.GetXRC('jupiter_underground', 'levels', '-fast', @('levels\jupiter_underground = true'))
    $f.GetXRC('k00_marsh', 'levels', '-fast', @('levels\k00_marsh = true'))
    $f.GetXRC('k01_darkscape', 'levels', '-fast', @('levels\k01_darkscape = true'))
    $f.GetXRC('k02_trucks_cemetery', 'levels', '-fast', @('levels\k02_trucks_cemetery = true'))
    $f.GetXRC('l01_escape', 'levels', '-fast', @('levels\l01_escape = true'))
    $f.GetXRC('l02_garbage', 'levels', '-fast', @('levels\l02_garbage = true'))
    $f.GetXRC('l03u_agr_underground', 'levels', '-fast', @('levels\l03u_agr_underground = true'))
    $f.GetXRC('l03_agroprom', 'levels', '-fast', @('levels\l03_agroprom = true'))
    $f.GetXRC('l04u_labx18', 'levels', '-fast', @('levels\l04u_labx18 = true'))
    $f.GetXRC('l04_darkvalley', 'levels', '-fast', @('levels\l04_darkvalley = true'))
    $f.GetXRC('l05_bar', 'levels', '-fast', @('levels\l05_bar = true'))
    $f.GetXRC('l06_rostok', 'levels', '-fast', @('levels\l06_rostok = true'))
    $f.GetXRC('l07_military', 'levels', '-fast', @('levels\l07_military = true'))
    $f.GetXRC('l08u_brainlab', 'levels', '-fast', @('levels\l08u_brainlab = true'))
    $f.GetXRC('l08_yantar', 'levels', '-fast', @('levels\l08_yantar = true'))
    $f.GetXRC('l09_deadcity', 'levels', '-fast', @('levels\l09_deadcity = true'))
    $f.GetXRC('l10u_bunker', 'levels', '-fast', @('levels\l10u_bunker = true'))
    $f.GetXRC('l10_limansk', 'levels', '-fast', @('levels\l10_limansk = true'))
    $f.GetXRC('l10_radar', 'levels', '-fast', @('levels\l10_radar = true'))
    $f.GetXRC('l10_red_forest', 'levels', '-fast', @('levels\l10_red_forest = true'))
    $f.GetXRC('l11_hospital', 'levels', '-fast', @('levels\l11_hospital = true'))
    $f.GetXRC('l11_pripyat', 'levels', '-fast', @('levels\l11_pripyat = true'))
    $f.GetXRC('l12u_control_monolith', 'levels', '-fast', @('levels\l12u_control_monolith = true'))
    $f.GetXRC('l12u_sarcofag', 'levels', '-fast', @('levels\l12u_sarcofag = true'))
    $f.GetXRC('l12_stancia', 'levels', '-fast', @('levels\l12_stancia = true'))
    $f.GetXRC('l12_stancia_2', 'levels', '-fast', @('levels\l12_stancia_2 = true'))
    $f.GetXRC('l13u_warlab', 'levels', '-fast', @('levels\l13u_warlab = true'))
    $f.GetXRC('l13_generators', 'levels', '-fast', @('levels\l13_generators = true'))
    $f.GetXRC('labx8', 'levels', '-fast', @('levels\labx8 = true'))
    $f.GetXRC('pripyat', 'levels', '-fast', @('levels\pripyat = true'))
    $f.GetXRC('y04_pole', 'levels', '-fast', @('levels\y04_pole = true'))
    $f.GetXRC('zaton', 'levels', '-fast', @('levels\zaton = true'))
)

$textures = @(
    $f.GetXRC('textures_weapons', 'textures', '-fast', @('textures\wpn = true'))
    $f.GetXRC('textures_actors', 'textures', '-fast', @('textures\act = true'))
    $f.GetXRC('textures_ui', 'textures', '-fast', @('textures\ui = true'))
    $f.GetXRC('textures_metal', 'textures', '-fast', @('textures\mtl = true'))
    $f.GetXRC('textures_detail', 'textures', '-fast', @('textures\detail = true'))
    $f.GetXRC('textures_concrete', 'textures', '-fast', @('textures\crete = true'))
    $f.GetXRC('textures_sky', 'textures', '-fast', @('textures\sky = true'))
    # lfo is tree/bush stuff
    $f.GetXRC('textures_lfo', 'textures', '-fast', @('textures\lfo = true'))
    $f.GetXRC('textures_stone', 'textures', '-fast', @('textures\ston = true'))
    $f.GetXRC('textures', 'textures', '-fast', @('textures = true'), @(
            'textures\wpn = true',
            'textures\act = true',
            'textures\ui = true',
            'textures\mtl = true',
            'textures\detail = true',
            'textures\crete = true',
            'textures\sky = true',
            'textures\lfo = true',
            'textures\ston = true'
        ))
)

$meshes = @(
    $f.GetXRC('meshes_dynamics', 'meshes', '-fast', @('meshes\dynamics = true'))
    $f.GetXRC('meshes_weapons', 'meshes', '-fast', @('meshes\anomaly_weapons = true'))
    $f.GetXRC('meshes_actors', 'meshes', '-fast', @('meshes\actors = true'))
    $f.GetXRC('meshes', 'meshes', '-fast', @('meshes = true'), @(
            'meshes\dynamics = true',
            'meshes\anomaly_weapons = true',
            'meshes\actors = true'
        ))
)

$configs = @(
    $f.GetXRC('configs', 'configs', @('configs = true'))
    $f.GetXRC('ai', 'configs', @('ai = true'))
    $f.GetXRC('spawns', 'configs', @('spawns = true'))
    $f.GetXRC('scripts', 'configs', @('scripts = true'))
)

$sounds = @(
    # little to no gains with compression
    $f.GetXRC('sounds_voices', 'sounds', '-store', @('sounds\characters_voice = true'))
    $f.GetXRC('sounds_music', 'sounds', '-store', @('sounds\music = true'))
    $f.GetXRC('sounds_ambient', 'sounds', '-store', @('sounds\ambient = true'))
    $f.GetXRC('sounds_radio_addon', 'sounds', '-store', @('sounds\anomaly_radio_addon = true'))
    $f.GetXRC('sounds', 'sounds', '-store', $('sounds = true'), @(
            'sounds\characters_voice = true'
            'sounds\music = true'
            'sounds\ambient = true'
            'sounds\anomaly_radio_addon = true'
        ))
)

$misc = @(
    $f.GetXRC('files', '', @('.\ = false', 'particles = true') )
    $f.GetXRC('shaders', '', @('shaders = true'))
)

# merge array and iterate of XrCompress objects
# $misc + $configs + $levels + $sounds + $meshes + $textures | ForEach-Object { $_.Run() }

Write-Host "`nDone!`n"
