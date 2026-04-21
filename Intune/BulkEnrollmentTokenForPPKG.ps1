Install-Module -Name AADInternals -RequiredVersion 0.4.8
Import-Module AADInternals
Get-AADIntAccessTokenForAADGraph -Resource urn:ms-drs:enterpriseregistration.windows.net -SaveToCache
$bprt = New-AADIntBulkPRTToken -Expires ((Get-Date).AddDays(180))
[PSCustomObject]@{'Authority'='https://login.microsoftonline.com/common'; 'BPRT'=$bprt}
Pause