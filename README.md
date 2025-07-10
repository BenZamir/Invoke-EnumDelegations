# Invoke-EnumDelegations

**Invoke-EnumDelegations** is a PowerShell tool that enumerates all AWS accounts with delegated administrator permissions within your AWS Organization. It retrieves detailed metadata for each delegated account, including account name, email, status, organizational unit, tags, and the list of services for which the account has delegation enabled.


## HuntDelegations.ps
The HuntDelegations.ps1 script is designed to aid in detections by finding delegation activity.

---

##  Prerequisites

1. **AWS CLI v2** must be installed and configured on your system.
   - [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
2. You must be authenticated in the AWS CLI with an identity that has **read-only access to AWS Organizations**, such as the following permissions:
   - `organizations:ListDelegatedAdministrators`
   - `organizations:DescribeAccount`
   - `organizations:ListParents`
   - `organizations:DescribeOrganizationalUnit`
   - `organizations:ListDelegatedServicesForAccount`
   - `organizations:ListTagsForResource`

---

##  Usage

1. Open a PowerShell terminal.
2. Load the script into your session and run it:
   ```powershell
   Invoke-EnumDelegations

## License
MIT
