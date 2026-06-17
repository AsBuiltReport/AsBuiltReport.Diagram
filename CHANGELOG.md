# :arrows_clockwise: AsBuiltReport.Diagram Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.9] - Unreleased

### :arrows_clockwise: Changed

- Update module version to v1.0.9

## [1.0.8] - 2026-06-16

### :toolbox: Added

- Add `-Dpi` parameter to `New-AbrDiagram`, allowing the raster output resolution (PNG/JPG) to be set directly via the Graphviz `dpi` graph attribute instead of being fixed at the Graphviz default of 96
- Add `-IconWidth`/`-IconHeight` parameters to `Add-HtmlNodeTable`, allowing the rendered icon size in a node's HTML table to be set explicitly instead of being derived solely from the source image's pixel dimensions

### :arrows_clockwise: Changed

- Improve the name resolutions in `Get-AbrNodeIP` cmdlet

### :wrench: Fixed

- Fix missing TableBorderColor parameter in `Add-HtmlSignatureTable` calls in `New-AbrDiagram` function
- Fix missing TableBorderColor parameter in Main Logo section calls in `New-AbrDiagram` function


## [1.0.7] - 2026-05-02

### :arrows_clockwise: Changed

- Update module version to v1.0.7
- Enhance Add-HtmlSignatureTable with background color parameters
- refactor: streamline Add-HtmlSignatureTable function and improve logo handling
- refactor: optimize Add-HtmlLabel function for improved readability and maintainability
- refactor: simplify AditionalInfo handling and consolidate font parameter usage in Add-HtmlNodeTable function
- refactor: add IconPath parameter and improve icon handling in Add-HtmlSubGraph function
- refactor: streamline font parameter handling and improve subgraph icon logic in Add-HtmlTable function
- refactor: enhance icon handling and streamline additional info processing in Add-NodeIcon function
- refactor: optimize HTML table generation and streamline parameter handling in Add-NodeImage function
- refactor: streamline font parameter handling in Add-NodeText function

### :wrench: Fixed

- Fix duplicate pester test names in AdvancedExample02.Tests tests

## [1.0.6] - 2026-04-23

### :arrows_clockwise: Changed

- Update module version to v1.0.6
- Update Graphviz binary to version 14.1.5
- Update AbrDiaConvertImageToPDF c# dependencies to latest release
- Update AbrDiagrammer c# dependencies to latest release

## [1.0.5] - 2026-03-24

### :toolbox: Added

- Add Format-HtmlCell cmdlet to the module to format HTML table cells with specified background color, text color, and font size
- Add Set-ImageOpacity cmdlet to the module to set the opacity of an image file
- Add new parameters to Add-NodeImage cmdlet to set image opacity for node images
- Add WaterMark support to SVG output format
  - Use the DiaConvertImageToPDF c# net4.8 package to add watermark support to SVG output format

### :arrows_clockwise: Changed

- Update module version to v1.0.5
- Update edge length validation range, and help message to reflect the new range of 0 to 50 in Add-NodeEdge function
- Update Pester workflow to run tests and upload results with code coverage support
- Optimize aspect ratio calculation in Get-BestImageAspectRatio function

### :wrench: Fixed

- Fix pester tests failing in Windows Pwsh 5.1+

## [1.0.4] - 2026-03-17

### :arrows_clockwise: Changed

- Update module version to v1.0.4

### :wrench: Fixed

- Fix missing Convert-TableToHTML file in the module manifest and update the FunctionsToExport entry to include the correct file name

## [1.0.3] - 2026-03-16

### :arrows_clockwise: Changed

- Update module version to v1.0.3
- Migrate more cmdlets to unique names to avoid conflicts with Diagrammer.Core cmdlets

## [1.0.2] - 2026-03-15

### :arrows_clockwise: Changed

- Update module version to v1.0.2
- Migrate cmdlet to a unique name to avoid conflicts with Diagrammer.Core cmdlets

## [1.0.1] - 2026-03-15

### :toolbox: Added

- Add PSGraph to the module dependencies in the module manifest

### :arrows_clockwise: Changed

- Update module version to v1.0.1

### :wrench: Fixed

- Add missing PSGraph dependency to the Pester tests

### :x: Removed

- Remove PSgraph cmdlets from the module

## [1.0.0] - 2026-03-15

### :toolbox: Added

- Add WaterMark support to SVG output format
  - Use the Diagrammer c# package to add watermark support to SVG output format

### :arrows_clockwise: Changed

- Update module version to v1.0.0
- Migrated source code to new repository structure
  - Moved source code to AsBuiltReport.Diagram directory
  - Updated module manifest to reflect new structure
- Update Graphviz binary to version 14.1.3
- Migrate namespace from Diagrammer/DiaConvertImageToPDF to AsBuiltReportDiagram in all source files
- Change cmdlet name from New-WatermarkToImage to Add-AbrWatermarkToImage in all source files
- Change cmdlet name from New-WatermarkToSvg to Add-WatermarkToSvg in all source files
- Change default Main_Logo image from Diagrammer.png to AsBuiltReport.png
- Integrate PSGraph cmdlets to the module (Project without active maintenance)
- Update assembly references and add new project files for AbrDiagrammer and AbrDiaConvertImageToPDF

### :wrench: Fixed

- Fix initialization of $TRAditionalInfo array in Add-NodeIcon function
