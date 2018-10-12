$filePath="C:\Users\UnicornRSA\powerShallTest"
$services = get-content "C:\Users\UnicornRSA\input.txt"


New-Item -path $filePath -type file -name "service.txt"

    if (!$services){
        $services="WebClient-Start"
    }


foreach ($Service in $services) {
   
            
       $detail =$Service.split("-")
       $ServiceName=$detail[0]
       $Action=$detail[1]
            
       
 
 Set-Location -Path $filePath

#Checks if ServiceName exists and provides ServiceStatus
    function CheckMyService ($ServiceName)
    {
	    if (Get-Service $ServiceName -ErrorAction SilentlyContinue)
	    {
		    $ServiceStatus = (Get-Service -Name $ServiceName).Status
		    $ServiceName + " - " +$ServiceStatus | Add-Content 'service.txt'
	    }
	    else
	    {
		   "$ServiceName not found" | Add-Content 'service.txt'
	    }
    }
 
    #Checks if service exists
    if (Get-Service $ServiceName -ErrorAction SilentlyContinue)
    {	#Condition if user wants to stop a service
	    if ($Action -eq 'Stop')
	    {
		    if ((Get-Service -Name $ServiceName).Status -eq 'Running')
		    {
			     $ServiceName +" is running, preparing to stop..." | Add-Content 'service.txt'
			    Get-Service -Name $ServiceName | Stop-Service -ErrorAction SilentlyContinue
			    CheckMyService $ServiceName
		    }
		    elseif ((Get-Service -Name $ServiceName).Status -eq 'Stopped')
		    {
			  $ServiceName +" already stopped!" | Add-Content 'service.txt'
		    }
		    else
		    {
			$ServiceName +" - " +$ServiceStatus | Add-Content 'service.txt'
		    }
	    }
 
	    #Condition if user wants to start a service
	    elseif ($Action -eq 'Start')
	    {
		    if ((Get-Service -Name $ServiceName).Status -eq 'Running')
		    {
			    $ServiceName +" already running!" | Add-Content 'service.txt'
		    }
		    elseif ((Get-Service -Name $ServiceName).Status -eq 'Stopped')
		    {
			    $ServiceName +" is stopped, preparing to start..." | Add-Content 'service.txt'
			    Get-Service -Name $ServiceName | Start-Service -ErrorAction SilentlyContinue
			    CheckMyService $ServiceName
		    }
		    else
		    {
			     $ServiceName +" - "+ $ServiceStatus | Add-Content 'service.txt'
		    }
	    }
 
	    #Condition if user wants to restart a service
	    elseif ($Action -eq 'Restart')
	    {
		    if ((Get-Service -Name $ServiceName).Status -eq 'Running')
		    {
		        $ServiceName+ " is running, preparing to restart..."| Add-Content 'service.txt'
			    Get-Service -Name $ServiceName | Stop-Service -ErrorAction SilentlyContinue
			    Get-Service -Name $ServiceName | Start-Service -ErrorAction SilentlyContinue
			    CheckMyService $ServiceName
		    }
		    elseif ((Get-Service -Name $ServiceName).Status -eq 'Stopped')
		    {
			    $ServiceName +" is stopped, preparing to start..." | Add-Content 'service.txt'
			    Get-Service -Name $ServiceName | Start-Service -ErrorAction SilentlyContinue
			    CheckMyService $ServiceName
		    }
	    }
 
	    #Condition if action is anything other than stop, start, restart
	    else
	    {
		    "Action parameter is missing or invalid!" | Add-Content 'service.txt'
	    }
    }
 
#Condition if provided ServiceName is invalid
    else
    {
	    "$ServiceName not found" | Add-Content 'service.txt'
    }


}