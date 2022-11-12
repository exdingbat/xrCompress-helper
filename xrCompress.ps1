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

# TODO: iterate over target dir/levels and dynamically generate level params
# TODO: generate excludes arrays based on existing includes arrays

function Get-Mod {
    param([Parameter(Position = 0)][string]$mod)
    [XrCompressFactory]::new( "D:\anomaly_mods\my_repack_addons\$mod\gamedata")
}

function Start-XrCompress {
    $json = (Get-Content 'buildConfig.json' | Out-String | ConvertFrom-Json)
    $json.PSObject.Properties | ForEach-Object {
        Write-Host 'Reading config for' $_.Name
        $_.Value | ForEach-Object {
            $cfg = $_
            $xrc = [XrCompress]::new($GamedataPath, $cfg.name, $cfg.dir, $cfg.arg, $cfg.include, $cfg.exclude)
            $xrc.Run()
        }
    }
    
    # merge array and iterate of XrCompress objects
    # $misc + $configs + $levels + $sounds + $meshes + $textures | ForEach-Object { $_.Run() }

    # $addons = @(
    #     $(Get-Mod 'ammoSelector' ).GetXRC('ammoSelector', '', '-fast', @('.\ = true'))
    #     $(Get-Mod 'shadersDeck' ).GetXRC('shadersDeck', '', '-fast', @('.\ = true'))
    #     $(Get-Mod 'combineAll' ).GetXRC('combineAll', '', '-fast', @('.\ = true'))
    #     $(Get-Mod 'gamma' ).GetXRC('gamma', '', '-fast', @('.\ = true'))
    #     $(Get-Mod 'innumerable' ).GetXRC('innumerable', '', '-fast', @('.\ = true'))
    # )
    # $addons | ForEach-Object { $_.Run() }
    
    Write-Host "`nDone!`n"
}

filter Out-Log {
    if ($Silent) {
        $_ | Out-Null
    }
    else {
        $_ | Out-Default
    }
}

class XrCompressConfig {
    [string]$Name = $null
    [string]$Dir = $null
    [string]$Arg = $null
    [string[]]$Include = $null
    [string[]]$Exclude = $null
}

class XrCompress {
    [string]$Gamedata = $null
    [string]$Name = $null
    [string]$Dir = $null
    [string]$Arg = $null
    [string[]]$Include = $null
    [string[]]$Exclude = $null

    hidden [string]$Cfg = $null
    hidden [string]$CfgName = $null
    hidden [switch]$WhatIf = $WhatIf
    hidden [switch]$CfgOnly = $CfgOnly

    static [string]$CfgDir = '.ltx'
    static [string]$XRCDir = '.xrc'
    static [string]$DBDir = 'db'
    static [string]$Exts =
    '*.ncb,*.sln,*.vcproj,*.old,*.rc,*.scc,*.vssscc,*.bmp,*.exe,*.db,*.bak*,' +
    '*.bmp,*.smf,*.uvm,*.prj,*.tga,*.txt,*.rtf,*.doc,*.log,*.~*,*.rar,*.7z,' +
    '*.zip,*.sfk'


    XrCompress(
        [string]$gamedata,
        [string]$name,
        [string]$dir,
        [string]$Arg,
        [string[]]$include,
        [string[]]$exclude = @()
    ) {
        $this.Gamedata = $gamedata
        $this.Name = $name
        $this.Dir = $dir
        $this.Arg = $Arg
        $this.Include = $include
        $this.Exclude = $exclude
        $this.CfgName = "$($this.Name).ltx"
    }

    [string]GetCfg() {
        return @(
            '[options]'
            "exclude_exts = $([XrCompress]::Exts)"
            'bytes = 2'
            ''
            '[include_folders]'
            $this.Include -join "`n"
            ''
            '[exclude_folders]'
            $this.Exclude -join "`n"
            ''
            '[header]'
            'auto_load     = true'
            'level_name    = anomaly'
            'level_ver     = 1.0'
            'entry_point   = $fs_root$\gamedata'
            'creator       = "gsc game world"'
            'link          = "www.gsc-game.com"'
        ) -join "`n"
    }

    hidden [string]GetCompressArgs() {
        $ArgFmt = if ($this.Arg) { ' ' + $this.Arg } else { '' }
        return '{0} {1} -ltx {2}' -f $this.Gamedata, $ArgFmt, $this.CfgName
    }

    hidden [string]GetCompressCommand() {
        return  "..\$([XrCompress]::XRCDir)\xrCompress.exe $($this.GetCompressArgs())"

    }

    hidden [void]MoveDbFiles() {
        New-Item .\db -ItemType Directory -ea 0
        if ($this.Dir) {
            New-Item ".\$([XrCompress]::DBDir)\$($this.Dir)" -ItemType Directory -ea 0
        }
        $target = "$($this.Gamedata)\..\gamedata.db*"
        $dest = ".\$([XrCompress]::DBDir)\$($this.Dir)\$($this.Name)"
        Get-ChildItem -Path $target | Move-Item -Destination {
            $dest + $($_.Extension)
        }
    }

    [void]Run() {
        $cfgStr = $this.GetCfg()
        $compressCmd = $this.GetCompressCommand()

        if ($this.WhatIf) {
            $line = '=' * 9
            $cfgHeader = "$line $($this.CfgName) $line`n"
            $cfgFooter = '=' * $cfgHeader.Length

            "{0}`n{1}`n{2}`n" -f $cfgHeader, $cfgStr, $cfgFooter | Out-Log
            "Running $compressCmd`n" | Out-Log
            return
        }

        Write-Host $this.Gamedata
        Write-Host $this.Name
        Write-Host $this.Dir
        Write-Host $this.Arg
        Write-Host $this.Include
        Write-Host $this.Exclude
        Write-Host $this.CfgName
        New-Item $([XrCompress]::CfgDir) -ItemType Directory -ea 0
        Push-Location $([XrCompress]::CfgDir)
        Set-Content -Path $(".\$($this.CfgName)") -Value $cfgStr

        if ($this.CfgOnly) {
            Pop-Location
        }
        else {
            "Running $compressCmd" | Out-Log
            & { & Invoke-Expression -Command $compressCmd } | Out-Log
            Pop-Location
            $this.MoveDbFiles()
        }
    }
}

class XrCompressFactory {
    [string]$Gamedata = $null
    XrCompressFactory($gamedata) {
        $this.Gamedata = $gamedata
    }

    [XrCompress]GetXRC(
        [string]$name,
        [string]$dir,
        [string[]]$include

    ) {
        return [XrCompress]::new($this.Gamedata, $name, $dir, $null, $include, @())
    }
    [XrCompress]GetXRC(
        [string]$name,
        [string]$dir,
        [string]$Arg,
        [string[]]$include

    ) {
        return [XrCompress]::new($this.Gamedata, $name, $dir, $Arg, $include, @())
    }

    [XrCompress]GetXRC(
        [string]$name,
        [string]$dir,
        [string]$Arg,
        [string[]]$include,
        [string[]]$exclude
    ) {
        return [XrCompress]::new($this.Gamedata, $name, $dir, $Arg, $include, $exclude)
    }

}

Start-XrCompress