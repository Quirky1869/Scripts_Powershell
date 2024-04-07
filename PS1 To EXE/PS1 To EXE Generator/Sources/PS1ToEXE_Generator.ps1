#========================================================================
#
# Tool Name	: PS1 To EXE Generator
# Author 	: Damien VAN ROBAEYS
# Date 		: 18/04/2016
# Website	: http://www.systanddeploy.com/
# Twitter	: https://twitter.com/syst_and_deploy
#
#========================================================================

[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')  				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.ComponentModel') 				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Data')           				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')        				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') 				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('PresentationCore')      				| out-null
[System.Reflection.Assembly]::LoadWithPartialName('MahApps.Metro.Controls.Dialogs')     | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')       				| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') 	| out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.dll')      | out-null  


Add-Type -AssemblyName "System.Windows.Forms"
Add-Type -AssemblyName "System.Drawing"

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

# Load MainWindow
$XamlMainWindow=LoadXml("PS1ToEXE_Generator.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

[System.Windows.Forms.Application]::EnableVisualStyles()

$browse_exe = $Form.findname("browse_exe") 
$exe_sources_textbox = $Form.findname("exe_sources_textbox") 
$exe_name = $Form.findname("exe_name") 
$icon_sources_textbox = $Form.findname("icon_sources_textbox") 
$browse_icon = $Form.findname("browse_icon") 
$Build = $Form.findname("Build") 
$Choose_ps1 = $Form.findname("Choose_ps1") 
$Winrar_Exists = $Form.findname("Winrar_Exists") 
$Winrar_version = $Form.findname("Winrar_version") 
$Computer_Archi = $Form.findname("Computer_Archi") 
$Winrar_version_ToUse = $Form.findname("Winrar_version_ToUse") 
$Tab_Control = $Form.findname("Tab_Control") 
$WinRAR_Status_img = $Form.findname("WinRAR_Status_img") 
$Requires_admin_rights = $Form.findname("Requires_admin_rights") 
$WinRAR_Link_Block = $Form.findname("WinRAR_Link_Block") 
$WinRAR_Link = $Form.findname("WinRAR_Link") 
$More_options = $Form.findname("More_options") 
$FlyOutContent = $Form.findname("FlyOutContent") 
$Set_Password = $Form.findname("Set_Password") 
$Password_Block = $Form.findname("Password_Block") 
$password_TextBox = $Form.findname("password_TextBox") 
$ps1_parameters = $Form.findname("ps1_parameters") 

$object = New-Object -comObject Shell.Application  

$openfiledialog1 = New-Object 'System.Windows.Forms.OpenFileDialog'
$openfiledialog1.DefaultExt = "ico"
$openfiledialog1.Filter = "Applications (*.ico) |*.ico"
$openfiledialog1.ShowHelp = $True
$openfiledialog1.filename = "Search for ICO files"
$openfiledialog1.title = "Select an icon"

$Choose_ps1.IsEnabled = $false
$Build.IsEnabled = $false
$exe_name.IsEnabled = $false
$exe_sources_textbox.IsEnabled = $false
$icon_sources_textbox.IsEnabled = $false														
$Requires_admin_rights.IsChecked = $False
$WinRAR_Link_Block.Visibility = "Collapsed"

$Set_Password.IsChecked = $False
$Password_Block.Visibility = "Collapsed"


$Global:Current_Folder =(get-location).path 
$Global:Conf_File = "$Current_Folder\PS1ToEXE_Generator.conf"
$Global:Temp_Conf_file = "$Current_Folder\PS1ToEXE_Generator_Temp.conf"

$User_Profile = $env:userprofile
$Global:User_Desktop = "$User_Profile\Desktop"
# $IsX64 = [Environment]::Is64BitProcess
$Program_Files_x86 = "C:\Program Files (x86)"
$IsX64 = Test-path $Program_Files_x86

$WinRAR_Download_Site = "https://www.win-rar.com/download.html?&L=0"
$WinRAR_Link.Add_Click({	
	[System.Diagnostics.Process]::Start("$WinRAR_Download_Site")
})	

If ($IsX64 -eq $true)
	{
		# Computer is running on x64 archi
		
		# Now we'll check the WinRAR version
		# Winrar x64
		$Global:Winrar_EXE_x64 = "C:\Program Files\WinRAR\WinRAR.exe"
		$Computer_Archi.Content = "x64"

		# WinRAR x86 on x64 computer
		$Global:Winrar_EXE_x86 = "C:\Program Files (x86)\WinRAR\WinRAR.exe"	
		# Check if an x64 EXE is found
		$Global:Check_If_Winrar_x64 = Test-Path $Winrar_EXE_x64
		# Check if an x86 EXE is found		
		$Global:Check_If_Winrar_x86 = Test-Path $Winrar_EXE_x86		
		
		If (($Check_If_Winrar_x64 -eq $false) -and ($Check_If_Winrar_x86 -eq $false))
		# If no x64 or x86 EXE have been found 
			{
				# [MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMessageAsync($Form, "Oops :-(", "The tool required Winrar !!!")	
				[System.Windows.Forms.MessageBox]::Show("The tool required Winrar") 
				$Winrar_Exists.Content = "WinRAR is not installed !!!"	
				$Winrar_Exists.Foreground = "Red"	
				$Winrar_Exists.Fontweight = "Bold"	
				$Winrar_version.Content = "WinRAR is not installed !!!"	
				$Winrar_version.Foreground = "Red"	
				$Winrar_version.Fontweight = "Bold"					
				$Winrar_version_ToUse.Content = "WinRAR is not installed !!!"		
				$Winrar_version_ToUse.Foreground = "Red"	
				$Winrar_version_ToUse.Fontweight = "Bold"			
				$Tab_Control.SelectedIndex = 1
				$WinRAR_Status_img.ImageSource = "WinRAR_KO.png"		
				$browse_exe.IsEnabled = $false
				$exe_sources_textbox.IsEnabled = $false
				$exe_name.IsEnabled = $false
				$Choose_ps1.IsEnabled = $false
				$browse_icon.IsEnabled = $false
				$icon_sources_textbox.IsEnabled = $false														
				$Build.IsEnabled = $false		
				$WinRAR_Link_Block.Visibility = "Visible"				
			}	

		If (($Check_If_Winrar_x64 -eq $true) -and ($Check_If_Winrar_x86 -eq $true))
		# If both x64 and x86 EXE have been found 		
			{		
				$Winrar_Exists.Content = "WinRAR is installed"
				$Winrar_Exists.Foreground = "Green"	
				$Winrar_Exists.Fontweight = "Bold"					
				$Winrar_version.Content = "Both versions x86/x64 are installed"	
				$Global:Winrar_Folder = "C:\Program Files (x86)\WinRAR"		
				$Winrar_version_ToUse.Content = "WinRAR x64"	
				$Tab_Control.SelectedIndex = 0		
				$WinRAR_Status_img.ImageSource = "WinRAR_OK.png"					
			}			

		ElseIf (($Check_If_Winrar_x64 -eq $true) -or ($Check_If_Winrar_x86 -eq $true))
			{		
				$Winrar_Exists.Content = "WinRAR is installed"
				$Winrar_Exists.Foreground = "Green"	
				$Winrar_Exists.Fontweight = "Bold"		
				$Tab_Control.SelectedIndex = 0			
				$WinRAR_Status_img.ImageSource = "WinRAR_OK.png"					
				
				If ($Check_If_Winrar_x64 -eq $true) 
					{
						$Winrar_version.Content = "x64 version is installed"	
						$Global:Winrar_Folder = "C:\Program Files\WinRAR"	
						$Winrar_version_ToUse.Content = "WinRAR x64"							
					}
				ElseIf ($Check_If_Winrar_x86 -eq $true) 
					{
						$Winrar_version.Content = "x86 version is installed"	
						$Global:Winrar_Folder = "C:\Program Files (x86)\WinRAR"		
						$Winrar_version_ToUse.Content = "WinRAR x86"											
					}			
			}				
	}
Else
	{
		# Computer is running on x86 archi
		$Global:Winrar_EXE_x86 = "C:\Program Files\WinRAR\WinRAR.exe"	
		$Computer_Archi.Content = "x86"
		
		# Check if an x86 EXE is found		
		$Global:Check_If_Winrar_x86 = Test-Path $Winrar_EXE_x86		

		If ($Check_If_Winrar_x86 -eq $false)
		# If no x86 EXE has been found 
			{
				# [MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMessageAsync($Form, "Oops :-(", "The tool required Winrar !!!")		
				[System.Windows.Forms.MessageBox]::Show("The tool required Winrar") 		
				$Winrar_Exists.Content = "WinRAR is not installed !!!"	
				$Winrar_Exists.Foreground = "Red"	
				$Winrar_Exists.Fontweight = "Bold"	
				$Winrar_version.Content = "WinRAR is not installed !!!"	
				$Winrar_version.Foreground = "Red"	
				$Winrar_version.Fontweight = "Bold"					
				$Winrar_version_ToUse.Content = "WinRAR is not installed !!!"		
				$Winrar_version_ToUse.Foreground = "Red"	
				$Winrar_version_ToUse.Fontweight = "Bold"					
				$Tab_Control.SelectedIndex = 1
				$WinRAR_Status_img.ImageSource = "WinRAR_KO.png"	
				$browse_exe.IsEnabled = $false
				$exe_sources_textbox.IsEnabled = $false
				$exe_name.IsEnabled = $false
				$Choose_ps1.IsEnabled = $false
				$browse_icon.IsEnabled = $false
				$icon_sources_textbox.IsEnabled = $false										
				$Build.IsEnabled = $false		
				$WinRAR_Link_Block.Visibility = "Visible"								
			}
		Else
			{
				$Winrar_Exists.Content = "WinRAR is installed"
				$Winrar_Exists.Foreground = "Green"	
				$Winrar_Exists.Fontweight = "Bold"					
				$Winrar_version.Content = "x86 version is installed"	
				$Global:Winrar_Folder = "C:\Program Files\WinRAR"		
				$Winrar_version_ToUse.Content = "WinRAR x86"	
				$Tab_Control.SelectedIndex = 0	
				$WinRAR_Status_img.ImageSource = "WinRAR_OK.png"					
			}		
	}

	
	
$browse_exe.Add_Click({		
	$folder = $object.BrowseForFolder(0, $message, 0, 0) 
	If ($folder -ne $null) 
		{ 		
			$global:EXE_folder = $folder.self.Path 
			$exe_sources_textbox.Text = $EXE_folder	

			$Global:Folder_name = Split-Path -leaf -path $EXE_folder			
					
			$Choose_ps1.IsEnabled = $true
			$Build.IsEnabled = $true
			$exe_name.IsEnabled = $true
					
			$Dir_EXE_Folder = get-childitem $EXE_folder -recurse
			$List_All_PS1 = $Dir_EXE_Folder | where {$_.extension -eq ".ps1"}				
			foreach ($ps1 in $List_All_PS1)
				{
					$Choose_ps1.Items.Add($ps1)	
					$Global:EXE_PS1_To_Run = $Choose_ps1.SelectedItem						
				}			
			$Choose_ps1.add_SelectionChanged({
			$Global:EXE_PS1_To_Run = $Choose_ps1.SelectedItem				
			write-host $EXE_PS1_To_Run	
			})	
		}
})	


$browse_icon.Add_Click({	
	If($openfiledialog1.ShowDialog() -eq 'OK')
		{	
			$icon_sources_textbox.Text = $openfiledialog1.FileName
			$Global:EXE_Icon_To_Set = $openfiledialog1.FileName 	
		}	
})	

$Build.Add_Click({		

	$EXE_File_Name = $exe_name.Text.ToString()	
	$Parameters = $ps1_parameters.Text.ToString()	
	
	If ($Set_Password.IsChecked -eq $true)
		{
			$Global:Password = $password_TextBox.Text.ToString()
			$Password_Status = '"' + '-p' + $Password + '"'
			# $Password_Status = '"' + "-ptoto" + '"'			
		}
	Else
		{
			$Global:Password_Status = ""
		}	
		

	If ($exe_name.Text -eq "") 
		{
			$exe_name.BorderBrush = "Red"
		}
	Else
		{
			copy-item $Conf_File $Temp_Conf_file
			# Add-Content $Temp_Conf_file "Setup=C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -sta -WindowStyle Hidden -noprofile -executionpolicy bypass -file %temp%\$EXE_PS1_To_Run"
			Add-Content $Temp_Conf_file "Setup=C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -sta -WindowStyle Hidden -noprofile -executionpolicy bypass -file %temp%\$EXE_PS1_To_Run $Parameters"
		
			If ($Requires_admin_rights.IsChecked -eq $True)
				{
					$command = "$Winrar_Folder\WinRAR.exe"				
					& $command a -ep1 -r -o+ -dh -ibck -sfx -iadm "-iicon$EXE_Icon_To_Set" "-z$Temp_Conf_file"  "$User_Desktop\$EXE_File_Name.exe" "$EXE_folder\*"
				}
			Else
				{
					$command = "$Winrar_Folder\WinRAR.exe"				
					& $command a -ep1 -r -o+ -dh -ibck -sfx $Password_Status "-iicon$EXE_Icon_To_Set" "-z$Temp_Conf_file"  "$User_Desktop\$EXE_File_Name.exe" "$EXE_folder\*"					
					# & $command a -ep1 -r -o+ -dh -ibck -sfx "-ptoto" "-iicon$EXE_Icon_To_Set" "-z$Temp_Conf_file"  "$User_Desktop\$EXE_File_Name.exe" "$EXE_folder\*"	
					# & $command a -ep1 -r -o+ -dh -ibck -sfx "-iicon$EXE_Icon_To_Set" "-z$Temp_Conf_file"  "$User_Desktop\$EXE_File_Name.exe" "$EXE_folder\*"									
				}				
			
			# -iadm: request administrative access for SFX archive
			# -iiconC: Specify the icon
			# -sfx: Create an SFX self-extracting archive
			# -IIMG: Specify a logo
			# -zC: Read the conf file
			# -r: Repair an archive
			# -ep1: Exlude bas directory from names
			# -inul: Disable error messages
			# -ibck: Run Winrar in Background
			# -y: Assume Yes on all queries

			sleep 5
			remove-item $Temp_Conf_file -force
			
			[MahApps.Metro.Controls.Dialogs.DialogManager]::ShowMessageAsync($Form, "Success :-)", "Your EXE has been created on your Desktop")		
			
		}
})





$More_options.Add_Click({	
	$FlyOutContent.IsOpen = $true  
})	



$Set_Password.Add_Click({
	If ($Set_Password.IsChecked -eq $true)
		{
			$Password_Block.Visibility = "Visible"		
		}
	Else
		{
			$Password_Block.Visibility = "Collapsed"		
		}
})	


# Show FORM
$Form.ShowDialog() | Out-Null