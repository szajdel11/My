# =========================
# Exam Account Generator
# =========================

# NOTES:
# Creates Entra ID exam accounts, generates credentials,
# and exports results to CSV.
# Group assignment is handled via dynamic group rules.

# -------------------------
# PARAMETERS
# -------------------------

$Count      = 16
$Domain     = "hatchend.harrow.sch.uk"
$Prefix     = "ExamAccount"
$OutputPath = "C:\Temp\ExamAccounts.csv"

# Core configuration for account generation

# -------------------------
# CONNECT TO MICROSOFT GRAPH
# -------------------------

Connect-MgGraph -Scopes "User.ReadWrite.All"

# Only user creation permissions required

# -------------------------
# OUTPUT STORAGE
# -------------------------

$results = @()

# Stores output for CSV export

# -------------------------
# PASSWORD GENERATOR
# -------------------------

function New-ExamPassword {

    # Generates simple exam-friendly password (WordWord + number)

    $words = @("River","Glass","Ocean","Cloud","Green","Blue","Yellow","Lake","Fire","Wind")

    $w1 = $words | Get-Random
    $w2 = $words | Get-Random
    $num = Get-Random -Minimum 00 -Maximum 99

    return "$w1$w2$num"
}
# -------------------------
# MAIN LOOP
# -------------------------

for ($i = 1; $i -le $Count; $i++) {

    # Generate sequential username
    $username = "{0}{1:D2}" -f $Prefix, $i
    $upn = "$username@$Domain"

    # Generate credentials
    $password = New-ExamPassword
    $pin = Get-Random -Minimum 000000 -Maximum 999999

    # -------------------------
    # CHECK IF USER EXISTS
    # -------------------------

    $exists = Get-MgUser -Filter "userPrincipalName eq '$upn'"

    if ($exists) {
        Write-Host "Skipping existing user: $upn"
        continue
    }

    # -------------------------
    # CREATE USER
    # -------------------------

    New-MgUser `
        -DisplayName $username `
        -UserPrincipalName $upn `
        -AccountEnabled `
        -MailNickname $username `
        -PasswordProfile @{
            Password = $password
            ForceChangePasswordNextSignIn = $false
        }

    # -------------------------
    # STORE RESULT
    # -------------------------

    $results += [pscustomobject]@{
        Username = $username
        UPN      = $upn
        Password = $password
        PIN      = $pin
    }
}

# -------------------------
# EXPORT CSV
# -------------------------

$results | Export-Csv -Path $OutputPath -NoTypeInformation