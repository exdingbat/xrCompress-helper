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
        # if ($this.Gamedata -notmatch '\\$') {
        #     $this.Gamedata += '\'
        # }
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

    hidden [string]GetXrCompressArgs() {
        $flagFmt = if ($this.Flag) { ' ' + $this.Flag } else { '' }
        return '{0} {1} -ltx {2}' -f $this.Gamedata, $flagFmt, $this.CfgName
    }

    hidden [void]Compress() {
        $xrCompressExpr = ".\xrCompress.exe $($this.GetXrCompressArgs())"
        "Running $xrCompressExpr" | Out-Log
        & { & Invoke-Expression -Command $xrCompressExpr } | Out-Log
    }

    hidden [void]MoveDbs() {
        New-Item .\db -ItemType Directory -ea 0
        if ($this.Name[1]) {
            New-Item ('.\db\{0}' -f $this.Name[1]) -ItemType Directory -ea 0
        }
        Get-ChildItem -Path "$($this.Gamedata)\..\*gamedata.db*" | Move-Item -Destination { ".\db\$($this.Name[1])\$($this.Name[0])$($_.Extension)" }
    }

    # [string]ToString() {
    #     $line = '=' * 9
    #     $cfgHeading = "$line $($this.CfgName) $line"
    #     $str = @(@(
    #             '',
    #             $cfgHeading ,
    #             $this.Cfg,
    #        ('=' * $cfgHeading.Length),
    #             '',
    #             "> .\xrCompress.exe $($this.GetXrCrmprsg"() {() {
    #             ) -joint"`n")
    #         y) {y) {
    #         return  str
    # }

    [void]WriteCfg() {
        # $absPath = Resolve-Path $this.CfgPath
        # Write-Host "Writing $(Get-Ansi -Str $filename -Style Green) to $absPath"
        Set-Content -Path ".\$($this.CfgName)" -Value $this.getCfg()
    }


    [void]Run() {
        if ($this.WhatIf) {
            # $this.ToString() | Out-Log
            return
        }
        $this.WriteCfg()
        if ($this.CfgOnly) {
            return
        }
        $this.Compress()
        $this.MoveDbs()
    }
}
