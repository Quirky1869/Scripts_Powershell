SDM Software GPAE-Script 1.1-- Script Module for GPAE 4.1 
Released December-2016

Install Instructions
--------------------
1. Ensure that the GPAE 4.1 installation has been completed on the machine where you're installing this script module.
2. Create a folder called SDM-GPAEScript within your module path (on PowerShell v3, this is usually under c:\windows\system32\windowspowershell\v1.0\modules. On PowerShell v4 and above, this is usually in c:\program files\WindowsPowerShell\Modules)
3. Extract the contents of the SDM-GPAEScript folder within this zip file, and copy them to the folder created in step 2 above

To load the script module, simply type:

import-module sdm-gpaescript

from PowerShell. You will then have full access to the script module cmdlets. (NOTE: Make sure you unblock the files in the script module, from Explorer or using the Unblock-File cmdlet, prior to attempting to run them, or you will be prompted for each file whenever you run one of the script cmdlets.)

NOTE: The sdm-gpaescript.psm1 module file contains a path to the GPAE DLL -- GPOSDK.DLL. It assumes that file is located in the module path under %programfiles%. If your module is located in %windir%\system32, you will have to change the path in the assembly load statement.



