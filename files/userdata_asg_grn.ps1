<powershell>
$instanceid     = Invoke-RestMethod http://169.254.169.254/latest/meta-data/instance-id # this uses the EC2 instance ID as the node name
$ami_id         = Invoke-RestMethod http://169.254.169.254/latest/meta-data/ami-id
$tags           = Get-EC2Instance -Instance $instanceId | Select -ExpandProperty Instances | Select -ExpandProperty Tags
$app_version    = $tags | ? Key -eq AppVersion | Select -ExpandProperty Value

install-windowsfeature web-server, web-mgmt-console

$content = '
    <!DOCTYPE html>
    <html>
    <body bgcolor="#009933">
    <font size=5>
    <h1>Build ver - $app_version </h1>
    <h2>AMI id - $ami_id </h2>
    </font>
    </body>
    </html>
'
Set-Content -Value $content -Path "c:\inetpub\wwwroot\index.html"

</powershell>