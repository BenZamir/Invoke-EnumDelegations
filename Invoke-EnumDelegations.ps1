function Invoke-EnumDelegations {
  # Get all delegated administrator account IDs
  $accountIds = aws organizations list-delegated-administrators --query 'DelegatedAdministrators[].Id' --output text |
      Out-String |
      ForEach-Object { $_ -split '\s+' } |
      Where-Object { $_ -ne "" }
  
  foreach ($accountId in $accountIds) {
      Write-Host "` Delegated Account ID: $accountId"
  
      # Describe Account
      try {
          $accountDetail = aws organizations describe-account --account-id $accountId | ConvertFrom-Json
          $account = $accountDetail.Account
          Write-Host "    Name: $($account.Name)"
          Write-Host "    Email: $($account.Email)"
          Write-Host "    Status: $($account.Status)"
          Write-Host "    Joined: $($account.JoinedTimestamp)"
      } catch {
          Write-Host "   [!] Could not retrieve account details ($($_.Exception.Message))"
      }
  
      # Get OU Info
      try {
          $parent = aws organizations list-parents --child-id $accountId | ConvertFrom-Json
          $parentType = $parent.Parents[0].Type
          $parentId = $parent.Parents[0].Id
  
          if ($parentType -eq "ORGANIZATIONAL_UNIT") {
              $ou = aws organizations describe-organizational-unit --organizational-unit-id $parentId | ConvertFrom-Json
              Write-Host "    OU: $($ou.OrganizationalUnit.Name)"
          } else {
              Write-Host "    Root: Account is directly under the root"
          }
      } catch {
          Write-Host "   [!] Could not retrieve OU info ($($_.Exception.Message))"
      }
  
      # Get Tags
      try {
          $tags = aws organizations list-tags-for-resource --resource-id $accountId | ConvertFrom-Json
          if ($tags.Tags.Count -gt 0) {
              Write-Host "    Tags:"
              foreach ($tag in $tags.Tags) {
                  Write-Host "      - $($tag.Key): $($tag.Value)"
              }
          }
      } catch {
          Write-Host "[!] Could not retrieve tags ($($_.Exception.Message))"
      }
  
      # Delegated Services
      try {
          Write-Host "   [+] Delegated Services:"
          aws organizations list-delegated-services-for-account `
              --account-id $accountId `
              --query 'DelegatedServices[*].{Service:ServicePrincipal,Date:DelegationEnabledDate}' `
              --output table
      } catch {
          Write-Host "   [!] Could not retrieve delegated services ($($_.Exception.Message))"
      }
  }
}
