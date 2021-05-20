
# file Get-Emoji.Tests.ps1

function Get-Emoji {
    param (
        [string]
        $Name
    )

    switch ($Name) {
        "cactus" { '🌵'; Break }
        "giraffe" { '🦒' ; Break }
        "pencil" { '✏'; Break }
        "penguin" { '🐧'; Break }
        "pensive" { '😔'; Break }
        Default {}
    }
    
}