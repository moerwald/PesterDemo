
BeforeDiscovery {
    # Define Credentials
    [string]$userName = 'Administrator'

    [securestring] $cryptedPw = Get-Content (Join-Path $PSScriptRoot 'encryptedPassword.txt') | ConvertTo-SecureString
    [pscredential] $credentialObject = New-Object System.Management.Automation.PsCredential($userName, $cryptedPw)

    # Create credential Object

    $sessions = @()
    '10.144.41.203', '10.144.41.204' | ForEach-Object {
        $sessions += New-PSSession -ComputerName $_ -Credential $credentialObject
    }
}

Describe "System checks for <_.ComputerName> " -Foreach $sessions { # Discovery phase: Create one describe block per session

    BeforeAll { # Run phase: called one time during run phase of describe block
        $session = $_
    }

    Context "Service <_> context" -Foreach "DusmSvc", "AppInfo" { # one context per service
        BeforeAll { # called one time during run phase of describe block
            $serviceName = $_
            $service = Invoke-Command -Session $session -ScriptBlock { get-service } | Where-Object  Name -eq $serviceName
        }
        
        It "Service <_> shall be running" {
            $service.Status | Should -Be 'Running'
        }

        It "Service <_> startup type should be automatic" {
            $service.StartType | Should -Be 'Automatic'
        }
    }
    
    Context "Process <_>" -Foreach "System", "svchost" { # one context per process
        BeforeAll { # called one time during run phase of describe block
            $processName = $_
            $process = Invoke-Command -Session $session -ScriptBlock { Get-Process -Name $Using:processName } 
        }
        It "Process <_> shall exist" {
            $process | Should -Not -BeNullOrEmpty
        }
    }
} 
