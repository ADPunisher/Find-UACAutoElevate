# Find-UACAutoElevate

## Overview

Find-UACAutoElevate is a powershell tool to find auto eleveated executable in order to bypass User Account Control.

## Features

Supports single folder path to find executable that match the requirements to bypass UAC.

## Parameters

**FolderPath (optional):** Path to a folder to search for relevant executables.

## Example Usage
### Using a folder path to find executables to bypass UAC.
Invoke-UACAutoElevateFinder -FolderPath "C:\Windows\System32"<br>
Invoke-UACAutoElevateFinder -FolderPath "C:\Windows\SysWow64"

## Contributing
Contributions are welcome! Please feel free to submit a pull request or open an issue for any improvements, bug fixes, or suggestions.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Credits
Author: [Matan Bahar](https://www.linkedin.com/in/matan-bahar-66460a1b0/)
