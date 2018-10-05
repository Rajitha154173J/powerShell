
$Server="localhost"
$cpuUsage=(Get-WmiObject -ComputerName $Server -Class win32_processor | Measure-Object -Property LoadPercentage -Average | Select-Object Average).Average

#Get Memary Usage
$ComputerMemory =  Get-WmiObject -Class WIN32_OperatingSystem -ComputerName $Server
$Memory = ((($ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory)*100)/ $ComputerMemory.TotalVisibleMemorySize)


$Subject= "Alert Email"
$cpuDetail="cpu usage = "+$cpuUsage
$memoryDetail= "Memory usage = "+$Memory

$to="rajithasanjayamal0918@gmail.com"

$form="rajitha.15@itfac.mrt.ac.lk"
$Body=$cpuDetail+"`n"+$memoryDetail

$secpasswd = ConvertTo-SecureString "RajiS0918#" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("rajitha.15@itfac.mrt.ac.lk", $secpasswd)
Send-MailMessage -To "User01 <$to>" -From "Admin <$form>" -Subject $Subject -Body $Body -SmtpServer "smtp.gmail.com" -Port "587" -Credential $mycreds -UseSsl –DeliveryNotificationOption OnSuccess
