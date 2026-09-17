using System.Management.Automation;
using ChartForgeX.Topology;

namespace AsBuiltReportDiagram.PowerShell.ChartForgeX
{
    /// <summary>
    /// Adds a Node, Edge, or Status entry to a ChartForgeX TopologyLegend.
    /// </summary>
    [Cmdlet(VerbsCommon.Add, "TopologyLegendItem", DefaultParameterSetName = "Node")]
    [OutputType(typeof(TopologyLegend))]
    public class AddTopologyLegendItemCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, HelpMessage = "The TopologyLegend to add the item to.")]
        public TopologyLegend Legend { get; set; } = null!;

        [Parameter(Mandatory = true, HelpMessage = "Label displayed next to the legend entry.")]
        public string Label { get; set; } = string.Empty;

        [Parameter(HelpMessage = "Entry color (hex).")]
        public string? Color { get; set; }

        [Parameter(Mandatory = true, ParameterSetName = "Node", HelpMessage = "Node kind this legend entry represents.")]
        public TopologyNodeKind? NodeKind { get; set; }

        [Parameter(ParameterSetName = "Node", HelpMessage = "Short symbol/abbreviation shown in the legend swatch.")]
        public string? Symbol { get; set; }

        [Parameter(ParameterSetName = "Node", HelpMessage = "Background fill color of the legend swatch (hex).")]
        public string? BackgroundColor { get; set; }

        [Parameter(ParameterSetName = "Node", HelpMessage = "Built-in catalog icon id shown in the legend swatch.")]
        public string? IconId { get; set; }

        [Parameter(Mandatory = true, ParameterSetName = "Edge", HelpMessage = "Edge kind this legend entry represents.")]
        public TopologyEdgeKind? EdgeKind { get; set; }

        [Parameter(ParameterSetName = "Edge", HelpMessage = "Line style of the legend swatch.")]
        public TopologyEdgeLineStyle LineStyle { get; set; } = TopologyEdgeLineStyle.Solid;

        [Parameter(Mandatory = true, ParameterSetName = "Status", HelpMessage = "Health status this legend entry represents.")]
        public TopologyHealthStatus? Status { get; set; }

        protected override void ProcessRecord()
        {
            switch (ParameterSetName)
            {
                case "Node":
                    Legend.AddNodeKind(Label, NodeKind!.Value, Color ?? string.Empty, Symbol ?? string.Empty, BackgroundColor ?? string.Empty, IconId ?? string.Empty);
                    break;
                case "Edge":
                    Legend.AddEdgeKind(Label, EdgeKind!.Value, Color ?? string.Empty, LineStyle);
                    break;
                case "Status":
                    Legend.AddStatus(Label, Status!.Value, Color ?? string.Empty);
                    break;
            }

            WriteObject(Legend);
        }
    }
}
