# antiphishing
Bash and powershell scripts for checking browser is connected to a known bank website.

### Bash script:

Bash script showbankconns.sh checks internet connections. In the beginning script blocks payments by blocking 2FA payment authentication. This is done by blocking wifi tablets access to internet. That wifi tablet is used for payments 2FA. Script starts to check internet connections from users PC. If it finds a connection to a known bank IP address it will enable 2FA payment authentication and display a message box.

### Powershell script:

Powershell script bankconns.ps1 checks internet connections. If it finds a connection to a known bank IP address, it will announce it through voice and display a message box. This helps users confirm they're connected to a legitimate bank website and not a phishing site.

Start powershell script from cmd prompt.
For e.g.
E:\data\powershell\antiphishing>powershell .\bankconns.ps1

## License

This project is licensed under the GNU General Public License version 3.0 (GPL 3.0). See the [LICENSE](LICENSE) file for details.

