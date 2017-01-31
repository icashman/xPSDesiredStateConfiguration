﻿$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

# Import CommonTestHelper for Enter-DscResourceTestEnvironment, Exit-DscResourceTestEnvironment
$script:testsFolderFilePath = Split-Path $PSScriptRoot -Parent
$script:commonTestHelperFilePath = Join-Path -Path $testsFolderFilePath -ChildPath 'CommonTestHelper.psm1'
Import-Module -Name $commonTestHelperFilePath

$script:testEnvironment = Enter-DscResourceTestEnvironment `
    -DscResourceModuleName 'xPSDesiredStateConfiguration' `
    -DscResourceName 'MSFT_xEnvironmentResource' `
    -TestType 'Unit'

try
{
    InModuleScope 'MSFT_xEnvironmentResource' {
        # Mock objects
        $script:mockEnvironmentVarName = 'PATH'
        $script:mockEnvironmentVarInvalidName = 'Invalid'

        $script:mockEnvironmentVar = @{
            PATH = 'mock path for testing'
        }

        Describe 'xEnvironmentResource\Get-TargetResource' {
            Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith {
                if ($Name -eq $script:mockEnvironmentVarName)
                {
                    return $script:mockEnvironmentVar
                }
                else
                {
                    return $null
                }
            }

            Mock -CommandName Get-ProcessEnvironmentVariable -MockWith {
                if ($Name -eq $script:mockEnvironmentVarName)
                {
                    return $script:mockEnvironmentVar.PATH
                }
                else
                {
                    return $null
                }
            }

            Context 'Environment variable exists Both Targets' {
                $getTargetResourceResult = Get-TargetResource -Name $script:mockEnvironmentVarName

                It 'Should retrieve the expanded environment variable object' {
                    Assert-MockCalled -CommandName Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                }

                It 'Should return a hashtable' {
                    $getTargetResourceResult -is [Hashtable] | Should Be $true
                }

                It 'Should return the environment variable name' {
                    $getTargetResourceResult.Name | Should Be $script:mockEnvironmentVarName
                }

                It 'Should return the environment variable Ensure state as Present' {
                    $getTargetResourceResult.Ensure | Should Be 'Present'
                }

                It 'Should return the value of the environment variable' {
                    $getTargetResourceResult.Value | Should Be $script:mockEnvironmentVar.$script:mockEnvironmentVarName
                }
            }

            Context 'Environment variable does not exist Both Targets' {
                $getTargetResourceResult = Get-TargetResource -Name $script:mockEnvironmentVarInvalidName

                It 'Should retrieve the expanded environment variable object' {
                    Assert-MockCalled -CommandName Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                }

                It 'Should return a hashtable' {
                    $getTargetResourceResult -is [Hashtable] | Should Be $true
                }

                It 'Should return the environment variable name' {
                    $getTargetResourceResult.Name | Should Be $script:mockEnvironmentVarInvalidName
                }

                It 'Should return the environment variable Ensure state as Absent' {
                    $getTargetResourceResult.Ensure | Should Be 'Absent'
                }
                
                It 'Should return Value as null' {
                    $getTargetResourceResult.Value | Should Be $null
                }
            }

            Context 'Process Environment variable exists' {
                $getTargetResourceResult = Get-TargetResource -Name $script:mockEnvironmentVarName -Target @('Process')

                It 'Should retrieve the expanded environment variable object' {
                    Assert-MockCalled -CommandName Get-ProcessEnvironmentVariable -Exactly 1 -Scope Context
                }

                It 'Should return a hashtable' {
                    $getTargetResourceResult -is [Hashtable] | Should Be $true
                }

                It 'Should return the environment variable name' {
                    $getTargetResourceResult.Name | Should Be $script:mockEnvironmentVarName
                }

                It 'Should return the environment variable Ensure state as Present' {
                    $getTargetResourceResult.Ensure | Should Be 'Present'
                }

                It 'Should return the value of the environment variable' {
                    $getTargetResourceResult.Value | Should Be $script:mockEnvironmentVar.$script:mockEnvironmentVarName
                }
            }

            Context 'Process Environment variable does not exist' {
                $getTargetResourceResult = Get-TargetResource -Name $script:mockEnvironmentVarInvalidName -Target @('Process')

                It 'Should retrieve the expanded environment variable object' {
                    Assert-MockCalled -CommandName Get-ProcessEnvironmentVariable -Exactly 1 -Scope Context
                }

                It 'Should return a hashtable' {
                    $getTargetResourceResult -is [Hashtable] | Should Be $true
                }

                It 'Should return the environment variable name' {
                    $getTargetResourceResult.Name | Should Be $script:mockEnvironmentVarInvalidName
                }

                It 'Should return the environment variable Ensure state as Absent' {
                    $getTargetResourceResult.Ensure | Should Be 'Absent'
                }
                
                It 'Should return Value as null' {
                    $getTargetResourceResult.Value | Should Be $null
                }
            }

            Context 'Machine Environment variable exists' {
                $getTargetResourceResult = Get-TargetResource -Name $script:mockEnvironmentVarName -Target @('Machine')

                It 'Should retrieve the expanded environment variable object' {
                    Assert-MockCalled -CommandName Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                }

                It 'Should return a hashtable' {
                    $getTargetResourceResult -is [Hashtable] | Should Be $true
                }

                It 'Should return the environment variable name' {
                    $getTargetResourceResult.Name | Should Be $script:mockEnvironmentVarName
                }

                It 'Should return the environment variable Ensure state as Present' {
                    $getTargetResourceResult.Ensure | Should Be 'Present'
                }

                It 'Should return the value of the environment variable' {
                    $getTargetResourceResult.Value | Should Be $script:mockEnvironmentVar.$script:mockEnvironmentVarName
                }
            }

            Context 'Machine Environment variable does not exist' {
                $getTargetResourceResult = Get-TargetResource -Name $script:mockEnvironmentVarInvalidName -Target @('Machine')

                It 'Should retrieve the expanded environment variable object' {
                    Assert-MockCalled -CommandName Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                }

                It 'Should return a hashtable' {
                    $getTargetResourceResult -is [Hashtable] | Should Be $true
                }

                It 'Should return the environment variable name' {
                    $getTargetResourceResult.Name | Should Be $script:mockEnvironmentVarInvalidName
                }

                It 'Should return the environment variable Ensure state as Absent' {
                    $getTargetResourceResult.Ensure | Should Be 'Absent'
                }
                
                It 'Should return Value as null' {
                    $getTargetResourceResult.Value | Should Be $null
                }
            }
        }

        Describe 'xEnvironmentResource\Set-TargetResource - Both Targets' {
            Context 'Add new environment variable without Path and item properties not present' {
                $newPathValue = 'new path value'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $null }
                Mock -CommandName Get-ItemProperty -MockWith { return $null }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue } | Should Not Throw
                }
                
                It 'Should have set the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $newPathValue
                }

                It 'Should have called the correct mocks to set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 2 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Add new environment variable with Path and item properties present' {
                $newPathValue = 'new path value2'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $null }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Path $true } | Should Not Throw
                }
                
                It 'Should have set the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $newPathValue
                }

                It 'Should have called the correct mocks to set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Add new environment variable with no value specified' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $null }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }

                It 'Should throw an exception' {
                    {
                        Set-TargetResource -Name $script:mockEnvironmentVarName -Path $true -Ensure 'Present'
                    } | Should Throw ($script:localizedData.CannotSetValueToEmpty -f $script:mockEnvironmentVarName)
                }
            }

            Context 'Update environment variable but no Value specified' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return 'mock environment variable' }
                Mock -CommandName Set-EnvironmentVariable -MockWith {}
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName } | Should Not Throw
                }

                It 'Should have called the correct mocks to not set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 2 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Update environment variable without Path and Value given is the value already set' {
                $newPathValue = 'new path value2'
                $script:mockEnvironmentVar.PATH = $newPathValue
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = 'bad value' }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue } | Should Not Throw
                }
                
                It 'Should not have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $newPathValue
                }

                It 'Should have called the correct mocks to not set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 2 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Update environment variable without Path and new Value passed in' {
                $newPathValue = 'new path value3'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue } | Should Not Throw
                }
                
                It 'Should have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $newPathValue
                }

                It 'Should have called the correct mocks to set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 2 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Update environment variable with Path and invalid Value (;) passed in' {
                $newPathValue = ';'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Path $true } | Should Not Throw
                }
                
                It 'Should not have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Not Be $newPathValue
                }

                It 'Should have called the correct mocks to not set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Update environment variable with Path and invalid Value ( ) passed in' {
                $newPathValue = '    '
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Path $true } | Should Not Throw
                }
                
                It 'Should not have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Not Be $newPathValue
                }

                It 'Should have called the correct mocks to not set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Update environment variable with new Path and valid Value passed in' {
                $newPathValue = 'new path value 4'
                $newFullPathValue = ($script:mockEnvironmentVar.PATH +';' + $newPathValue)
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newFullPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Path $true } | Should Not Throw
                }
                
                It 'Should have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $newFullPathValue
                }

                It 'Should have called the correct mocks to set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 2 -Scope Context
                }
            }

            Context 'Update environment variable with Value that the environment variable is already set to' {
                $oldPathValue = $script:mockEnvironmentVar.PATH
                $newPathValue = 'new path value 5'
                $newFullPathValue = ($script:mockEnvironmentVar.PATH +';' + $newPathValue)
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newFullPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $oldPathValue -Path $true } | Should Not Throw
                }
                
                It 'Should not have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $oldPathValue
                }

                It 'Should have called the correct mocks to not set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable that is already removed' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $null }
                Mock -CommandName Get-ItemProperty -MockWith { return $null }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Ensure 'Absent' } | Should Not Throw
                }

                It 'Should have called the correct mocks to not remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 2 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with no Value specified' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Test-PathInPathList -MockWith { return $false }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Ensure 'Absent' -Path $true } | Should Not Throw
                }

                It 'Should have called the correct mocks to remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathList -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with Value specified and Path set to false' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Test-PathInPathList -MockWith { return $false }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName `
                                         -Value 'mockNewValue' `
                                         -Ensure 'Absent' `
                                         -Path $false 
                    } | Should Not Throw
                }

                It 'Should have called the correct mocks to remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 2 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathList -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with Value set to semicolen (;) and Path set to true' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Test-PathInPathList -MockWith { return $false }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName `
                                         -Value ';' `
                                         -Ensure 'Absent' `
                                         -Path $true
                    } | Should Not Throw
                }

                It 'Should have called the correct mocks to not remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Test-PathInPathList -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with Value set to value not in path and Path set to true' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Set-EnvironmentVariable -MockWith {}
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName `
                                         -Value 'nonExistentPath' `
                                         -Ensure 'Absent' `
                                         -Path $true
                    } | Should Not Throw
                }

                It 'Should have called the correct mocks to not remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with Value set to full path value that the environment var is already set to' {
                $pathToRemove = $script:mockEnvironmentVar.PATH
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Set-EnvironmentVariable -MockWith {}
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName `
                                         -Value $pathToRemove `
                                         -Ensure 'Absent' `
                                         -Path $true
                    } | Should Not Throw
                }

                It 'Should have called the correct mocks to remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 2 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with Value set to a path value that the environment variable contains' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $pathToRemove = 'path3'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Set-EnvironmentVariable -MockWith {}
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName `
                                         -Value $pathToRemove `
                                         -Ensure 'Absent' `
                                         -Path $true
                    } | Should Not Throw
                }

                It 'Should have called the correct mocks to set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 2 -Scope Context
                }
            }
        }

        Describe 'xEnvironmentResource\Set-TargetResource - Target set to Process' {
            Context 'Add new environment variable without Path and item properties not present' {
                $newPathValue = 'new path value'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $null }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Target @('Process') } | Should Not Throw
                }
                
                It 'Should have set the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $newPathValue
                }

                It 'Should have called the correct mocks to set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Add new environment variable with Path and item properties present' {
                $newPathValue = 'new path value2'
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Path $true -Target @('Process') } | Should Not Throw
                }
                
                It 'Should have set the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $newPathValue
                }

                It 'Should have called the correct mocks to set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Add new environment variable with no value specified' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $null }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }

                It 'Should throw an exception' {
                    {
                        Set-TargetResource -Name $script:mockEnvironmentVarName -Path $true -Ensure 'Present' -Target @('Process')
                    } | Should Throw ($script:localizedData.CannotSetValueToEmpty -f $script:mockEnvironmentVarName)
                }
            }

            Context 'Update environment variable but no Value specified' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return 'mock environment variable' }
                Mock -CommandName Set-EnvironmentVariable -MockWith {}
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Target @('Process') } | Should Not Throw
                }

                It 'Should have called the correct mocks to not set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Update environment variable without Path and Value given is the value already set' {
                $newPathValue = 'new path value2'
                $script:mockEnvironmentVar.PATH = $newPathValue
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = 'bad value' }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Target @('Process') } | Should Not Throw
                }
                
                It 'Should not have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $newPathValue
                }

                It 'Should have called the correct mocks to not set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Update environment variable without Path and new Value passed in' {
                $newPathValue = 'new path value3'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Target @('Process') } | Should Not Throw
                }
                
                It 'Should have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $newPathValue
                }

                It 'Should have called the correct mocks to set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Update environment variable with Path and invalid Value (;) passed in' {
                $newPathValue = ';'
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Path $true -Target @('Process') } | Should Not Throw
                }
                
                It 'Should not have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Not Be $newPathValue
                }

                It 'Should have called the correct mocks to not set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Update environment variable with Path and invalid Value ( ) passed in' {
                $newPathValue = '    '
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Path $true -Target @('Process') } | Should Not Throw
                }
                
                It 'Should not have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Not Be $newPathValue
                }

                It 'Should have called the correct mocks to not set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Update environment variable with new Path and valid Value passed in' {
                $newPathValue = 'new path value 4'
                $newFullPathValue = ($script:mockEnvironmentVar.PATH +';' + $newPathValue)
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newFullPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Path $true -Target @('Process') } | Should Not Throw
                }
                
                It 'Should have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $newFullPathValue
                }

                It 'Should have called the correct mocks to set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Update environment variable with Value that the environment variable is already set to' {
                $oldPathValue = $script:mockEnvironmentVar.PATH
                $newPathValue = 'new path value 5'
                $newFullPathValue = ($script:mockEnvironmentVar.PATH +';' + $newPathValue)
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newFullPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $oldPathValue -Path $true -Target @('Process') } | Should Not Throw
                }
                
                It 'Should not have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $oldPathValue
                }

                It 'Should have called the correct mocks to not set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable that is already removed' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $null }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Ensure 'Absent' -Target @('Process') } | Should Not Throw
                }

                It 'Should have called the correct mocks to not remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with no Value specified' {
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Test-PathInPathList -MockWith { return $false }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Ensure 'Absent' -Path $true -Target @('Process') } | Should Not Throw
                }

                It 'Should have called the correct mocks to remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathList -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with Value specified and Path set to false' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Test-PathInPathList -MockWith { return $false }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName `
                                         -Value 'mockNewValue' `
                                         -Ensure 'Absent' `
                                         -Path $false `
                                         -Target @('Process') 
                    } | Should Not Throw
                }

                It 'Should have called the correct mocks to remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathList -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with Value set to semicolen (;) and Path set to true' {
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Test-PathInPathList -MockWith { return $false }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName `
                                         -Value ';' `
                                         -Ensure 'Absent' `
                                         -Path $true `
                                         -Target @('Process')
                    } | Should Not Throw
                }

                It 'Should have called the correct mocks to not remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Test-PathInPathList -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with Value set to value not in path and Path set to true' {
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Set-EnvironmentVariable -MockWith {}
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName `
                                         -Value 'nonExistentPath' `
                                         -Ensure 'Absent' `
                                         -Path $true `
                                         -Target @('Process')
                    } | Should Not Throw
                }

                It 'Should have called the correct mocks to not remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with Value set to full path value that the environment var is already set to' {
                $pathToRemove = $script:mockEnvironmentVar.PATH
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Set-EnvironmentVariable -MockWith {}
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName `
                                         -Value $pathToRemove `
                                         -Ensure 'Absent' `
                                         -Path $true `
                                         -Target @('Process')
                    } | Should Not Throw
                }

                It 'Should have called the correct mocks to remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with Value set to a path value that the environment variable contains' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $pathToRemove = 'path3'
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Set-EnvironmentVariable -MockWith {}
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName `
                                         -Value $pathToRemove `
                                         -Ensure 'Absent' `
                                         -Path $true `
                                         -Target @('Process')
                    } | Should Not Throw
                }

                It 'Should have called the correct mocks to set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }
        }

        Describe 'xEnvironmentResource\Set-TargetResource - Target set to Machine' {
            Context 'Add new environment variable without Path and item properties not present' {
                $newPathValue = 'new path value'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $null }
                Mock -CommandName Get-ItemProperty -MockWith { return $null }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Target @('Machine') } | Should Not Throw
                }
                
                It 'Should have set the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $newPathValue
                }

                It 'Should have called the correct mocks to set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Add new environment variable with Path and item properties present' {
                $newPathValue = 'new path value2'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $null }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Path $true -Target @('Machine') } | Should Not Throw
                }
                
                It 'Should have set the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $newPathValue
                }

                It 'Should have called the correct mocks to set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Add new environment variable with no value specified' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $null }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }

                It 'Should throw an exception' {
                    {
                        Set-TargetResource -Name $script:mockEnvironmentVarName -Path $true -Ensure 'Present' -Target @('Machine')
                    } | Should Throw ($script:localizedData.CannotSetValueToEmpty -f $script:mockEnvironmentVarName)
                }
            }

            Context 'Update environment variable but no Value specified' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return 'mock environment variable' }
                Mock -CommandName Set-EnvironmentVariable -MockWith {}
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Target @('Machine') } | Should Not Throw
                }

                It 'Should have called the correct mocks to not set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Update environment variable without Path and Value given is the value already set' {
                $newPathValue = 'new path value2'
                $script:mockEnvironmentVar.PATH = $newPathValue
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = 'bad value' }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Target @('Machine') } | Should Not Throw
                }
                
                It 'Should not have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $newPathValue
                }

                It 'Should have called the correct mocks to not set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Update environment variable without Path and new Value passed in' {
                $newPathValue = 'new path value3'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Target @('Machine') } | Should Not Throw
                }
                
                It 'Should have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $newPathValue
                }

                It 'Should have called the correct mocks to set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Update environment variable with Path and invalid Value (;) passed in' {
                $newPathValue = ';'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Path $true -Target @('Machine') } | Should Not Throw
                }
                
                It 'Should not have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Not Be $newPathValue
                }

                It 'Should have called the correct mocks to not set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Update environment variable with Path and invalid Value ( ) passed in' {
                $newPathValue = '    '
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Path $true -Target @('Machine') } | Should Not Throw
                }
                
                It 'Should not have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Not Be $newPathValue
                }

                It 'Should have called the correct mocks to not set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Update environment variable with new Path and valid Value passed in' {
                $newPathValue = 'new path value 4'
                $newFullPathValue = ($script:mockEnvironmentVar.PATH +';' + $newPathValue)
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newFullPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $newPathValue -Path $true -Target @('Machine') } | Should Not Throw
                }
                
                It 'Should have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $newFullPathValue
                }

                It 'Should have called the correct mocks to set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Update environment variable with Value that the environment variable is already set to' {
                $oldPathValue = $script:mockEnvironmentVar.PATH
                $newPathValue = 'new path value 5'
                $newFullPathValue = ($script:mockEnvironmentVar.PATH +';' + $newPathValue)
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Set-EnvironmentVariable -MockWith { $script:mockEnvironmentVar.PATH = $newFullPathValue }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Value $oldPathValue -Path $true -Target @('Machine') } | Should Not Throw
                }
                
                It 'Should not have updated the mock variable value' {
                    $script:mockEnvironmentVar.PATH | Should Be $oldPathValue
                }

                It 'Should have called the correct mocks to not set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable that is already removed' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $null }
                Mock -CommandName Get-ItemProperty -MockWith { return $null }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Ensure 'Absent' -Target @('Machine') } | Should Not Throw
                }

                It 'Should have called the correct mocks to not remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with no Value specified' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Test-PathInPathList -MockWith { return $false }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName -Ensure 'Absent' -Path $true -Target @('Machine') } | Should Not Throw
                }

                It 'Should have called the correct mocks to remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathList -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with Value specified and Path set to false' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Test-PathInPathList -MockWith { return $false }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName `
                                         -Value 'mockNewValue' `
                                         -Ensure 'Absent' `
                                         -Path $false `
                                         -Target @('Machine')
                    } | Should Not Throw
                }

                It 'Should have called the correct mocks to remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathList -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with Value set to semicolen (;) and Path set to true' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Test-PathInPathList -MockWith { return $false }
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName `
                                         -Value ';' `
                                         -Ensure 'Absent' `
                                         -Path $true `
                                         -Target @('Machine')
                    } | Should Not Throw
                }

                It 'Should have called the correct mocks to not remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Test-PathInPathList -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with Value set to value not in path and Path set to true' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Set-EnvironmentVariable -MockWith {}
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName `
                                         -Value 'nonExistentPath' `
                                         -Ensure 'Absent' `
                                         -Path $true `
                                         -Target @('Machine')
                    } | Should Not Throw
                }

                It 'Should have called the correct mocks to not remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with Value set to full path value that the environment var is already set to' {
                $pathToRemove = $script:mockEnvironmentVar.PATH
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Set-EnvironmentVariable -MockWith {}
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName `
                                         -Value $pathToRemove `
                                         -Ensure 'Absent' `
                                         -Path $true `
                                         -Target @('Machine')
                    } | Should Not Throw
                }

                It 'Should have called the correct mocks to remove the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Remove environment variable with Value set to a path value that the environment variable contains' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $pathToRemove = 'path3'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Remove-EnvironmentVariable -MockWith {}
                Mock -CommandName Set-EnvironmentVariable -MockWith {}
                
                It 'Should not throw an exception' {
                    { Set-TargetResource -Name $script:mockEnvironmentVarName `
                                         -Value $pathToRemove `
                                         -Ensure 'Absent' `
                                         -Path $true `
                                         -Target @('Machine')
                    } | Should Not Throw
                }

                It 'Should have called the correct mocks to set the environment variable' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Remove-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Set-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }
        }

        Describe 'xEnvironmentResource\Test-TargetResource - Both Targets' {
            Context 'Ensure set to Present and environment variable not found' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $null }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Ensure 'Present' `
                                                                    -Path $true
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Present and value not specified' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Ensure 'Present' `
                                                                    -Path $true
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Present and Path set to false with incorrect value' {
                $expectedValue = 'wrongExpectedValue'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $false
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 2 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Present and Path set to false with correct value' {
                $expectedValue = $script:mockEnvironmentVar.PATH
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $false
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 2 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Present, Path set to true and Value contains all paths set in environment variable' {
                $expectedValue = $script:mockEnvironmentVar.PATH
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $true
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Ensure set to Present, Path set to true, and Value is set in environment variable' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $expectedValue = 'path3;path2'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $true
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Ensure set to Present, Path set to true, and not all paths in Value are set in machine' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $expectedValue = 'path3;path4;path5'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $expectedValue }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $true
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }
            
            Context 'Ensure set to Present, Path set to true, and not all paths in Value are set in process' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $expectedValue = @{ PATH = 'path3;path4;path5' }
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $expectedValue }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $true
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Ensure set to Absent and environment variable not found' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $null }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Ensure 'Absent' `
                                                                    -Path $true
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }
            
            Context 'Ensure set to Absent and value not specified' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Ensure 'Absent' `
                                                                    -Path $true
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }
            
            Context 'Ensure set to Absent and Path set to false with non-existent value' {
                $expectedValue = 'nonExistentExpectedValue'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Absent' `
                                                                    -Path $false
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 2 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Absent and Path set to false with existent value' {
                $expectedValue = $script:mockEnvironmentVar.PATH
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Absent' `
                                                                    -Path $false
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 2 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Absent, Path set to true, and Value is set in machine environment variable' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $nonExistentValue = @{ PATH = 'path5;path6;path7' }
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $nonExistentValue }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                
                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $nonExistentValue.PATH `
                                                                    -Ensure 'Absent' `
                                                                    -Path $true
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context                   
                }
            }

            Context 'Ensure set to Absent, Path set to true, and Value is set in process environment variable' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $nonExistentValue = 'path5;path6;path7'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $nonExistentValue }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $nonExistentValue `
                                                                    -Ensure 'Absent' `
                                                                    -Path $true
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Ensure set to Absent, Path set to true, and none of the paths in Value are set in environment variable' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $false }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value 'nonExistentValue' `
                                                                    -Ensure 'Absent' `
                                                                    -Path $true
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 2 -Scope Context
                }
            }
        }

        Describe 'xEnvironmentResource\Test-TargetResource - Target set to Process' {
            Context 'Ensure set to Present and environment variable not found' {
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Ensure 'Present' `
                                                                    -Path $true `
                                                                    -Target @('Process')
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Present and value not specified' {
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Ensure 'Present' `
                                                                    -Path $true `
                                                                    -Target @('Process')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Present and Path set to false with incorrect value' {
                $expectedValue = 'wrongExpectedValue'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $false `
                                                                    -Target @('Process')
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Present and Path set to false with correct value' {
                $expectedValue = $script:mockEnvironmentVar.PATH
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $false `
                                                                    -Target @('Process')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Present, Path set to true and Value contains all paths set in environment variable' {
                $expectedValue = $script:mockEnvironmentVar.PATH
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $true `
                                                                    -Target @('Process')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Ensure set to Present, Path set to true, and Value is set in environment variable' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $expectedValue = 'path3;path2'
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $true `
                                                                    -Target @('Process')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Ensure set to Present, Path set to true, and not all paths in Value are set in machine' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $expectedValue = 'path3;path4;path5'
                Mock -CommandName Get-EnvironmentVariable -MockWith {
                    if ($Target -eq 'Machine')
                    {
                        return $script:mockEnvironmentVar.PATH
                    }
                    else
                    {
                        return $expectedValue
                    }
                }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $true `
                                                                    -Target @('Process')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }
            
            Context 'Ensure set to Present, Path set to true, and not all paths in Value are set in process' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $expectedValue = 'path3;path4;path5'
                Mock -CommandName Get-EnvironmentVariable -MockWith {
                    if ($Target -eq 'Machine')
                    {
                        return $expectedValue
                    }
                    else
                    {
                        return $script:mockEnvironmentVar.PATH
                    }
                }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $true `
                                                                    -Target @('Process')
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Ensure set to Absent and environment variable not found' {
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Ensure 'Absent' `
                                                                    -Path $true `
                                                                    -Target @('Process')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }
            
            Context 'Ensure set to Absent and value not specified' {
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Ensure 'Absent' `
                                                                    -Path $true `
                                                                    -Target @('Process')
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }
            
            Context 'Ensure set to Absent and Path set to false with non-existent value' {
                $expectedValue = 'nonExistentExpectedValue'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Absent' `
                                                                    -Path $false `
                                                                    -Target @('Process')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Absent and Path set to false with existent value' {
                $expectedValue = $script:mockEnvironmentVar.PATH
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Absent' `
                                                                    -Path $false `
                                                                    -Target @('Process')
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Absent, Path set to true, and Value is set in machine environment variable' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $existentValue = 'path5;path6;path7'
                Mock -CommandName Get-EnvironmentVariable -MockWith {
                    if ($Target -eq 'Machine')
                    {
                        return $existentValue
                    }
                    else
                    {
                        return $script:mockEnvironmentVar.PATH
                    }
                }
                
                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $existentValue `
                                                                    -Ensure 'Absent' `
                                                                    -Path $true `
                                                                    -Target @('Process')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context                   
                }
            }

            Context 'Ensure set to Absent, Path set to true, and Value is set in process environment variable' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $existentValue = 'path5;path6;path7'
                Mock -CommandName Get-EnvironmentVariable -MockWith {
                    if ($Target -eq 'Machine')
                    {
                        return $script:mockEnvironmentVar.PATH
                    }
                    else
                    {
                        return $existentValue
                    }
                }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $existentValue `
                                                                    -Ensure 'Absent' `
                                                                    -Path $true `
                                                                    -Target @('Process')
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                }
            }

            Context 'Ensure set to Absent, Path set to true, and none of the paths in Value are set in environment variable' {
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $false }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value 'nonExistentValue' `
                                                                    -Ensure 'Absent' `
                                                                    -Path $true `
                                                                    -Target @('Process')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 1 -Scope Context
                }
            }
        }

        Describe 'xEnvironmentResource\Test-TargetResource - Target set to Machine' {
            Context 'Ensure set to Present and environment variable not found' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $null }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Ensure 'Present' `
                                                                    -Path $true `
                                                                    -Target @('Machine')
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Present and value not specified' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Ensure 'Present' `
                                                                    -Path $true `
                                                                    -Target @('Machine')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Present and Path set to false with incorrect value' {
                $expectedValue = 'wrongExpectedValue'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $false `
                                                                    -Target @('Machine')
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Present and Path set to false with correct value' {
                $expectedValue = $script:mockEnvironmentVar.PATH
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $false `
                                                                    -Target @('Machine')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Present, Path set to true and Value contains all paths set in environment variable' {
                $expectedValue = $script:mockEnvironmentVar.PATH
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $true `
                                                                    -Target @('Machine')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Present, Path set to true, and Value is set in environment variable' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $expectedValue = 'path3;path2'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $true `
                                                                    -Target @('Machine')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Present, Path set to true, and not all paths in Value are set in machine' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $expectedValue = 'path3;path4;path5'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $expectedValue }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Present' `
                                                                    -Path $true `
                                                                    -Target @('Machine')
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }
            
            Context 'Ensure set to Present, Path set to true, and not all paths in Value are set in process' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $expectedValue = @{ PATH = 'path3;path4;path5' }
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $expectedValue }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue.PATH `
                                                                    -Ensure 'Present' `
                                                                    -Path $true `
                                                                    -Target @('Machine')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Absent and environment variable not found' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $null }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $null }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Ensure 'Absent' `
                                                                    -Path $true `
                                                                    -Target @('Machine')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }
            
            Context 'Ensure set to Absent and value not specified' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Ensure 'Absent' `
                                                                    -Path $true `
                                                                    -Target @('Machine')
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }
            
            Context 'Ensure set to Absent and Path set to false with non-existent value' {
                $expectedValue = 'nonExistentExpectedValue'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Absent' `
                                                                    -Path $false `
                                                                    -Target @('Machine')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Absent and Path set to false with existent value' {
                $expectedValue = $script:mockEnvironmentVar.PATH
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-ItemProperty -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $true }

                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $expectedValue `
                                                                    -Ensure 'Absent' `
                                                                    -Path $false `
                                                                    -Target @('Machine')
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 0 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 1 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Absent, Path set to true, and Value is set in machine environment variable' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $nonExistentValue = @{ PATH = 'path5;path6;path7' }
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $nonExistentValue }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                
                It 'Should return false' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $nonExistentValue.PATH `
                                                                    -Ensure 'Absent' `
                                                                    -Path $true `
                                                                    -Target @('Machine')
                    $testTargetResourceResult | Should Be $false
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context                   
                }
            }

            Context 'Ensure set to Absent, Path set to true, and Value is set in process environment variable' {
                $script:mockEnvironmentVar.PATH = 'path1;path2;path3;path4'
                $nonExistentValue = 'path5;path6;path7'
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $nonExistentValue }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value $nonExistentValue `
                                                                    -Ensure 'Absent' `
                                                                    -Path $true `
                                                                    -Target @('Machine')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                }
            }

            Context 'Ensure set to Absent, Path set to true, and none of the paths in Value are set in environment variable' {
                Mock -CommandName Get-EnvironmentVariableWithoutExpanding -MockWith { return $script:mockEnvironmentVar }
                Mock -CommandName Get-EnvironmentVariable -MockWith { return $script:mockEnvironmentVar.PATH }
                Mock -CommandName Test-PathInPathListWithCriteria -MockWith { return $false }

                It 'Should return true' {
                    $testTargetResourceResult = Test-TargetResource -Name $script:mockEnvironmentVarName `
                                                                    -Value 'nonExistentValue' `
                                                                    -Ensure 'Absent' `
                                                                    -Path $true `
                                                                    -Target @('Machine')
                    $testTargetResourceResult | Should Be $true
                }

                It 'Should have called the correct mocks' {
                    Assert-MockCalled Get-EnvironmentVariableWithoutExpanding -Exactly 1 -Scope Context
                    Assert-MockCalled Get-EnvironmentVariable -Exactly 0 -Scope Context
                    Assert-MockCalled Test-PathInPathListWithCriteria -Exactly 1 -Scope Context
                }
            }
        }

        Describe 'xEnvironmentResource\Get-EnvironmentVariable' {
            Context 'Get Process variable' {
                $desiredValue = 'desiredValue'
                Mock -CommandName Get-ProcessEnvironmentVariable -MockWith { return $desiredValue }

                It 'Should return the correct value' {
                    $getEnvironmentVariableResult = Get-EnvironmentVariable -Name 'VariableName' `
                                                            -Target 'Process'
                    $getEnvironmentVariableResult | Should Be $desiredValue
                }
            }

            Context 'Get Machine variable' {
                Mock -CommandName Get-ItemProperty -MockWith {
                    if ($Name -eq $script:mockEnvironmentVarName)
                    {
                        return $script:mockEnvironmentVar
                    }
                    else
                    {
                        return $null
                    }
                }

                It 'Should return the correct value' {
                    $getEnvironmentVariableResult = Get-EnvironmentVariable -Name $script:mockEnvironmentVarName `
                                                            -Target 'Machine'
                    $getEnvironmentVariableResult | Should Be $script:mockEnvironmentVar.$script:mockEnvironmentVarName
                }

                It 'Should return the null when Name does not exist' {
                    $getEnvironmentVariableResult = Get-EnvironmentVariable -Name 'nonExistentName' `
                                                            -Target 'Machine'
                    $getEnvironmentVariableResult | Should Be $null
                }
            }
        }

        Describe 'xEnvironmentResource\Get-PathValueWithAddedPaths' {
            Context 'Path is updated' {
                It 'Should return the updated path value with the new path' {
                    $getPathValueWithAddedPathsResult = Get-PathValueWithAddedPaths -CurrentValue 'path1;path2;path4' `
                                                                                    -NewValue 'path3'
                    $getPathValueWithAddedPathsResult | Should Be 'path1;path2;path4;path3'
                }

                It 'Should return the updated path value with all of the new paths' {
                    $getPathValueWithAddedPathsResult = Get-PathValueWithAddedPaths -CurrentValue 'path1;path2;path4' `
                                                                                    -NewValue 'path3;path4;path5;path6;path1'
                    $getPathValueWithAddedPathsResult | Should Be 'path1;path2;path4;path3;path5;path6'
                }
            }

            Context 'Path is not updated' {
                It 'Should return $null if one path is passed in and it is already in the current value' {
                    $getPathValueWithAddedPathsResult = Get-PathValueWithAddedPaths -CurrentValue 'path1;path2;path3;path4' `
                                                                                    -NewValue 'path3'
                    $getPathValueWithAddedPathsResult | Should Be $null
                }

                It 'Should return $null if multiple paths are passed in that are already contained in current value' {
                    $getPathValueWithAddedPathsResult = Get-PathValueWithAddedPaths -CurrentValue 'path1;path2;path3;path4' `
                                                                                    -NewValue 'path3;path4;path2'
                    $getPathValueWithAddedPathsResult | Should Be $null
                }
            }
        }
        
        Describe 'xEnvironmentResource\Get-PathValueWithRemovedPaths' {
            Context 'Path is updated' {
                It 'Should return the updated path value with the specified path removed' {
                    $getPathValueWithRemovedPathsResult = Get-PathValueWithRemovedPaths -CurrentValue 'path1;path2;path4' `
                                                                                    -PathsToRemove 'path2'
                    $getPathValueWithRemovedPathsResult | Should Be 'path1;path4'
                }

                It 'Should return the updated path value with all of the specified paths removed if they were present' {
                    $getPathValueWithRemovedPathsResult = Get-PathValueWithRemovedPaths -CurrentValue 'path1;path2;path4' `
                                                                                    -PathsToRemove 'path3;path4;path5;path6;path1'
                    $getPathValueWithRemovedPathsResult | Should Be 'path2'
                }

                It 'Should return an empty string if all paths are removed' {
                    $getPathValueWithRemovedPathsResult = Get-PathValueWithRemovedPaths -CurrentValue 'path1;path2;path4' `
                                                                                    -PathsToRemove 'path2;path1;path4'
                    $getPathValueWithRemovedPathsResult | Should Be ''
                }
            }

            Context 'Path is not updated' {
                It 'Should return the original path if no paths were removed' {
                    $getPathValueWithRemovedPathsResult = Get-PathValueWithRemovedPaths -CurrentValue 'path1;path2;path3;path4' `
                                                                                    -PathsToRemove 'path5;path6;path0'
                    $getPathValueWithRemovedPathsResult | Should Be 'path1;path2;path3;path4'
                }
            }
        }

        Describe 'xEnvironmentResource\Set-EnvironmentVariable' {
            Context 'Set Process variable' {
                Mock -CommandName Set-ProcessEnvironmentVariable -MockWith {}

                It 'Should call the correct mocks' {
                    Set-EnvironmentVariable -Name $script:mockEnvironmentVarName -Target @('Process')
                    Assert-MockCalled -CommandName Set-ProcessEnvironmentVariable -Exactly 1 -Scope It
                }

                It 'Should call the correct mocks' {
                    Set-EnvironmentVariable -Name $script:mockEnvironmentVarName -Value '' -Target @('Process')
                    Assert-MockCalled -CommandName Set-ProcessEnvironmentVariable -Exactly 0 -Scope It
                }

                It 'Should call the correct mocks' {
                    Set-EnvironmentVariable -Name $script:mockEnvironmentVarName -Value 'mockValue' -Target @('Process')
                    Assert-MockCalled -CommandName Set-ProcessEnvironmentVariable -Exactly 1 -Scope It
                }
            }

            Context 'Set Machine variable' {
                It 'Should throw exception when name is too long' {
                    { Set-EnvironmentVariable -Name 'really really really long name that will not be accepted by the machine. `
                            really really really long name that will not be accepted by the machine. `
                            really really really long name that will not be accepted by the machine. `
                            really really really long name that will not be accepted by the machine. `
                            really really really long name that will not be accepted by the machine. `
                            really really really long name that will not be accepted by the machine. `
                            really really really long name that will not be accepted by the machine. `
                            really really really long name that will not be accepted by the machine. `
                            really really really long name that will not be accepted by the machine. `
                            really really really long name that will not be accepted by the machine. `
                            really really really long name that will not be accepted by the machine. `
                            really really really long name that will not be accepted by the machine. `
                            really really really long name that will not be accepted by the machine. `
                            really really really long name that will not be accepted by the machine. `
                            really really really long name that will not be accepted by the machine. `
                            really really really long name that will not be accepted by the machine.' `
                            -Target @('Machine')
                    } | Should Throw $script:localizedData.ArgumentTooLong
                }

                Mock -CommandName Set-ItemProperty -MockWith {}
                Mock -CommandName Remove-ItemProperty -MockWith {}
                Mock -CommandName Get-ItemProperty -MockWith { 
                    if ($Name -eq $script:mockEnvironmentVarName)
                    {
                        return $script:mockEnvironmentVar.$script:mockEnvironmentVarName
                    } 
                    else
                    {
                        return $null
                    }
                }

                It 'Should throw exception when environment variable cannot be found to remove' {
                    $invalidName = 'invalidName'
                    {
                        Set-EnvironmentVariable -Name $invalidName -Target @('Machine') 
                    } | Should Throw ($script:localizedData.RemoveNonExistentVarError -f $invalidName)
                }

                It 'Should throw exception when environment variable cannot be found to set' {
                    $invalidName = 'invalidName'
                    {
                        Set-EnvironmentVariable -Name $invalidName -Value 'testValue' -Target @('Machine') 
                    } | Should Throw ($script:localizedData.GetItemPropertyFailure -f $invalidName, $script:envVarRegPathMachine)
                }

                It 'Should set the environment variable if a value is passed in' {
                    Set-EnvironmentVariable -Name $script:mockEnvironmentVarName -Value 'mockValue' -Target @('Machine')

                    Assert-MockCalled -CommandName Set-ItemProperty -Exactly 1 -Scope It
                    Assert-MockCalled -CommandName Remove-ItemProperty -Exactly 0 -Scope It
                }

                It 'Should remove the environment variable if no value is passed in' {
                    Set-EnvironmentVariable -Name $script:mockEnvironmentVarName -Target @('Machine')

                    Assert-MockCalled -CommandName Set-ItemProperty -Exactly 0 -Scope It
                    Assert-MockCalled -CommandName Remove-ItemProperty -Exactly 1 -Scope It
                }
            }

            Context 'Error occurred while setting the variable' {
                $errorRecord = 'mock error record'
                Mock -CommandName Set-ProcessEnvironmentVariable -MockWith { Throw $errorRecord }

                It 'Should throw exception' {
                    $name = 'mockVariableName'
                    $value = 'mockValue'
                    { 
                        Set-EnvironmentVariable -Name $name -Value $value -Target @('Process')
                    } | Should Throw $errorRecord
                }
            }
        }
        
        Describe 'xEnvironmentResource\Test-PathInPathListWithCriteria' {
            $existingPaths = 'path1;path2;path3;path5;path6'
            Context "'Any' criteria specified" {
                It 'Should return true when path is contained in path list' {
                    $testPathInPathListWithCriteriaResult = Test-PathInPathListWithCriteria -ExistingPaths $existingPaths `
                                                                                            -QueryPaths 'path3' `
                                                                                            -FindCriteria 'Any'
                    $testPathInPathListWithCriteriaResult | Should Be $true
                }

                It 'Should return true when one of many paths is contained in path list' {
                    $testPathInPathListWithCriteriaResult = Test-PathInPathListWithCriteria -ExistingPaths $existingPaths `
                                                                                            -QueryPaths 'path0;path7;path3;path8'`
                                                                                            -FindCriteria 'Any'
                    $testPathInPathListWithCriteriaResult | Should Be $true
                }

                It 'Should return false when no path is contained in path list' {
                    $testPathInPathListWithCriteriaResult = Test-PathInPathListWithCriteria -ExistingPaths $existingPaths `
                                                                                            -QueryPaths 'path0;path7;path8;path9' `
                                                                                            -FindCriteria 'Any'
                    $testPathInPathListWithCriteriaResult | Should Be $false
                }
            }

            Context "'All' criteria specified" {
                It 'Should return true when path is contained in path list' {
                    $testPathInPathListWithCriteriaResult = Test-PathInPathListWithCriteria -ExistingPaths $existingPaths `
                                                                                            -QueryPaths 'path3' `
                                                                                            -FindCriteria 'All'
                    $testPathInPathListWithCriteriaResult | Should Be $true
                }

                It 'Should return false when path is not contained in path list' {
                    $testPathInPathListWithCriteriaResult = Test-PathInPathListWithCriteria -ExistingPaths $existingPaths `
                                                                                            -QueryPaths 'path4' `
                                                                                            -FindCriteria 'All'
                    $testPathInPathListWithCriteriaResult | Should Be $false
                }

                It 'Should return false when one of many paths is not contained in path list' {
                    $testPathInPathListWithCriteriaResult = Test-PathInPathListWithCriteria -ExistingPaths $existingPaths `
                                                                                            -QueryPaths 'path1;path2;path3;path4' `
                                                                                            -FindCriteria 'All'
                    $testPathInPathListWithCriteriaResult | Should Be $false
                }
            }
        }

        Describe 'xEnvironmentResource\Test-PathInPathList' {
            $pathList = @('path1', 'path2', 'path3', 'path5', 'path6')
            Context 'Path is in PathList' {
                It 'Should return true when path is contained in PathList' {
                    $testPathInPathListResult = Test-PathInPathList -QueryPath 'path3' `
                                                                    -PathList $pathList
                    $testPathInPathListResult | Should Be $true
                }
            }

            Context 'Path is not in PathList' {
                It 'Should return false when path is not contained in PathList' {
                    $testPathInPathListResult = Test-PathInPathList -QueryPath 'path4' `
                                                                    -PathList $pathList
                    $testPathInPathListResult | Should Be $false
                }
            }
        }

        Describe 'xEnvironmentResource\Get-EnvironmentVariableWithoutExpanding' {
            Mock -CommandName Get-KeyValue -MockWith { return $script:mockEnvironmentVar.$script:mockEnvironmentVarName }

            It 'Should return the correct value when the environment variable exists' {
                $getItemPropertyExpandedResult = Get-EnvironmentVariableWithoutExpanding -Name $script:mockEnvironmentVarName
                $getItemPropertyExpandedResult.$script:mockEnvironmentVarName | Should Be $script:mockEnvironmentVar.$script:mockEnvironmentVarName
                Assert-MockCalled -CommandName Get-KeyValue -Exactly 1 -Scope It
            }

            It 'Should return $null when the environment variable does not exist' {
                $getItemPropertyExpandedResult = Get-EnvironmentVariableWithoutExpanding -Name 'non-existentEnvironmentVariableName'
                $getItemPropertyExpandedResult | Should Be $null
                Assert-MockCalled -CommandName Get-KeyValue -Exactly 0 -Scope It
            }
        }
    }
}
finally
{
    Exit-DscResourceTestEnvironment -TestEnvironment $script:testEnvironment
}

