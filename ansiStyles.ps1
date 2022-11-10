
Enum AnsiSrg  {
    Bold = 1
    Italic = 3
    Black = 30
    BgBlack = 40
    Red = 31
    BgRed = 41
    Green = 32
    BgGreen = 42
    Yellow = 33
    BgYellow = 43
    Blue = 34
    BgBlue = 44
    Magenta = 35
    BgMagenta = 45
    Cyan = 36
    BgCyan = 46
    White = 37
    BgWhite = 47
    BrightBlack = 90
    BrightRed = 91
    BrightGreen = 92
    BrightYellow = 93
    BrightBlue = 94
    BrightMagenta = 95
    BrightCyan = 96
    BrightWhite = 97
    BgBrightBlack = 100
    BgBrightRed = 101
    BgBrightGreen = 102
    BgBrightYellow = 103
    BgBrightBlue = 104
    BgBrightMagenta = 105
    BgBrightCyan = 106
    BgBrightWhite = 107
}


function Get-Ansi {
    param ([string]$Str, [string]$Style)
    $code = [int]([AnsiSrg]::$Style)
    return '{0}[{1}m{2}{0}[0m' -f "$([char]0x1b)", $code, $str
}
