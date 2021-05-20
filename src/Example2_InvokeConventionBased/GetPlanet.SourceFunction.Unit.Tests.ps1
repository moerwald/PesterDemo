BeforeAll {
    # Source the function(s) to test
    #. $PSScriptRoot\GetPlanet.ps1

    # Alternativ source method, if you follow the convention to place your test files beside your production code files
    . $PSCommandPath.Replace('.SourceFunction.Unit.Tests.ps1','.ps1')
}

# Pester tests, Use Describe to group multiple tests. You can use multiple Descibe blocks in one file. 
# You may also nest Describe statements to give your testsuite a more structured layout.
Describe 'Get-Planet' {
  It "Given no parameters, it lists all 8 planets" {
    $allPlanets = Get-Planet
    $allPlanets.Count | Should -Be 8
  }

  Context "Filtering by Name" {

    # Data driven tests -> see https://pester.dev/docs/usage/data-driven-tests 
    # Testcase paramters can be injected via an array of dictionaries
    It "Given valid -Name '<Filter>', it returns '<Expected>'" -TestCases @(
      @{ Filter = 'Earth'; Expected = 'Earth' }
      @{ Filter = 'ne*'  ; Expected = 'Neptune' }
      @{ Filter = 'ur*'  ; Expected = 'Uranus' }
      @{ Filter = 'm*'   ; Expected = 'Mercury', 'Mars' }
    ) {
      param ($Filter, $Expected)

      $planets = Get-Planet -Name $Filter
      $planets.Name | Should -Be $Expected
    }

    It "Given invalid parameter -Name 'Alpha Centauri', it returns `$null" {
      $planets = Get-Planet -Name 'Alpha Centauri'
      $planets | Should -Be $null
    }
  }
}