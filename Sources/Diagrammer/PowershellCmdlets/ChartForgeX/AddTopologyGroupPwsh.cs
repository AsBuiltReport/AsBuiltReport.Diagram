using System.Management.Automation;
using ChartForgeX.Topology;

namespace AsBuiltReportDiagram.PowerShell.ChartForgeX
{
    /// <summary>
    /// Adds a logical group/cluster region to a ChartForgeX TopologyChart (equivalent to a Graphviz subgraph/cluster).
    /// </summary>
    [Cmdlet(VerbsCommon.Add, "TopologyGroup")]
    [OutputType(typeof(TopologyChart))]
    public class AddTopologyGroupCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, HelpMessage = "The TopologyChart to add the group to.")]
        public TopologyChart Chart { get; set; } = null!;

        [Parameter(Mandatory = true, HelpMessage = "Unique identifier for the group.")]
        public string Id { get; set; } = string.Empty;

        [Parameter(Mandatory = true, HelpMessage = "Display label for the group.")]
        public string Label { get; set; } = string.Empty;

        [Parameter(HelpMessage = "X coordinate. Ignored by auto layout modes.")]
        public double X { get; set; }

        [Parameter(HelpMessage = "Y coordinate. Ignored by auto layout modes.")]
        public double Y { get; set; }

        [Parameter(HelpMessage = "Group width in pixels.")]
        public double Width { get; set; } = 320;

        [Parameter(HelpMessage = "Group height in pixels.")]
        public double Height { get; set; } = 240;

        [Parameter(HelpMessage = "Health status badge.")]
        public TopologyHealthStatus Status { get; set; } = TopologyHealthStatus.Unknown;

        [Parameter(HelpMessage = "Secondary line of text under the label.")]
        public string? Subtitle { get; set; }

        [Parameter(HelpMessage = "Foreground/accent color (hex).")]
        public string? Color { get; set; }

        [Parameter(HelpMessage = "Built-in catalog icon id shown in the group header.")]
        public string? IconId { get; set; }

        protected override void ProcessRecord()
        {
            Chart = Chart.AddGroup(
                Id, Label, X, Y, Width, Height, Status, Subtitle ?? string.Empty,
                string.Empty, string.Empty, string.Empty, string.Empty, Color ?? string.Empty, IconId ?? string.Empty);

            WriteObject(Chart);
        }
    }
}
