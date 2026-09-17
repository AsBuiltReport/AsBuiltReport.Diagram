using System.Management.Automation;
using ChartForgeX.Topology;

namespace AsBuiltReportDiagram.PowerShell.ChartForgeX
{
    /// <summary>
    /// Creates a new ChartForgeX TopologyChart used as the root object for the AsBuiltReport.Diagram
    /// ChartForgeX-based DSL (New-AbrTopologyDiagram / Add-AbrTopologyNode / Add-AbrTopologyEdge / Export-AbrTopologyDiagram).
    /// </summary>
    [Cmdlet(VerbsCommon.New, "TopologyChart")]
    [OutputType(typeof(TopologyChart))]
    public class NewTopologyChartCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, HelpMessage = "Unique identifier for the diagram.")]
        public string Id { get; set; } = string.Empty;

        [Parameter(HelpMessage = "Diagram title.")]
        public string? Title { get; set; }

        [Parameter(HelpMessage = "Diagram subtitle.")]
        public string? Subtitle { get; set; }

        [Parameter(HelpMessage = "Layout algorithm used to arrange nodes.")]
        public TopologyLayoutMode LayoutMode { get; set; } = TopologyLayoutMode.Layered;

        [Parameter(HelpMessage = "Direction the layout should flow.")]
        public TopologyLayoutDirection LayoutDirection { get; set; } = TopologyLayoutDirection.TopToBottom;

        [Parameter(HelpMessage = "Built-in color theme (Light or Dark).")]
        public string? Theme { get; set; }

        protected override void ProcessRecord()
        {
            var chart = TopologyChart.Create()
                .WithId(Id)
                .WithLayout(LayoutMode, LayoutDirection);

            if (!string.IsNullOrEmpty(Title))
            {
                chart = chart.WithTitle(Title);
            }

            if (!string.IsNullOrEmpty(Subtitle))
            {
                chart = chart.WithSubtitle(Subtitle);
            }

            if (!string.IsNullOrEmpty(Theme))
            {
                var theme = Theme.Equals("Dark", System.StringComparison.OrdinalIgnoreCase) ? TopologyTheme.Dark() : TopologyTheme.Light();
                chart = chart.WithTheme(theme);
            }

            WriteObject(chart);
        }
    }
}
