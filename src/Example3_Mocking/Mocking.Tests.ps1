
BeforeAll{
    function Build ($version) {
        throw "a build was run for version: $version"
    }
    
    function Get-Version{
        throw 'Version'
    }
    
    function Get-NextVersion {
        throw 'NextVersion'
    }
    
    function BuildIfChanged {
        $thisVersion = Get-Version
        $nextVersion = Get-NextVersion
        if ($thisVersion -ne $nextVersion) { 
            Build $nextVersion  # Invoke Mock
        }
        $nextVersion # return nextVersion
    }
}

Describe "BuildIfChanged" {
    Context "When there are Changes" {
        BeforeEach{
            Mock Get-Version {return 1.1}
            Mock Get-NextVersion {return 1.2}
            Mock Build {} -Verifiable -ParameterFilter {$version -eq 1.2} # What do we expect for the paramter
    
            $result = BuildIfChanged
        }

        It "Builds the next version" {
            Assert-VerifiableMock
        }
        
        It "returns the next version number" {
            $result | Should -Be 1.2
        }
    }
    
    Context "When there are no Changes" {
        BeforeEach{
            Mock Get-Version { return 1.1 }
            Mock Get-NextVersion { return 1.1 }
            Mock Build {}
    
            $result = BuildIfChanged
        }

        It "Should not build the next version" {
            Assert-MockCalled Build -Times 0 -ParameterFilter {$version -eq 1.1}
        }
    }
}
