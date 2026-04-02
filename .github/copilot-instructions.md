# AsBuiltReport.Diagram – Copilot Instructions

## What This Project Is

A **PowerShell module** (`AsBuiltReport.Diagram`) that provides a framework for generating infrastructure diagrams using [PSGraph](https://github.com/KevinMarquette/PSGraph) and Graphviz. It is the core dependency consumed by downstream diagrammer modules (e.g., VMware, NetApp, etc.). The module wraps a companion **.NET C# assembly** (built from `Sources/`) that handles image processing (watermark, resize, rotate, PDF conversion).

---

## Build

The .NET assembly **must be built and copied before the PowerShell module can be imported or tests can run**.

**PowerShell 7 / pwsh (net8.0):**
```powershell
dotnet publish ./Sources/Diagrammer -c Release
Copy-Item -Path ./Sources/Diagrammer/bin/Release/net8.0/publish/* -Destination ./AsBuiltReport.Diagram/Src/Bin/Assemblies/net80 -Recurse
```

**Windows PowerShell 5.1 (net48):**
```powershell
dotnet publish ./Sources/DiaConvertImageToPDF -c Release
Copy-Item -Path ./Sources/DiaConvertImageToPDF/bin/Release/net48/publish/* -Destination ./AsBuiltReport.Diagram/Src/Bin/Assemblies/net48 -Recurse
```

---

## Testing

Tests use **Pester**. PSGraph must be installed and Graphviz must be on PATH (Linux/macOS) or available at `Tools\Graphviz\bin\dot.exe` (Windows).

```powershell
# Install dependency
Install-Module -Name PSGraph -Repository PSGallery -Force

# Run all tests
Invoke-Pester ./Tests

# Run a single test file
Invoke-Pester ./Tests/Add-NodeIcon.Tests.ps1
```

`Tests/_InitializeTests.ps1` is dot-sourced by every test via `BeforeAll` – it sets `$ProjectRoot`, `$GraphvizPath`, loads the correct assembly for the PS edition, and imports the module.

---

## Linting

PSScriptAnalyzer is used. The following rules are **excluded** (see `.github/workflows/PSScriptAnalyzerSettings.psd1`):
- `PSUseToExportFieldsInManifest`
- `PSReviewUnusedParameter`
- `PSUseDeclaredVarsMoreThanAssignments`
- `PSAvoidGlobalVars`
- `AvoidUsingWriteHost`

```powershell
Invoke-ScriptAnalyzer -Path ./AsBuiltReport.Diagram -Recurse -ExcludeRule 'PSUseToExportFieldsInManifest','PSReviewUnusedParameter','PSUseDeclaredVarsMoreThanAssignments','PSAvoidGlobalVars'
```

---

## Architecture

```
AsBuiltReport.Diagram/       # PowerShell module root
  AsBuiltReport.Diagram.psm1 # Entry point: loads assembly, dot-sources Public + Private
  AsBuiltReport.Diagram.psd1 # Module manifest
  Src/
    Public/                  # Only New-AbrDiagram.ps1 (the main diagram orchestrator)
    Private/                 # All other functions (Add-*, Export-*, Convert-*, Format-*, etc.)
    Bin/Assemblies/
      net80/                 # Built output of Sources/Diagrammer (PS Core)
      net48/                 # Built output of Sources/DiaConvertImageToPDF (Windows PS)
Sources/
  Diagrammer/                # .NET 8 C# project – PS Cmdlets for image ops (watermark, resize, rotate, PDF)
  DiaConvertImageToPDF/      # .NET Framework 4.8 C# project – Windows PS PDF conversion only
Tests/                       # Pester test suite (one file per function + example tests)
Examples/                    # Runnable PS1 scripts demonstrating each cmdlet
```

**Module loading** (`AsBuiltReport.Diagram.psm1`): loads the assembly for the current PS edition (`net80` for Core, `net48` for Desktop), then dot-sources every `.ps1` in `Src/Private` and `Src/Public`. **Both** directories are exported.

**Function flow**: Callers build a PSGraph object using PSGraph cmdlets (`graph`, `node`, `edge`, `subgraph`), then pass it to `New-AbrDiagram` (or `Export-AbrDiagram` directly). `New-AbrDiagram` adds diagram-level labeling (logo, title, signature), then calls `Export-AbrDiagram` to render output via `dot.exe` / `ConvertTo-*` helpers.

**Graphviz path resolution**: On Unix, the module probes `/usr/bin/dot`, `/bin/dot`, `/usr/local/bin/dot`, `/opt/homebrew/bin/dot`. On Windows, it uses `Tools\Graphviz\bin\dot.exe` relative to the module root.

**C# assembly internals**: `AbrDiagrammer.dll` (net80) uses **SixLabors.ImageSharp** (v3.x) for image processing and **iText** (v9.x) for PDF generation. Cmdlet classes follow the naming pattern `{Verb}{Noun}Command` (e.g., `AddWatermarkToImageCommand`, `GetResizeImageFromFileCommand`).

---

## Key Conventions

- **Naming prefix**: module-specific functions use the `Abr` prefix – e.g., `Export-AbrDiagram`, `New-AbrDiagram`, `Test-AbrLogo`, `Get-AbrNodeIP`. Generic helper cmdlets (`Add-NodeIcon`, `Add-HtmlTable`, etc.) do not use the prefix.
- **HTML labels**: Graphviz nodes use HTML-like label syntax. The helpers (`Add-NodeIcon`, `Add-HtmlNodeTable`, `Add-HtmlTable`, `Format-HtmlTable`, `Format-HtmlFontProperty`) build these strings; use them rather than constructing raw HTML manually.
- **`IconType = 'NoIcon'`** is the sentinel value to render a node without an image.
- **`NodeObject` switch** on node-building functions: when passed, the function calls `Format-NodeObject` to register the node with Graphviz attributes rather than returning a plain HTML string.
- **`AditionalInfo` parameter** (intentional spelling, aliased as `AdditionalInfo`, `Rows`, `RowsOrdered`) accepts `Hashtable`, `OrderedDictionary`, `PSCustomObject`, or `Object[]`.
- **`IconDebug` / `DraftMode`**: renders table borders in red for visual debugging – available as an alias on several functions.
- **Supported output formats**: `pdf`, `svg`, `png`, `dot`, `base64`, `jpg`.
- **Default style values**: font `Segoe Ui`, font color `#000000`, background `#FFFFFF`, edge color `#71797E`.
- **Tests follow Examples**: each `ExampleNN.Tests.ps1` runs the corresponding `Examples/ExampleNN.ps1` and asserts the contents of the generated `.dot` file, verifying expected HTML label fragments or node names.
- **Cross-platform path construction**: use `[System.IO.Path]::DirectorySeparatorChar` (often via `-f` format string) instead of hardcoded slashes – see existing code for the pattern.
- **CI matrix**: `Pester.yml` runs on Windows (pwsh + powershell), Ubuntu (pwsh), macOS (pwsh). The `powershell` (Desktop) shell only runs on `windows-latest`.
