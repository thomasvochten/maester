# Generated on 04/16/2025 21:38:23 by .\build\orca\Update-OrcaTests.ps1

using module ".\orcaClass.psm1"

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingEmptyCatchBlock', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSPossibleIncorrectComparisonWithNull', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()




class ORCA223 : ORCACheck
{
    <#
    
        CONSTRUCTOR with Check Header Data
    
    #>

    ORCA223()
    {
        $this.Control=223
        $this.Services=[ORCAService]::MDO
        $this.Area="Microsoft Defender for Office 365 Policies"
        $this.Name="User Impersonation Action"
        $this.PassText="User impersonation action is set to move to Quarantine"
        $this.FailRecommendation="Configure user impersonation action to Quarantine"
        $this.Importance="User impersonation protection can detect spoofing of your sensitive users. Move messages that are caught using user impersonation detection to Quarantine."
        $this.ExpandResults=$True
        $this.CheckType=[CheckType]::ObjectPropertyValue
        $this.ObjectType="Antiphishing Policy"
        $this.ItemName="Setting"
        $this.DataType="Action"
        $this.ChiValue=[ORCACHI]::Medium
        $this.Links= @{
            "Microsoft 365 Defender Portal - Anti-phishing"="https://security.microsoft.com/antiphishing"
            "Recommended settings for EOP and Microsoft Defender for Office 365"="https://aka.ms/orca-atpp-docs-7"
        }
    }

    <#
    
        RESULTS
    
    #>

    GetResults($Config)
    {

        ForEach($Policy in ($Config["AntiPhishPolicy"] ))
        {

            $IsPolicyDisabled = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
            $IsPreset = $Config["PolicyStates"][$Policy.Guid.ToString()].Preset

            $EnableTargetedUserProtection = $($Policy.EnableTargetedUserProtection)
            $TargetedUserProtectionAction = $($Policy.TargetedUserProtectionAction)

            $policyname = $Config["PolicyStates"][$Policy.Guid.ToString()].Name

            # Is enabled

            $ConfigObject = [ORCACheckConfig]::new()

            $ConfigObject.Object=$policyname
            $ConfigObject.ConfigItem="EnableTargetedUserProtection"
            $ConfigObject.ConfigData=$EnableTargetedUserProtection
            $ConfigObject.ConfigDisabled = $Config["PolicyStates"][$Policy.Guid.ToString()].Disabled
            $ConfigObject.ConfigWontApply = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
            $ConfigObject.ConfigReadonly = $IsPreset
            $ConfigObject.ConfigPolicyGuid=$Policy.Guid.ToString()

            If($EnableTargetedUserProtection -eq $False)
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")
            }
            else 
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Pass")
            }
            
            $this.AddConfig($ConfigObject)

            # Action

            $ConfigObject = [ORCACheckConfig]::new()

            $ConfigObject.Object=$policyname
            $ConfigObject.ConfigItem="TargetedUserProtectionAction"
            $ConfigObject.ConfigData=$TargetedUserProtectionAction
            $ConfigObject.ConfigDisabled = $Config["PolicyStates"][$Policy.Guid.ToString()].Disabled
            $ConfigObject.ConfigWontApply = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
            $ConfigObject.ConfigReadonly = $IsPreset
            $ConfigObject.ConfigPolicyGuid=$Policy.Guid.ToString()

            If($TargetedUserProtectionAction -eq "Quarantine")
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Pass")
            }
            else 
            {
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")     
            }

            If($TargetedUserProtectionAction -eq "Delete" -or $TargetedUserProtectionAction -eq "Redirect")
            {

                $ConfigObject.SetResult([ORCAConfigLevel]::Informational,"Fail")
                $ConfigObject.InfoText = "The $($Policy.TargetedUserProtectionAction) option may impact the users ability to release emails and may impact user experience."
            }

            
            $this.AddConfig($ConfigObject)

        }

        If($Config["AnyPolicyState"][[PolicyType]::Antiphish] -eq $False)
        {

            # Check objects
            $ConfigObject = [ORCACheckConfig]::new()
            $ConfigObject.Object="No Enabled Policies"
            $ConfigObject.ConfigItem="EnableTargetedUserProtection"
            $ConfigObject.ConfigData=""
            $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")
            
            # Add config to check
            $this.AddConfig($ConfigObject)

            # Check objects
            $ConfigObject = [ORCACheckConfig]::new()
            $ConfigObject.Object="No Enabled Policies"
            $ConfigObject.ConfigItem="TargetedUserProtectionAction"
            $ConfigObject.ConfigData=""
            $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")
            
            # Add config to check
            $this.AddConfig($ConfigObject)

        }       

    }

}
