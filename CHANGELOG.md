# :arrows_clockwise: AsBuiltReport.Diagram Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.4] - 2026-03-16

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
