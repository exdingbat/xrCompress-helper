filter Out-Log {
    if ($global:Silent) {
        $_ | Out-Null
    } else {
        $_ | Out-Default
    }
}

class XrCompress {
    [string]$Gamedata = $null
    [string[]]$Name = $null
    [string]$Flag = $null
    [string[]]$Include = $null
    [string[]]$Exclude = $null
    hidden [switch]$WhatIf = $global:WhatIf
    hidden [switch]$CfgOnly = $global:CfgOnly
    hidden [string]$Cfg = $null
    hidden [string]$CfgName = $null
    static [string]$Exts =
    '*.ncb,*.sln,*.vcproj,*.old,*.rc,*.scc,*.vssscc,*.bmp,*.exe,*.db,*.bak*,' +
    '*.bmp,*.smf,*.uvm,*.prj,*.tga,*.txt,*.rtf,*.doc,*.log,*.~*,*.rar,*.7z,' +
    '*.zip,*.sfk'


    XrCompress([string]$gamedata, [string[]]$name, [string]$flag = '', [string[]]$include, [string[]]$exclude) {
        $this.Gamedata = $gamedata
        $this.Name = $name
        $this.Flag = $flag
        $this.Include = $include
        $this.Exclude = $exclude
        $this.CfgName = "$($this.Name[0]).ltx"
    }

    [string]GetCfg() {
        return @(
            '[options]'
            "exclude_exts = $([XrCompress]::Exts)"
            'bytes = 2'
            ''
            '[include_folders]'
            # ';<path>       = <recurse>'
        ) + $this.Include + @(
            ''
            '[exclude_folders]'
        ) + $this.Exclude + @(
            ''
            '[header]'
            'auto_load     = true'
            'level_name    = single'
            'level_ver     = 1.0'
            'entry_point   = $fs_root$\gamedata'
            'creator       = "gsc game world"'
            'link          = "www.gsc-game.com"'
        ) -join "`n"
    }

    hidden [string]GetCompressArgs() {
        $flagFmt = if ($this.Flag) { ' ' + $this.Flag } else { '' }
        return '{0} {1} -ltx {2}' -f $this.Gamedata, $flagFmt, $this.CfgName
    }

    hidden [string]GetCompressCommand() {
        return  "..\xrCompress.exe $($this.GetCompressArgs())"

    }

    hidden [void]MoveDbs() {
        New-Item .\db -ItemType Directory -ea 0
        if ($this.Name[1]) {
            New-Item ('.\db\{0}' -f $this.Name[1]) -ItemType Directory -ea 0
        }
        Get-ChildItem -Path "$($this.Gamedata)\..\*gamedata.db*" | Move-Item -Destination { ".\db\$($this.Name[1])\$($this.Name[0])$($_.Extension)" }
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

        New-Item .ltx -ItemType Directory -ea 0
        Push-Location .ltx
        Set-Content -Path ".\$($this.CfgName)" -Value $cfgStr

        if ($this.CfgOnly) {
            return
        }

        "Running $compressCmd" | Out-Log
        & { & Invoke-Expression -Command $compressCmd } | Out-Log

        Pop-Location

        $this.MoveDbs()
    }
}
