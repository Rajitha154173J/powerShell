#Name of the server
$Server="localhost"

#Name of the service
$services = get-content "C:\Users\UnicornRSA\input.txt"

#set Default Service name
 if (!$services){
     $services="WebClient-Start"
 }

#$service ="WebClient"

#location to floder create
$path="C:\Users\UnicornRSA\powerShallTest"



#Get Server Cpu usage
$cpuUsage=(Get-WmiObject -ComputerName $Server -Class win32_processor | Measure-Object -Property LoadPercentage -Average | Select-Object Average).Average

#Get Memary Usage
$ComputerMemory =  Get-WmiObject -Class WIN32_OperatingSystem -ComputerName $Server
$Memory = ((($ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory)*100)/ $ComputerMemory.TotalVisibleMemorySize)

#Create Floder
$timestamp = Get-Date | foreach {$_ -replace ":", "."} | foreach {$_ -replace "/", "-"}
new-item -Name $timestamp -ItemType directory -path $path

#create File in the Floder
$filePath = $path+"\"+$timestamp
New-Item -path $filePath -type file -name "Report.txt"

#create File for service detail
New-Item -path $filePath -type file -name "service.txt"




if ($cpuUsage -ge 5 -or $Memory -ge 5 ){
    #need to note
    $To = "rajithasanjayamal0918@gmail.com"
    

    #Maintain services
    foreach ($Service in $services) {
   
            
       $detail =$Service.split("-")
       $ServiceName=$detail[0]
       $Action=$detail[1]
            
       
       
       Set-Location -Path $filePath

      #Checks if ServiceName exists and provides ServiceStatus
        function CheckMyService ($ServiceName){

	        if (Get-Service $ServiceName -ErrorAction SilentlyContinue){
	       
		        $ServiceStatus = (Get-Service -Name $ServiceName).Status
		        $ServiceName + " - " +$ServiceStatus | Add-Content 'service.txt'

	        }else{

		       "$ServiceName not found" | Add-Content 'service.txt'
	        }
        }
 
    #Checks if service exists
    if (Get-Service $ServiceName -ErrorAction SilentlyContinue){
    
    	#Condition if user wants to stop a service
	    if ($Action -eq 'Stop'){

		    if ((Get-Service -Name $ServiceName).Status -eq 'Running'){

			     $ServiceName +" is running, preparing to stop..." | Add-Content 'service.txt'
			    Get-Service -Name $ServiceName | Stop-Service -Force -ErrorAction SilentlyContinue
			    CheckMyService $ServiceName

		    }elseif ((Get-Service -Name $ServiceName).Status -eq 'Stopped'){

			  $ServiceName +" already stopped!" | Add-Content 'service.txt'

		    }else{

			$ServiceName +" - " +$ServiceStatus | Add-Content 'service.txt'
		    }
	    }
 
	    #Condition if user wants to start a service
	    elseif ($Action -eq 'Start'){

		    if ((Get-Service -Name $ServiceName).Status -eq 'Running'){

			    $ServiceName +" already running!" | Add-Content 'service.txt'

		    }elseif ((Get-Service -Name $ServiceName).Status -eq 'Stopped'){

			    $ServiceName +" is stopped, preparing to start..." | Add-Content 'service.txt'
			    Get-Service -Name $ServiceName | Start-Service -ErrorAction SilentlyContinue
			    CheckMyService $ServiceName

		    }else{

			     $ServiceName +" - "+ $ServiceStatus | Add-Content 'service.txt'
		    }
	    }
 
	    #Condition if user wants to restart a service
	    elseif ($Action -eq 'Restart'){

		    if ((Get-Service -Name $ServiceName).Status -eq 'Running'){

		        $ServiceName+ " is running, preparing to restart..."| Add-Content 'service.txt'
			    Get-Service -Name $ServiceName | Stop-Service  -Force -ErrorAction SilentlyContinue
			    Get-Service -Name $ServiceName | Start-Service -ErrorAction SilentlyContinue
			    CheckMyService $ServiceName

		    }
		    elseif ((Get-Service -Name $ServiceName).Status -eq 'Stopped'){

			    $ServiceName +" is stopped, preparing to start..." | Add-Content 'service.txt'
			    Get-Service -Name $ServiceName | Start-Service -ErrorAction SilentlyContinue
			    CheckMyService $ServiceName
		    }
	    }
 
	    #Condition if action is anything other than stop, start, restart
	    else{

		    "Action parameter is missing or invalid!" | Add-Content 'service.txt'
	    }
    }
 
    #Condition if provided ServiceName is invalid
    else{

	    "$ServiceName not found" | Add-Content 'service.txt'
    }


 }

    #note into Report.txt
    $time= "Time = "+$timestamp
    $time | Add-Content 'Report.txt'

    $cpuDetail="Cpu usage = "+$cpuUsage
    $cpuDetail | Add-Content 'Report.txt'

    $memoryDetail= "Memory usage = "+$Memory
    $memoryDetail | Add-Content 'Report.txt'

    $emailStatus= "Send email to "+$To
    $emailStatus | Add-Content 'Report.txt'

   

#Handlng Email
    $From = "cpum698@gmail.com"
    
   # $Cc = "AThirdUser@somewhere.com"
    $Attachment1 = $path+"\"+$timestamp+"\Report.txt"
    $Attachment2= $path+"\"+$timestamp+"\service.txt"
    $Subject ="Alert Email"
    $Body = $cpuDetail+"`n"+$memoryDetail+"`n"+$emailStatus
    $SMTPServer = "smtp.gmail.com"
    $SMTPPort = "587"
   

    $secpasswd = ConvertTo-SecureString "Unicorn123456#" -AsPlainText -Force
    $mycreds = New-Object System.Management.Automation.PSCredential ("cpum698@gmail.com", $secpasswd)
    Send-MailMessage -To "User01 <$To>" -From "Admin <$From>" -Subject $Subject -Body $Body -SmtpServer $SMTPServer -Port $SMTPPort -Credential $mycreds -UseSsl -Attachments ($Attachment1, $Attachment2)



}else{
    
    Set-Location -Path $filePath
    
    $time= "Time = "+$timestamp
    $time | Add-Content 'Report.txt'

    $cpuDetail="Cpu usage = "+$cpuUsage
    $cpuDetail | Add-Content 'Report.txt'

    $memoryDetail= "Memory usage = "+$Memory
    $memoryDetail | Add-Content 'Report.txt'

    "Every things are fine" | Add-Content 'Report.txt'

    "No services has been changed" | Add-Content 'service.txt'
    "Every things are fine"| Add-Content 'service.txt'
}