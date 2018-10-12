 
<#$info = get-content "C:\Users\UnicornRSA\input.txt"
foreach ($i in $info) {
   $item = $i.split("-")
   Write-Host $item[0]
   Write-Host $item[1]
   
}#>
 $services="WebClient-Start","Spooler-Start"
 foreach ($ser in $services){
    $ser
 }