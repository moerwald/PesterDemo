
# For description of assertions checkout https://pester.dev/docs/assertions/assertions 
BeforeAll {
    function Get-User {
        @{
            Name = "Jakub"
            Age  = 31
        }
    }
}

Describe "Unit tests Get-User" {

    It "some test" {
        $true | Should -be $true
    }

    Context "one test testing all ..." {
        It "check user properties" {
            # Arrange
            $user = Get-User

            # Act and Assert
            $user | Should -Not -BeNullOrEmpty 
            $user.Name | Should -Be "Tomas"
            $user.Age | Should -Be 27
        }
    }

    Context "tests split up via BeforeEach" {
        BeforeEach {
            $user = Get-User
        }

        It "user should not be null" {
            $user | Should -Not -BeNullOrEmpty 
        }

        It "user should be correct" {
            $user.Name | Should -Be "Jakub"
        }

        It "user age should be ok" {
            $user.Age | Should -Be 31
        }
    }

    Context "tests case parameters via -TestCases" {
        BeforeEach {
            $user = Get-User
        }

        It "user should be correct" -TestCases @(
            @{Name = "Jakub" }
        ) {
            $user.Name | Should -Be $name
        }

        It "user age should be <Age>" -TestCases @(
            @{Age = 31 }
            @{Age = 27 }
        ) {
            $user.Age | Should -Be $Age
        }
    }
}