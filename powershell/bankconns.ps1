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

Add-Type -AssemblyName System.Speech
$SpeechSynthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
Add-Type -AssemblyName System.Speech
#$SpeechSynthesizer.Speak('Hello, World!')

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
  $speechmsg = "Bank connection was found to $speechmsgdata"
  $SpeechSynthesizer.Speak($speechmsg)
  $msgTitle = "Connection to bank ok"
  $msgButton = 'Ok'
  $msgImage = 'Question'
  $Result = [System.Windows.MessageBox]::Show($msgBody,$msgTitle,$msgButton,$msgImage)

  } 
}
