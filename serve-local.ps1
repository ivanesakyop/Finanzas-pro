$ErrorActionPreference = "Stop"

$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, 3000)
$listener.Start()

$root = Join-Path $PSScriptRoot "public"
$mimeTypes = @{
  ".html" = "text/html; charset=utf-8"
  ".js"   = "application/javascript; charset=utf-8"
  ".css"  = "text/css; charset=utf-8"
  ".json" = "application/json; charset=utf-8"
  ".svg"  = "image/svg+xml"
  ".png"  = "image/png"
  ".jpg"  = "image/jpeg"
  ".jpeg" = "image/jpeg"
  ".ico"  = "image/x-icon"
}

function Get-ResponseBytes([string]$path) {
  $relativePath = if ([string]::IsNullOrWhiteSpace($path) -or $path -eq "/") { "index.html" } else { $path.TrimStart("/") }
  $safePath = $relativePath.Replace("/", "\")
  $filePath = Join-Path $root $safePath

  if (-not (Test-Path $filePath) -or (Get-Item $filePath).PSIsContainer) {
    $filePath = Join-Path $root "index.html"
  }

  $body = [System.IO.File]::ReadAllBytes($filePath)
  $extension = [System.IO.Path]::GetExtension($filePath).ToLowerInvariant()
  $contentType = $mimeTypes[$extension]
  if (-not $contentType) {
    $contentType = "application/octet-stream"
  }

  $headerText = "HTTP/1.1 200 OK`r`nContent-Type: $contentType`r`nContent-Length: $($body.Length)`r`nConnection: close`r`n`r`n"
  $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($headerText)

  $response = New-Object byte[] ($headerBytes.Length + $body.Length)
  [Array]::Copy($headerBytes, 0, $response, 0, $headerBytes.Length)
  [Array]::Copy($body, 0, $response, $headerBytes.Length, $body.Length)
  return $response
}

try {
  while ($true) {
    $client = $listener.AcceptTcpClient()
    try {
      $stream = $client.GetStream()
      $buffer = New-Object byte[] 8192
      $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
      if ($bytesRead -le 0) {
        continue
      }

      $requestText = [System.Text.Encoding]::ASCII.GetString($buffer, 0, $bytesRead)
      $requestLine = ($requestText -split "`r`n")[0]
      $parts = $requestLine -split " "
      $requestPath = if ($parts.Length -ge 2) { $parts[1].Split("?")[0] } else { "/" }

      $responseBytes = Get-ResponseBytes $requestPath
      $stream.Write($responseBytes, 0, $responseBytes.Length)
      $stream.Flush()
    }
    finally {
      $client.Close()
    }
  }
}
finally {
  $listener.Stop()
}
