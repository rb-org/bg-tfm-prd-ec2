<powershell>

install-windowsfeature web-server, web-mgmt-console

$content = '
    <!DOCTYPE html>
    <html>
    <body bgcolor="#009933">
    <font size=5>
    <h1>Build ver - "20171221.58"</h1>
    <h2>AMI id - "ami-c10b77b8"</h2>
    </font>
    </body>
    </html>
'
Set-Content -Value $content -Path "c:\inetpub\wwwroot\index.html"

</powershell>