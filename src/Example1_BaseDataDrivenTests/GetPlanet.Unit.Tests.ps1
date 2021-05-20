# Runs during runs-phase, runs only once -> https://pester.dev/docs/usage/setup-and-teardown 
# Checkout https://pester.dev/docs/usage/discovery-and-run and https://pester.dev/docs/usage/data-driven-tests#execution-is-not-top-down to 
# know in which phases Describe and e.g. BeforeAll are called -> important for variable references

BeforeAll {
  # The function to test
  function Get-Planet ([string]$Name = '*') {
    $planets = @(
      @{ Name = 'Mercury' }
      @{ Name = 'Venus' }
      @{ Name = 'Earth' }
      @{ Name = 'Mars' }
      @{ Name = 'Jupiter' }
      @{ Name = 'Saturn' }
      @{ Name = 'Uranus' }
      @{ Name = 'Neptune' }
    ) | ForEach-Object { [PSCustomObject]$_ }

    $planets | Where-Object { $_.Name -like $Name }
  }
}

# Pester tests, Use Describe to group multiple tests. You can use multiple Descibe blocks in one file. 
# You may also nest Describe statements to give your testsuite a more structured layout.
Describe 'Get-Planet' {
  It "Given no parameters, it lists all 8 planets" {
    $allPlanets = Get-Planet
    $allPlanets.Count | Should -Be 8
  }

  Context "Filtering by Name" {

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