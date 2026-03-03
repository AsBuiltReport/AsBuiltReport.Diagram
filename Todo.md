## High Priority

- [x] Finish implementing Format-HTMLTable
  - [x] Add-DiaNodeImage
  - [x] Add-DiaHTMLNodeTable
  - [x] Add-DiaHtmlSignatureTable
  - [x] Add-DiaHtmlSubgraph
  - [x] Add-DiaHtmlTable
  - [x] Add-DiaNodeText
- [ ] Add-DiaHTMLNodeTable
  - [x] Add Port to Subgraph section
  - [ ] Add option to set image size by percent and by pixels (width x height)
  - [ ] Add pester to test this funtionality
  - [ ] Add documentation for this funtionality
  - [ ] Add example for this funtionality
- [ ] Add function to dinamically build Table cells based on input hashtable use Format-HTMLTable as example
  - [ ] Add pester to test this funtionality
  - [ ] Add documentation for this funtionality
  - [ ] Add example for this funtionality

## Medium Priority

- [x] Add funtion (Add-DiaNodeEdge) to add edges between nodes
  - [x] Add pester to test this funtionality
  - [x] Add documentation for this funtionality
  - [x] Add example for this funtionality
  - [x] Add option to set edge style (solid, dashed, dotted, bold)
  - [x] Add option to set edge color (Hex color)
  - [x] Add option to set edge thickness (1-10)
  - [x] Add option to set edge arrow type (none, normal, vee, diamond)
  - [x] Add option to set edge label (string)
  - [x] Add option to set edge label font size (8-72)
  - [x] Add option to set edge label font color (Hex color)
  - [x] Add option to set tailport (string)
  - [x] Add option to set headport (string)

## Low Priority

- [ ] Create Pester tests for:
  - [ ] Add-DiaCrossShapeLine
  - [ ] Add-DiaTShapeLine
  - [ ] Add-DiaRightTShapeLine
  - [ ] Add-DiaInvertedLShapeLine
  - [ ] Add-DiaInvertedTShapeLine
  - [ ] Add-DiaLeftTShapeLine
  - [ ] Add-DiaLShapeLine
  - [ ] Add-DiaRightLShapeLine
  - [ ] Add-DiaLeftLShapeLine
- [ ] Add Documentation (use pscribo as example)
  - [ ] Add ShapeLine example
- [ ] Add option to set icon size by percent
  - [ ] Add pester to test this funtionality
- [x] Add NodeObject support see Add-DiaHTMLTable as example (use Join-Hashtable)
  - [ ] Add pester to test this funtionality
- [x] Research ways to add html label to edges to simulate enhanced connectivity
- [ ] Add support for Watermark in SVG output format
  - [ ] Use the Diagrammer c# package to add watermark support
- [ ] Add-DiaNodeImage
  - [ ] Add option to set image opacity in percent