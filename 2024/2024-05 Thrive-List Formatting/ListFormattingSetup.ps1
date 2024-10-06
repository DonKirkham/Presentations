Clear-Host
Connect-PnPOnline https://pdslabs2.sharepoint.com/teams/lf -Interactive
$list = Get-PnPList -Identity "Work progress tracker"
$index = 2

Write-Host "Creating Columns"
Remove-PnPField -List $list -Identity "Workitem$($index)" -Force -ErrorAction SilentlyContinue
Add-PnPField -List $list -InternalName "Workitem$($index)" -DisplayName "Work item$($index)" -Type Text
$field = Get-PnPField -Identity "Title" -List $list
Set-PnPField -List $list -Identity "Workitem$($index)"  -Values @{CustomFormatter=$field.CustomFormatter}

Remove-PnPField -List $list -Identity "Priority$($index)" -Force -ErrorAction SilentlyContinue
Add-PnPField -List $list -InternalName "Priority$($index)" -DisplayName "Priority$($index)" -Type Choice -AddToAllContentTypes -Choices "Critical", "High", "Medium", "Low"
$field = Get-PnPField -Identity "Priority" -List $list
Set-PnPField -List $list -Identity "Priority$($index)"  -Values @{CustomFormatter=$field.CustomFormatter}
$field = Get-PnPField -List $list -Identity "Priority$($index)"
Set-PnPField -List $list -Identity $field.InternalName -Values @{DefaultValue = "Medium"}

Remove-PnPField -List $list -Identity "Category$($index)" -Force -ErrorAction SilentlyContinue
Add-PnPField -List $list -InternalName "Category$($index)" -DisplayName "Category$($index)" -Type MultiChoice -AddToAllContentTypes -Choices "Planning", "Design", "Engineering", "Marketing", "Research" 
$field = Get-PnPField -Identity "Category" -List $list
Set-PnPField -List $list -Identity "Category$($index)"  -Values @{CustomFormatter=$field.CustomFormatter}

Remove-PnPField -List $list -Identity "Progress$($index)" -Force -ErrorAction SilentlyContinue
Add-PnPField -List $list -InternalName "Progress$($index)" -DisplayName "Progress$($index)" -Type Choice -AddToAllContentTypes -Choices "Not started", "In progress", "Completed", "Blocked", "Behind"
$field = Get-PnPField -Identity "Progress" -List $list
Set-PnPField -List $list -Identity "Progress$($index)"  -Values @{CustomFormatter=$field.CustomFormatter}
$field = Get-PnPField -List $list -Identity "Progress$($index)"
Set-PnPField -List $list -Identity $field.InternalName -Values @{DefaultValue = "Not started" }

Remove-PnPField -List $list -Identity "Completed$($index)" -Force -ErrorAction SilentlyContinue
Add-PnPFieldFromXml -List $list -FieldXml "<Field Type='Number' DisplayName='Completed$($index)' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' Percentage='TRUE' StaticName='Completed$($index)' Name='Completed$($index)' ColName='float2' />"
$field = Get-PnPField -Identity "Completed" -List $list
Set-PnPField -List $list -Identity "Completed$($index)"  -Values @{CustomFormatter=$field.CustomFormatter}

Remove-PnPField -List $list -Identity "StartDate$($index)" -Force -ErrorAction SilentlyContinue
Add-PnPFieldFromXml -List $list -FieldXml "<Field Type='DateTime' DisplayName='Start date$($index)' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' Format='DateOnly' FriendlyDisplayFormat='Relative' StaticName='StartDate$($index)' Name='StartDate$($index)'></Field>"
$field = Get-PnPField -Identity "StartDate" -List $list
Set-PnPField -List $list -Identity "StartDate$($index)"  -Values @{CustomFormatter=$field.CustomFormatter}

Remove-PnPField -List $list -Identity "DueDate$($index)" -Force -ErrorAction SilentlyContinue
Add-PnPFieldFromXml -List $list -FieldXml "<Field Type='DateTime' DisplayName='Due date$($index)' Required='FALSE' EnforceUniqueValues='FALSE' Indexed='FALSE' Format='DateOnly' FriendlyDisplayFormat='Relative' StaticName='DueDate$($index)' Name='DueDate$($index)'></Field>"
$field = Get-PnPField -Identity "DueDate" -List $list
Set-PnPField -List $list -Identity "DueDate$($index)"  -Values @{CustomFormatter=$field.CustomFormatter}

Remove-PnPField -List $list -Identity "AssignedTo$($index)" -Force -ErrorAction SilentlyContinue
Add-PnPFieldFromXml -List $list -FieldXml "<Field DisplayName='Assigned to$($index)' Format='Dropdown' IsModern='TRUE' Name='AssignedTo$($index)' Type='User' UserDisplayOptions='NamePhoto' UserSelectionMode='0' UserSelectionScope='0' StaticName='AssignedTo$($index)'></Field>"
$field = Get-PnPField -Identity "AssignedTo" -List $list
Set-PnPField -List $list -Identity "AssignedTo$($index)"  -Values @{CustomFormatter=$field.CustomFormatter}

Remove-PnPField -List $list -Identity "Reviewers$($index)" -Force -ErrorAction SilentlyContinue
Add-PnPFieldFromXml -List $list -FieldXml "<Field DisplayName='Reviewers$($index)' Format='Dropdown' IsModern='TRUE' Name='Reviewers$($index)' Mult='TRUE' UserDisplayOptions='NamePhoto' Type='UserMulti' UserSelectionMode='PeopleOnly' UserSelectionScope='0' StaticName='Reviewers$($index)'></Field>"
$field = Get-PnPField -Identity "Reviewers" -List $list
Set-PnPField -List $list -Identity "Reviewers$($index)"  -Values @{CustomFormatter=$field.CustomFormatter}

Write-Host "`r`nCreating view: Formatting-SideBySide"
Remove-PnPView -List $list -Identity "Formatting-SideBySide" -Force
$view = 
	Add-PnPView -List $list -Title "Formatting-SideBySide" -Query "<OrderBy><FieldRef Name= 'DueDate$($index)'/></OrderBy>" -Fields "Work item", "Workitem$($index)", "Priority", "Priority$($index)", "Category", "Category$($index)", "Progress", "Progress$($index)", "Completed", "Completed$($index)", "StartDate", "StartDate$($index)", "DueDate", "DueDate$($index)", "AssignedTo", "AssignedTo$($index)", "Reviewers", "Reviewers$($index)"

Write-Host "`r`nCreating view: Formatting-Raw$($index)"
Remove-PnPView -List $list -Identity "Formatting-Raw$($index)" -Force
$view = 
	Add-PnPView -List $list -Title "Formatting-Raw$($index)" -SetAsDefault -Query "<OrderBy><FieldRef Name= 'DueDate$($index)'/></OrderBy>" -Fields "Workitem$($index)", "Priority$($index)", "Category$($index)", "Progress$($index)", "Completed$($index)", "StartDate$($index)", "DueDate$($index)", "AssignedTo$($index)", "Reviewers$($index)"

Write-Host "`r`nDeleting view: Formatting-GroupBy"
Remove-PnPView -List $list -Identity "Formatting-GroupBy" -Force
	
Write-Host "`r`nCopying values to new columns"
$ListItems = Get-PnPListItem -List $list 
ForEach ($Item in $ListItems)
{
	Write-Host "    Item: " $Item["Title"]
	$item = Set-PnPListItem -List $list -Identity $Item.Id -Values @{
		"Workitem$($index)" = $Item["Title"]; 
		"Category$($index)" = $Item["Category"]; 
		"Priority$($index)" = $Item["Priority"]; 
		"Progress$($index)" = $Item["Progress"]; 
		"Completed$($index)" = $Item["Completed"]; 
		"StartDate$($index)" = $Item["StartDate"]; 
		"DueDate$($index)" = $Item["DueDate"]; 
		"AssignedTo$($index)" = $Item.FieldValues["AssignedTo"].Email 
		"Reviewers$($index)" = $Item.FieldValues["Reviewers"].Email 
	}
}


#Read more: https://www.sharepointdiary.com/2019/05/sharepoint-online-copy-values-from-one-column-to-another-using-powershell.html#ixzz77WJC4H1M

<# Remove Fields
$index=3
Remove-PnPField -List $list -Identity "Workitem$($index)" -Force -ErrorAction SilentlyContinue
Remove-PnPField -List $list -Identity "Category$($index)" -Force -ErrorAction SilentlyContinue
Remove-PnPField -List $list -Identity "Progress$($index)" -Force -ErrorAction SilentlyContinue
Remove-PnPField -List $list -Identity "Priority$($index)" -Force -ErrorAction SilentlyContinue
Remove-PnPField -List $list -Identity "StartDate$($index)" -Force -ErrorAction SilentlyContinue
Remove-PnPField -List $list -Identity "DueDate$($index)" -Force -ErrorAction SilentlyContinue
Remove-PnPField -List $list -Identity "AssignedTo$($index)" -Force -ErrorAction SilentlyContinue
Remove-PnPView -List $list -Identity "Formatting-Raw$($index)" -Force
Remove-PnPView -List $list -Identity "Formatting$($index)" -Force
#>

