<p align="center">
    <a href="https://www.asbuiltreport.com/" alt="AsBuiltReport"></a>
            <img src='https://avatars.githubusercontent.com/u/42958564' width="8%" height="8%" /></a>
</p>
<p align="center">
    <a href="https://www.powershellgallery.com/packages/AsBuiltReport.Diagram/" alt="PowerShell Gallery Version">
        <img src="https://img.shields.io/powershellgallery/v/AsBuiltReport.Diagram.svg" /></a>
    <a href="https://www.powershellgallery.com/packages/AsBuiltReport.Diagram/" alt="PS Gallery Downloads">
        <img src="https://img.shields.io/powershellgallery/dt/AsBuiltReport.Diagram.svg" /></a>
    <a href="https://www.powershellgallery.com/packages/AsBuiltReport.Diagram/" alt="PS Platform">
        <img src="https://img.shields.io/powershellgallery/p/AsBuiltReport.Diagram.svg" /></a>
</p>
<p align="center">
    <a href="https://github.com/AsBuiltReport/AsBuiltReport.Diagram/graphs/commit-activity" alt="GitHub Last Commit">
        <img src="https://img.shields.io/github/last-commit/rebelinux/AsBuiltReport.Diagram/master.svg" /></a>
    <a href="https://raw.githubusercontent.com/rebelinux/AsBuiltReport.Diagram/master/LICENSE" alt="GitHub License">
        <img src="https://img.shields.io/github/license/rebelinux/AsBuiltReport.Diagram.svg" /></a>
    <a href="https://github.com/AsBuiltReport/AsBuiltReport.Diagram/graphs/contributors" alt="GitHub Contributors">
        <img src="https://img.shields.io/github/contributors/rebelinux/AsBuiltReport.Diagram.svg"/></a>
</p>
<p align="center">
    <a href="https://twitter.com/rebelinux" alt="Twitter">
            <img src="https://img.shields.io/twitter/follow/rebelinux.svg?style=social"/></a>
</p>

<p align="center">
    <a href='https://ko-fi.com/F1F8DEV80' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://ko-fi.com/img/githubbutton_sm.svg' border='0' alt='Want to keep alive this project? Support me on Ko-fi' /></a>
</p>

# AsBuiltReport.Diagram

AsBuiltReport.Diagram is a PowerShell module that provides a foundational framework for creating as-built diagrams of various datacenter systems. It serves as a required dependency for individual diagrammer modules, which generate diagrams tailored to specific products or technologies.

# :beginner: Getting Started

The following simple list of instructions will get you started with the AsBuiltReport.Diagram module.

## :floppy_disk: Supported Versions
### **PowerShell**
This module is compatible with the following PowerShell versions;

| Windows PowerShell 5.1 | Windows/Linux/MacOs PowerShell 7 |
| :--------------------: | :------------------------------: |
|   :white_check_mark:   |        :white_check_mark:        |

## :wrench: System Requirements

PowerShell 5.1/7, and the following PowerShell modules are required for generating a AsBuiltReport.Diagram diagram.

- [PSGraph Module](https://github.com/KevinMarquette/PSGraph)

## :package: Module Installation

### PowerShell
#### Online Installation

For an online installation, install the `AsBuiltReport.Diagram` module using the [PowerShell Gallery](https://www.powershellgallery.com/packages?q=AsBuiltReport.Diagram);

```powershell
# Install AsBuiltReport.Diagram module
Install-Module -Name 'AsBuiltReport.Diagram' -Repository 'PSGallery' -Scope 'CurrentUser'
```

#### Offline Installation

For an offline installation, perform the following steps from a machine with internet connectivity;

Save the required `AsBuiltReport.Diagram` module to a specified folder.

```powershell
# Save AsBuiltReport.Diagram module
Save-Module -Name 'AsBuiltReport.Diagram' -Repository 'PSGallery' -Path '<Folder Path>'
```

Copy the downloaded `AsBuiltReport.Diagram` module folder to a location that can be made accessible to the offline system.
e.g. USB Flash Drive, Internal File Share etc.

On the offline system, open a PowerShell console window and run the following command to determine the PowerShell module path.

**Windows**

```powershell title=""
$env:PSModulePath -Split ';'
```

Copy the downloaded `AsBuiltReport.Diagram` module folder to a folder specified in the `$env:PSModulePath` output.

#### Graphviz Linux/MacOS Installation

Linux & MacOs require the installation of Graphviz to be able to generate the diagram:

**Linux**

##### "Debian*, Ubuntu*"


```bash title="Debian*, Ubuntu*"
sudo apt install graphviz
```

##### "Fedora project*, Rocky Linux, Redhat Enterprise Linux, or CentOS*"

```bash title="Fedora project*, Rocky Linux, Redhat Enterprise Linux, or CentOS*"
sudo dnf install graphviz
```

**MacOs**

##### "MacPorts* provides both stable and development versions of Graphviz and the Mac GUI Graphviz.app. These can be obtained via the ports graphviz, graphviz-devel, graphviz-gui and graphviz-gui-devel."


```bash title="MacPorts"
sudo port install graphviz
```

##### "Homebrew* has a Graphviz port."

```bash title="Homebrew"
brew install graphviz
```

## :books: Documentation

The documentation for the `AsBuiltReport.Diagram` module can be found in the [Docs](https://diagrammer.techmyth.blog/).

### :blue_book: Example Index

All examples in the latest release of AsBuiltReport.Diagram can be found in the table below, each with a link to their documentation page.

| Name                                                 | Description                         | Module                |
| ---------------------------------------------------- | ----------------------------------- | --------------------- |
| [Example1](./Examples/Example01.ps1)                 | Node cmdlet                         | PSGraph               |
| [Example2](./Examples/Example02.ps1)                 | Edge cmdlet                         | PSGraph               |
| [Example3](./Examples/Example03.ps1)                 | Edge minlen attribute               | PSGraph               |
| [Example4](./Examples/Example04.ps1)                 | SubGraph cmdlet                     | PSGraph               |
| [Example5](./Examples/Example05.ps1)                 | Add-NodeIcon cmdlet                 | AsBuiltReport.Diagram |
| [Example6](./Examples/Example06.ps1)                 | DraftMode feature                   | AsBuiltReport.Diagram |
| [Example7](./Examples/Example07.ps1)                 | Rank cmdlet                         | PSGraph               |
| [Example8](./Examples/Example08.ps1)                 | Add-HtmlNodeTable cmdlet            | AsBuiltReport.Diagram |
| [Example9](./Examples/Example09.ps1)                 | Add-HtmlNodeTable MultiIcon feature | AsBuiltReport.Diagram |
| [Example10](./Examples/Example10.ps1)                | Add-NodeImage cmdlet                | AsBuiltReport.Diagram |
| [Example11](./Examples/Example11.ps1)                | Add-HtmlTable cmdlet                | AsBuiltReport.Diagram |
| [Example12](./Examples/Example12.ps1)                | WaterMark feature                   | AsBuiltReport.Diagram |
| [Example13](./Examples/Example13.ps1)                | Signature feature                   | AsBuiltReport.Diagram |
| [Example14](./Examples/Example14.ps1)                | Add-NodeShape cmdlet                | AsBuiltReport.Diagram |
| [Example15](./Examples/Example15.ps1)                | Add-NodeSpacer cmdlet               | AsBuiltReport.Diagram |
| [Example16](./Examples/Example16.ps1)                | Add-NodeEdge cmdlet                 | AsBuiltReport.Diagram |
| [Example17](./Examples/Example17.ps1)                | ShapeLine cmdlet                    | AsBuiltReport.Diagram |
| [AdvancedExample1](./Examples/AdvancedExample01.ps1) | Add-HtmlSubGraph cmdlet             | AsBuiltReport.Diagram |
| [AdvancedExample2](./Examples/AdvancedExample02.ps1) | Add-NodeText cmdlet                 | AsBuiltReport.Diagram |


## :x: Known Issues
