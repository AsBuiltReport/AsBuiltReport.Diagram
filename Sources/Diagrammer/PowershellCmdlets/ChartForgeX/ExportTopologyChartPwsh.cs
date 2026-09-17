using System;
using System.IO;
using System.Management.Automation;
using ChartForgeX.Topology;

namespace AsBuiltReportDiagram.PowerShell.ChartForgeX
{
    /// <summary>
    /// Renders a ChartForgeX TopologyChart to disk in one of the supported output formats.
    /// </summary>
    [Cmdlet(VerbsData.Export, "TopologyChart")]
    [OutputType(typeof(FileInfo))]
    public class ExportTopologyChartCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, HelpMessage = "The TopologyChart to render.")]
        public TopologyChart Chart { get; set; } = null!;

        [Parameter(Mandatory = true, HelpMessage = "Folder the rendered file will be written to.")]
        public string OutputFolderPath { get; set; } = string.Empty;

        [Parameter(Mandatory = true, HelpMessage = "Output file name, without extension.")]
        public string Filename { get; set; } = string.Empty;

        [Parameter(HelpMessage = "Output format.")]
        [ValidateSet("svg", "png", "html", "bmp", "gif", "tiff", "ppm", "apng")]
        public string Format { get; set; } = "svg";

        protected override void ProcessRecord()
        {
            var extension = Format.ToLowerInvariant();
            var path = Path.Combine(OutputFolderPath, $"{Filename}.{extension}");

            switch (extension)
            {
                case "svg":
                    Chart.SaveSvg(path);
                    break;
                case "png":
                    Chart.SavePng(path);
                    break;
                case "html":
                    Chart.SaveHtml(path);
                    break;
                case "bmp":
                    Chart.SaveBmp(path);
                    break;
                case "gif":
                    Chart.SaveGif(path);
                    break;
                case "tiff":
                    Chart.SaveTiff(path);
                    break;
                case "ppm":
                    Chart.SavePpm(path);
                    break;
                case "apng":
                    Chart.SaveApng(path);
                    break;
                default:
                    throw new ArgumentOutOfRangeException(nameof(Format), Format, "Unsupported ChartForgeX export format.");
            }

            WriteObject(new FileInfo(path));
        }
    }
}
