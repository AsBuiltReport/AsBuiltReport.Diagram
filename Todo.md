## High Priority
- [ ] Add-HtmlNodeTable
  - [x] Add Port to Subgraph section
  - [ ] Add option to set image size by percent and by pixels (width x height)
  - [x] In -MultiIcon mode, only the label TD gets a PORT (`PORT="{Element}"`) — the icon TD above it has no port at all. This means edges targeting a specific element (e.g. `"NodeName":"SpokeLabel"`) always land on the label cell, never the icon, even though single-icon (non-MultiIcon) nodes naturally let edges land on the icon since the whole node is the target. Add a dedicated port to the icon TD (e.g. `PORT="Icon_{Element}"`, keeping the existing label port intact for backwards compatibility) so consumers can choose to route edges onto the icon instead of the label.
  - [x] Bug: `-MultiIcon` + multi-key `-AditionalInfo` mis-renders when the group has exactly 1 item — each array value is stringified as its .NET type name (e.g. `System.Object[]`) instead of its actual content.
    - Repro:
      ```powershell
      Add-HtmlNodeTable -Name Test -ImagesObj $Images -inputObject @('vnet-spoke-mgmt') -iconType 'VNet' -MultiIcon `
          -AditionalInfo ([Ordered]@{ 'Address Space' = @('10.3.0.0/16'); 'Role' = @('Spoke') }) -NodeObject
      ```
      Produces `<TD>Address Space: System.Object[]</TD>` / `<TD>Role: System.Object[]</TD>` instead of `Address Space: 10.3.0.0/16` / `Role: Spoke`. Works correctly with 2+ items in the group.
    - Root cause: the `AditionalInfo` rendering branch-selects on counts alone (`$RowsGroupHTs.Keys.Count`, `.Values.Count`, `$inputObject.Count -le 1`), not on whether `-MultiIcon` was specified or whether the `-AditionalInfo` values are actually arrays. With exactly 1 input item and 2+ `-AditionalInfo` keys, it takes the "multiple keys, each a single scalar value" branch (correct for non-MultiIcon single-node usage) against array-valued MultiIcon data, and `[string]$Element.Values` on a one-element array falls back to printing the CLR type name instead of joining its contents. Present in both the `-IconDebug` and normal rendering paths (same three-way branch duplicated in each).
    - Fix: added an `$AditionalInfoHasArrayValues` check (true whenever any `-AditionalInfo` value is array-typed) as an extra required condition on the two scalar-value branches, in all 4 duplicated occurrences, forcing array-valued data into the existing `Split-ArrayElement`-based branch regardless of `$inputObject.Count`. Also fixed a second, previously-latent bug this exposed in that same branch: `($RowsGroupHT.GetEnumerator() | ForEach-Object { $_.value })` collapses to a bare scalar (not a 1-element array) when the value array has exactly 1 element, which `Split-ArrayElement` then mis-indexes as a string, returning a single character; fixed by wrapping with `@(...)`.
    - [x] Add pester to test this functionality
    - [x] Add documentation for this functionality
  - [x] Add pester to test this funtionality
  - [x] Add documentation for this funtionality
  - [x] Add example for this funtionality
- [x] Add function to dinamically build Table cells based on input use Format-HTMLTable as example
  - [x] Add pester to test this funtionality
  - [x] Add documentation for this funtionality
  - [x] Add example for this funtionality

## Medium Priority


## Low Priority

- [ ] Add option to set icon size by percent
  - [ ] Add pester to test this funtionality