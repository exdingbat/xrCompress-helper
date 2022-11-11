filter Out-Log {
    if ($global:Silent) {
        $_ | Out-Null
    } else {
        $_ | Out-Default
    }
}

class XrCompress {
    [string]$Gamedata = $null
    [string]$Name = $null
    [string]$Dir = $null
    [string]$Flag = $null
    [string[]]$Include = $null
    [string[]]$Exclude = $null

    hidden [string]$Cfg = $null
    hidden [string]$CfgName = $null
    hidden [switch]$WhatIf = $global:WhatIf
    hidden [switch]$CfgOnly = $global:CfgOnly

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
        [string]$flag,
        [string[]]$include,
        [string[]]$exclude = @()
    ) {
        $this.Gamedata = $gamedata
        $this.Name = $name
        $this.Dir = $dir
        $this.Flag = $flag
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
        $flagFmt = if ($this.Flag) { ' ' + $this.Flag } else { '' }
        return '{0} {1} -ltx {2}' -f $this.Gamedata, $flagFmt, $this.CfgName
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
        Write-Host $this.Flag
        Write-Host $this.Include
        Write-Host $this.Exclude
        Write-Host $this.CfgName
        New-Item $([XrCompress]::CfgDir) -ItemType Directory -ea 0
        Push-Location $([XrCompress]::CfgDir)
        Set-Content -Path $(".\$($this.CfgName)") -Value $cfgStr

        if ($this.CfgOnly) {
            Pop-Location
        } else {
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
        [string]$flag,
        [string[]]$include

    ) {
        return [XrCompress]::new($this.Gamedata, $name, $dir, $flag, $include, @())
    }

    [XrCompress]GetXRC(
        [string]$name,
        [string]$dir,
        [string]$flag,
        [string[]]$include,
        [string[]]$exclude
    ) {
        return [XrCompress]::new($this.Gamedata, $name, $dir, $flag, $include, $exclude)
    }

}