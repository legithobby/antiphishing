# antiphishing
Bash and powershell scripts for checking browser is connected to a known bank website.

### Bash script:

Bash script showbankconns.sh checks internet connections. In the beginning script blocks 2FA authentication by blocking wifi tablets access to internet. That wifi tablet is used for 2FA. Script starts to check internet connections from users PC. If it finds a connection to a known bank IP address it will enable 2FA and display a message box.

### Powershell script:

Powershell script bankconns.ps1 checks internet connections. If it finds a connection to a known bank IP address, it will announce it through voice and display a message box. This helps users confirm they're connected to a legitimate bank website and not a phishing site.

Start powershell script from cmd prompt.
For e.g.
E:\data\powershell\antiphishing>powershell .\bankconns.ps1

