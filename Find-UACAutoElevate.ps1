function Invoke-UACAutoElevateFinder {
    param (
        [Parameter(Mandatory=$false)]
        [string]$FolderPath
    )

    # Map FolderPath -> Path
    if ($FolderPath) {
        $Path = @($FolderPath)   # ensure it's an array
    } else {
        $Path = @("$env:WINDIR\System32")
        if (Test-Path "$env:WINDIR\SysWOW64") { $Path += "$env:WINDIR\SysWOW64" }
    }

    # Clear screen and show banner:
    Clear-Host
    $banner = '4paI4paI4pWXICAg4paI4paI4pWXIOKWiOKWiOKWiOKWiOKWiOKVlyAg4paI4paI4paI4paI4paI4paI4pWXIOKWiOKWiOKWiOKWiOKWiOKVlyDilojilojilZcgICDilojilojilZfilojilojilojilojilojilojilojilojilZcg4paI4paI4paI4paI4paI4paI4pWXIOKWiOKWiOKWiOKWiOKWiOKWiOKWiOKVl+KWiOKWiOKVlyAgICAg4paI4paI4paI4paI4paI4paI4paI4pWX4paI4paI4pWXICAg4paI4paI4pWXIOKWiOKWiOKWiOKWiOKWiOKVlyDilojilojilojilojilojilojilojilojilZfilojilojilojilojilojilojilojilZfilojilojilojilojilojilojilojilZfilojilojilZfilojilojilojilZcgICDilojilojilZfilojilojilojilojilojilojilZcg4paI4paI4paI4paI4paI4paI4paI4pWX4paI4paI4paI4paI4paI4paI4pWXIArilojilojilZEgICDilojilojilZHilojilojilZTilZDilZDilojilojilZfilojilojilZTilZDilZDilZDilZDilZ3ilojilojilZTilZDilZDilojilojilZfilojilojilZEgICDilojilojilZHilZrilZDilZDilojilojilZTilZDilZDilZ3ilojilojilZTilZDilZDilZDilojilojilZfilojilojilZTilZDilZDilZDilZDilZ3ilojilojilZEgICAgIOKWiOKWiOKVlOKVkOKVkOKVkOKVkOKVneKWiOKWiOKVkSAgIOKWiOKWiOKVkeKWiOKWiOKVlOKVkOKVkOKWiOKWiOKVl+KVmuKVkOKVkOKWiOKWiOKVlOKVkOKVkOKVneKWiOKWiOKVlOKVkOKVkOKVkOKVkOKVneKWiOKWiOKVlOKVkOKVkOKVkOKVkOKVneKWiOKWiOKVkeKWiOKWiOKWiOKWiOKVlyAg4paI4paI4pWR4paI4paI4pWU4pWQ4pWQ4paI4paI4pWX4paI4paI4pWU4pWQ4pWQ4pWQ4pWQ4pWd4paI4paI4pWU4pWQ4pWQ4paI4paI4pWXCuKWiOKWiOKVkSAgIOKWiOKWiOKVkeKWiOKWiOKWiOKWiOKWiOKWiOKWiOKVkeKWiOKWiOKVkSAgICAg4paI4paI4paI4paI4paI4paI4paI4pWR4paI4paI4pWRICAg4paI4paI4pWRICAg4paI4paI4pWRICAg4paI4paI4pWRICAg4paI4paI4pWR4paI4paI4paI4paI4paI4pWXICDilojilojilZEgICAgIOKWiOKWiOKWiOKWiOKWiOKVlyAg4paI4paI4pWRICAg4paI4paI4pWR4paI4paI4paI4paI4paI4paI4paI4pWRICAg4paI4paI4pWRICAg4paI4paI4paI4paI4paI4pWXICDilojilojilojilojilojilZcgIOKWiOKWiOKVkeKWiOKWiOKVlOKWiOKWiOKVlyDilojilojilZHilojilojilZEgIOKWiOKWiOKVkeKWiOKWiOKWiOKWiOKWiOKVlyAg4paI4paI4paI4paI4paI4paI4pWU4pWdCuKWiOKWiOKVkSAgIOKWiOKWiOKVkeKWiOKWiOKVlOKVkOKVkOKWiOKWiOKVkeKWiOKWiOKVkSAgICAg4paI4paI4pWU4pWQ4pWQ4paI4paI4pWR4paI4paI4pWRICAg4paI4paI4pWRICAg4paI4paI4pWRICAg4paI4paI4pWRICAg4paI4paI4pWR4paI4paI4pWU4pWQ4pWQ4pWdICDilojilojilZEgICAgIOKWiOKWiOKVlOKVkOKVkOKVnSAg4pWa4paI4paI4pWXIOKWiOKWiOKVlOKVneKWiOKWiOKVlOKVkOKVkOKWiOKWiOKVkSAgIOKWiOKWiOKVkSAgIOKWiOKWiOKVlOKVkOKVkOKVnSAg4paI4paI4pWU4pWQ4pWQ4pWdICDilojilojilZHilojilojilZHilZrilojilojilZfilojilojilZHilojilojilZEgIOKWiOKWiOKVkeKWiOKWiOKVlOKVkOKVkOKVnSAg4paI4paI4pWU4pWQ4pWQ4paI4paI4pWXCuKVmuKWiOKWiOKWiOKWiOKWiOKWiOKVlOKVneKWiOKWiOKVkSAg4paI4paI4pWR4pWa4paI4paI4paI4paI4paI4paI4pWX4paI4paI4pWRICDilojilojilZHilZrilojilojilojilojilojilojilZTilZ0gICDilojilojilZEgICDilZrilojilojilojilojilojilojilZTilZ3ilojilojilojilojilojilojilojilZfilojilojilojilojilojilojilojilZfilojilojilojilojilojilojilojilZcg4pWa4paI4paI4paI4paI4pWU4pWdIOKWiOKWiOKVkSAg4paI4paI4pWRICAg4paI4paI4pWRICAg4paI4paI4paI4paI4paI4paI4paI4pWX4paI4paI4pWRICAgICDilojilojilZHilojilojilZEg4pWa4paI4paI4paI4paI4pWR4paI4paI4paI4paI4paI4paI4pWU4pWd4paI4paI4paI4paI4paI4paI4paI4pWX4paI4paI4pWRICDilojilojilZEKIOKVmuKVkOKVkOKVkOKVkOKVkOKVnSDilZrilZDilZ0gIOKVmuKVkOKVnSDilZrilZDilZDilZDilZDilZDilZ3ilZrilZDilZ0gIOKVmuKVkOKVnSDilZrilZDilZDilZDilZDilZDilZ0gICAg4pWa4pWQ4pWdICAgIOKVmuKVkOKVkOKVkOKVkOKVkOKVnSDilZrilZDilZDilZDilZDilZDilZDilZ3ilZrilZDilZDilZDilZDilZDilZDilZ3ilZrilZDilZDilZDilZDilZDilZDilZ0gIOKVmuKVkOKVkOKVkOKVnSAg4pWa4pWQ4pWdICDilZrilZDilZ0gICDilZrilZDilZ0gICDilZrilZDilZDilZDilZDilZDilZDilZ3ilZrilZDilZ0gICAgIOKVmuKVkOKVneKVmuKVkOKVnSAg4pWa4pWQ4pWQ4pWQ4pWd4pWa4pWQ4pWQ4pWQ4pWQ4pWQ4pWdIOKVmuKVkOKVkOKVkOKVkOKVkOKVkOKVneKVmuKVkOKVnSAg4pWa4pWQ4pWdCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA='
    $banner = [System.Convert]::FromBase64String($banner)
    $banner = [System.Text.Encoding]::UTF8.GetString($banner)
    Write-host "`n"
    Write-Host "================================================"
    Write-host "`n"
    Write-Host $banner 
    Write-host "`n Author: Matan Bahar`n Version: 0.1 `n"
    Write-Host "================================================"

                                                                                                                                                                   
    <# 
    .SYNOPSIS
        Find EXEs whose embedded manifest has BOTH:
            <autoElevate>true</autoElevate>
            <requestedExecutionLevel level="requireAdministrator"
    .PARAMETER FolderPath
        Root folder(s) to scan (defaults to System32 + SysWOW64 if present)
    .EXAMPLE
        Invoke-UACAutoElevateFinder -FolderPath "C:\Windows\System32"
    .EXAMPLE
        Invoke-UACAutoElevateFinder -FolderPath "C:\Windows\SysWow64"
    #>

    # --- Win32 manifest extractor (RT_MANIFEST = 24, resource ID = 1) ---
    $cs = @"
using System;
using System.IO;
using System.Runtime.InteropServices;

public static class ManifestReader {
    const int RT_MANIFEST = 24;

    [DllImport("kernel32", CharSet=CharSet.Unicode, SetLastError=true)]
    static extern IntPtr LoadLibraryEx(string lpFileName, IntPtr hFile, uint dwFlags);
    [DllImport("kernel32", SetLastError=true)] static extern bool FreeLibrary(IntPtr hModule);

    [DllImport("kernel32", SetLastError=true)]
    static extern IntPtr FindResource(IntPtr hModule, IntPtr lpName, IntPtr lpType);
    [DllImport("kernel32", SetLastError=true)]
    static extern IntPtr LoadResource(IntPtr hModule, IntPtr hResInfo);
    [DllImport("kernel32", SetLastError=true)]
    static extern IntPtr LockResource(IntPtr hResData);
    [DllImport("kernel32", SetLastError=true)]
    static extern uint SizeofResource(IntPtr hModule, IntPtr hResInfo);

    public static string GetManifest(string path) {
        if (!File.Exists(path)) return null;
        const uint LOAD_LIBRARY_AS_DATAFILE = 0x00000002;
        IntPtr hMod = LoadLibraryEx(path, IntPtr.Zero, LOAD_LIBRARY_AS_DATAFILE);
        if (hMod == IntPtr.Zero) return null;
        try {
            IntPtr hRes = FindResource(hMod, new IntPtr(1), new IntPtr(RT_MANIFEST));
            if (hRes == IntPtr.Zero) return null;
            uint size = SizeofResource(hMod, hRes);
            if (size == 0) return null;
            IntPtr hData = LoadResource(hMod, hRes);
            if (hData == IntPtr.Zero) return null;
            IntPtr p = LockResource(hData);
            if (p == IntPtr.Zero) return null;

            byte[] bytes = new byte[size];
            Marshal.Copy(p, bytes, 0, (int)size);
            // Try UTF-8 first; fall back to UTF-16LE
            string s;
            try { s = System.Text.Encoding.UTF8.GetString(bytes); }
            catch { s = System.Text.Encoding.Unicode.GetString(bytes); }
            if (string.IsNullOrWhiteSpace(s)) s = System.Text.Encoding.Unicode.GetString(bytes);
            return s;
        }
        finally { FreeLibrary(hMod); }
    }
}
"@
    Add-Type -TypeDefinition $cs -ErrorAction Stop

    # Loop through EXE in folders:
    $results = foreach ($root in $FolderPath) {
        if (-not (Test-Path $root)) { Write-Warning "Path not found: $root"; continue }
        Get-ChildItem -Path $root -Recurse -File -Filter *.exe -ErrorAction SilentlyContinue | ForEach-Object {
            try {
                $m = [ManifestReader]::GetManifest($_.FullName)
                if ([string]::IsNullOrWhiteSpace($m)) { return }

                # Regex checks (robust across namespaces/whitespace)
                $auto  = $m -match '<\s*autoElevate\s*>\s*true\s*<\s*/\s*autoElevate\s*>'
                $reqAd = $m -match '<\s*requestedExecutionLevel[^>]*level\s*=\s*"(requireAdministrator)"'

                if ($auto -and $reqAd) {
                    [pscustomobject]@{
                        Path                     = $_.FullName
                        FileVersion              = ($_.VersionInfo.FileVersion -as [string])
                        ProductName              = ($_.VersionInfo.ProductName -as [string])
                        AutoElevate              = $true
                        RequestedExecutionLevel  = 'requireAdministrator'
                    }
                }
            } catch { }
        }
    }

    if ($results) {
        $results | Sort-Object Path | Format-Table -AutoSize
    } else {
        Write-Host "No matches found under: $($FolderPath -join ', ')" -ForegroundColor Yellow
    }
}
