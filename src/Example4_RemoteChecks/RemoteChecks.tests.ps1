
BeforeDiscovery {
    # Define Credentials
    [string]$userName = 'Administrator'
    [string]$userPassword = 'admin'

    # Create credential Object
    [SecureString]$secureString = $userPassword | ConvertTo-SecureString -AsPlainText -Force 
    [PSCredential]$credentialObject = New-Object System.Management.Automation.PSCredential -ArgumentList $userName, $secureString

    $sessions = @()
    '10.144.41.203', '10.144.41.204' | % {
        $sessions += New-PSSession -ComputerName $_ -Credential $credentialObject
    }
}

Describe "System checks for <_.ComputerName> " -Foreach $sessions { # Discovery phase: Create one describe block per session
    BeforeAll { # Run phase: called one time during run phase of describe block
        $session = $_
    }

    Context "Service <_> context" -Foreach "service1", "service2" { # one context per service
        BeforeAll { # called one time during run phase of describe block
            $serviceName = $_
            $service = Invoke-Command -Session $session -ScriptBlock { get-service } | ?  Name -eq $serviceName
        }
        It "Service <_> shall be running" {
            $service.Status | Should -Be 'Running'
        }

        It "Service <_> startup type should be automatic" {
            $service.StartType | Should -Be 'Automatic'
        }
    }
    Context "Process <_>" -Foreach "process1", "process2" { # one context per service
        BeforeAll { # called one time during run phase of describe block
            $processName = $_
            $process = Invoke-Command -Session $session -ScriptBlock { Get-Process -Name $Using:processName } 
        }
        It "Process <_> shall exist" {
            $process | Should -Not -BeNullOrEmpty
        }
    }
} 
