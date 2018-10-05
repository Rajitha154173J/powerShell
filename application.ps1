#Name of the server
$Server="localhost"

#Name of the service
$service ="WebClient"

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




if ($cpuUsage -ge 50 -or $Memory -ge 50 ){
    #need to note
    $To = "rajithasanjayamal0918@gmail.com"
    
    #Restart Service
    #Restart-Service -Force $service

    Set-Location -Path $filePath
    
    $time= "Time = "+$timestamp
    $time | Add-Content 'Report.txt'

    $cpuDetail="Cpu usage = "+$cpuUsage
    $cpuDetail | Add-Content 'Report.txt'

    $memoryDetail= "Memory usage = "+$Memory
    $memoryDetail | Add-Content 'Report.txt'

    $emailStatus= "Send email to "+$To
    $emailStatus | Add-Content 'Report.txt'

    #$serviceDetails= "Restart Service = "+$service
    #$serviceDetails | Add-Content 'Report.txt'



   #Handlng Email
    $From = "cpum698@gmail.com"
    
   # $Cc = "AThirdUser@somewhere.com"
    $Attachment = $path+"\"+$timestamp+"\Report.txt"
    $Subject ="Alert Email"
    $Body = $cpuDetail+"`n"+$memoryDetail+"`n"+$serviceDetails+"`n"+$emailStatus
    $SMTPServer = "smtp.gmail.com"
    $SMTPPort = "587"
   

    $secpasswd = ConvertTo-SecureString "Unicorn123456#" -AsPlainText -Force
    $mycreds = New-Object System.Management.Automation.PSCredential ("cpum698@gmail.com", $secpasswd)
    Send-MailMessage -To "User01 <$To>" -From "Admin <$From>" -Subject $Subject -Body $Body -SmtpServer $SMTPServer -Port $SMTPPort -Credential $mycreds -UseSsl -Attachments $Attachment 



}else{
    
    Set-Location -Path $filePath
    
    $time= "Time = "+$timestamp
    $time | Add-Content 'Report.txt'

    $cpuDetail="Cpu usage = "+$cpuUsage
    $cpuDetail | Add-Content 'Report.txt'

    $memoryDetail= "Memory usage = "+$Memory
    $memoryDetail | Add-Content 'Report.txt'

    "Every things are fine" | Add-Content 'Report.txt'
}