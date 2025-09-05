# Read domain names from dnames.txt
$domainNames = Get-Content "dnames.txt"

# Function to resolve domain name to IP addresses
function Resolve-DomainName {
  param(
    [string] $domainName
  )
  try {
    $ipAddresses = [System.Net.Dns]::GetHostEntry($domainName).AddressList
    return $ipAddresses
  } catch {
    Write-Warning "Could not resolve IP address for domain: $domainName"
    return @()  # Empty array in case of resolution failure
  }
}

function PopupMessage {
  param(
    [string] $popupmessage
  )

   #Write-Host " $popupmessage"
  
   # Load the necessary assemblies for UI components
   Add-Type -AssemblyName PresentationCore, PresentationFramework, System.Windows.Forms
   
   # Define the message box content
   $msgBody = $popupmessage
   $msgTitle = "Attention!"
   $msgButton = [System.Windows.Forms.MessageBoxButtons]::OK
   $msgImage = [System.Windows.Forms.MessageBoxIcon]::Information
   
   # Create a hidden form and set its 'TopMost' property to true
   $onTopForm = New-Object System.Windows.Forms.Form
   $onTopForm.Size = New-Object System.Drawing.Size(0,0) # Make the form invisible
   $onTopForm.TopMost = $true
   $onTopForm.ShowInTaskbar = $false # Don't show the form in the taskbar
   $onTopForm.Show()
   
   # Display the message box using the hidden form as the owner
   $Result = [System.Windows.Forms.MessageBox]::Show($onTopForm, $msgBody, $msgTitle, $msgButton, $msgImage)
   
   # Close the hidden form after the user interacts with the message box
   $onTopForm.Close()

}


Add-Type -AssemblyName System.Speech
$SpeechSynthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
Add-Type -AssemblyName System.Speech
#$SpeechSynthesizer.Speak('Hello, World!')

function VoiceMessage {
  param(
    [string] $speechmsg
  )
    $SpeechSynthesizer.Speak($speechmsg)
}


while($true)
{
# Check active IPv4 connections
$activeConnections = Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' }
$foundConnections = @()

# Loop through domain names and corresponding IP addresses
foreach ($domainName in $domainNames) {
  # Resolve domain name to IP addresses
  $ipAddresses = Resolve-DomainName $domainName

  # Check if any active connection matches an IP address
  foreach ($ipAddress in $ipAddresses) {
    if ($activeConnections.RemoteAddress -contains $ipAddress) {
      Write-Host " $domainName"
      $foundConnections += New-Object PSObject -Property @{
        "RemoteAddress" = $ipAddress
        "Domainname" = $domainName
      }
      break  # Exit inner loop if a match is found for this domain
    }
  }
}



if ($foundConnections.Count -gt 0) {
  Write-Host "Found active connections to the following domains:"
  $foundConnections | Format-Table RemoteAddress, RemotePort, DomainName

  Add-Type -AssemblyName PresentationCore,PresentationFramework

  $msgBody = "Found active connections to the following domains:"

  # Loop through connections and add details to message body
  foreach ($connection in $foundConnections) {
    $msgBody += "`n- Remote Address: {0}, Domain Name: {1}" -f $connection.RemoteAddress, $connection.DomainName
    $speechmsgdata = " {0} " -f $connection.DomainName
  }
  Write-Host $speechmsgdata
  VoiceMessage "Bank connection was found to $speechmsgdata"
  $msgTitle = "Connection to bank ok"
  $msgButton = 'Ok'
  $msgImage = 'Question'
  # $Result = [System.Windows.MessageBox]::Show($msgBody,$msgTitle,$msgButton,$msgImage)
  PopupMessage $msgBody
  Start-Sleep -Seconds 15
  } 
}
