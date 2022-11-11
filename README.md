# xrCompress-helper

This repository provides Powershell 5.1+ scripts to assist with the packaging and unpackaging of S.T.A.L.K.E.R.: Anomaly `.dbX` files. The script assumes that an external compression tool, `xrCompress.exe`, is located relative to CWD at `.xrc`.

This README does not contain instructions on running the script because this project is still very much a WIP. If you're comfortable with CLI scripting, I encourage you to look at (buildDbs.ps1)[./buildDbs.ps1] and (xrCompress.psm1)[./xrCompress.psm1] to determine if you feel comfortable giving them a run. Please note that Powershell files (especially `.psm1` modules and classes) have some [quirks](https://stackoverflow.com/a/67028718). If you are not comfortable with programming or CLIs then you should probably avoid using `xrCompress-helper` for now.
