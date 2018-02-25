<powershell>

install-windowsfeature web-server, web-mgmt-console

$content = '
    <!DOCTYPE html>
    <html>
    <body bgcolor="#0066ff">
    <font size=5>
    <h1>Build ver - "20171221.59"</h1>
    <h2>AMI id - "ami-0f7a0676"</h2>
    </font>
    </body>
    </html>
'
Set-Content -Value $content -Path "c:\inetpub\wwwroot\index.html"

</powershell>