$url = 'B:\Not found\page1.html'
$page = Invoke-WebRequest -Uri $url
$page.RawContent