using System.Management.Automation;
using ChartForgeX.Topology;

namespace AsBuiltReportDiagram.PowerShell.ChartForgeX
{
    /// <summary>
    /// Adds an edge (connection) between two nodes in a ChartForgeX TopologyChart.
    /// </summary>
    [Cmdlet(VerbsCommon.Add, "TopologyEdge")]
    [OutputType(typeof(TopologyChart))]
    public class AddTopologyEdgeCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, HelpMessage = "The TopologyChart to add the edge to.")]
        public TopologyChart Chart { get; set; } = null!;

        [Parameter(Mandatory = true, HelpMessage = "Unique identifier for the edge.")]
        public string Id { get; set; } = string.Empty;

        [Parameter(Mandatory = true, HelpMessage = "Identifier of the source node.")]
        public string SourceId { get; set; } = string.Empty;

        [Parameter(Mandatory = true, HelpMessage = "Identifier of the target node.")]
        public string TargetId { get; set; } = string.Empty;

        [Parameter(HelpMessage = "Label displayed on the edge.")]
        public string? Label { get; set; }

        [Parameter(HelpMessage = "Semantic edge kind (Link, Dependency, Trust, DataFlow, etc.).")]
        public TopologyEdgeKind Kind { get; set; } = TopologyEdgeKind.Generic;

        [Parameter(HelpMessage = "Health status badge.")]
        public TopologyHealthStatus Status { get; set; } = TopologyHealthStatus.Unknown;

        [Parameter(HelpMessage = "Arrow direction.")]
        public global::ChartForgeX.Primitives.VisualLinkDirection Direction { get; set; } = global::ChartForgeX.Primitives.VisualLinkDirection.Forward;

        [Parameter(HelpMessage = "Edge routing style.")]
        public TopologyEdgeRouting Routing { get; set; } = TopologyEdgeRouting.Orthogonal;

        [Parameter(HelpMessage = "Foreground/accent color (hex).")]
        public string? Color { get; set; }

        [Parameter(HelpMessage = "Tooltip text shown on hover.")]
        public string? Tooltip { get; set; }

        [Parameter(HelpMessage = "Line style override (Solid, Dashed, Dotted).")]
        public TopologyEdgeLineStyle? LineStyle { get; set; }

        [Parameter(HelpMessage = "Relative line prominence (Normal, Subtle, Strong).")]
        public TopologyEdgeEmphasis? Emphasis { get; set; }

        [Parameter(HelpMessage = "Named port ID on the source node.")]
        public string? SourcePortId { get; set; }

        [Parameter(HelpMessage = "Named port ID on the target node.")]
        public string? TargetPortId { get; set; }

        [Parameter(HelpMessage = "Explicit source endpoint marker (None, Arrow, Circle, Diamond).")]
        public TopologyMarkerKind? SourceMarker { get; set; }

        [Parameter(HelpMessage = "Explicit target endpoint marker (None, Arrow, Circle, Diamond).")]
        public TopologyMarkerKind? TargetMarker { get; set; }

        [Parameter(HelpMessage = "Edge-specific stroke width in pixels.")]
        public double? StrokeWidth { get; set; }

        [Parameter(HelpMessage = "Edge-specific opacity from zero to one.")]
        public double? Opacity { get; set; }

        [Parameter(HelpMessage = "Alternating dash and gap lengths in pixels.")]
        public double[]? DashPattern { get; set; }

        [Parameter(HelpMessage = "Label displayed near the source endpoint.")]
        public string? SourceLabel { get; set; }

        [Parameter(HelpMessage = "Label displayed near the target endpoint.")]
        public string? TargetLabel { get; set; }

        [Parameter(HelpMessage = "Preferred spring length for force-directed layouts.")]
        public double? PreferredLength { get; set; }

        [Parameter(HelpMessage = "Preferred minimum layer separation for layered layouts.")]
        public int? MinimumRankSpan { get; set; }

        [Parameter(HelpMessage = "Routing and rendering priority; higher values render above lower values.")]
        public int? RoutingPriority { get; set; }

        protected override void ProcessRecord()
        {
            Chart = Chart.AddEdge(
                Id, SourceId, TargetId, Label ?? string.Empty, Kind, Status, Direction, Routing,
                string.Empty, string.Empty, Tooltip ?? string.Empty, string.Empty, string.Empty, Color ?? string.Empty);

            if (LineStyle.HasValue)
            {
                Chart = Chart.WithEdgeLineStyle(Id, LineStyle.Value);
            }

            if (Emphasis.HasValue)
            {
                Chart = Chart.WithEdgeEmphasis(Id, Emphasis.Value);
            }

            if (!string.IsNullOrEmpty(SourcePortId) || !string.IsNullOrEmpty(TargetPortId))
            {
                Chart = Chart.WithEdgeNamedPorts(Id, SourcePortId ?? string.Empty, TargetPortId ?? string.Empty);
            }

            if (SourceMarker.HasValue || TargetMarker.HasValue)
            {
                Chart = Chart.WithEdgeMarkers(Id, SourceMarker, TargetMarker);
            }

            if (StrokeWidth.HasValue || Opacity.HasValue || DashPattern is not null)
            {
                Chart = Chart.WithEdgeStroke(Id, StrokeWidth, Opacity, DashPattern ?? []);
            }

            if (!string.IsNullOrEmpty(SourceLabel) || !string.IsNullOrEmpty(TargetLabel))
            {
                Chart = Chart.WithEdgeEndpointLabels(Id, SourceLabel ?? string.Empty, TargetLabel ?? string.Empty);
            }

            if (PreferredLength.HasValue || MinimumRankSpan.HasValue || RoutingPriority.HasValue)
            {
                Chart = Chart.WithEdgeLayoutHints(Id, PreferredLength, MinimumRankSpan ?? 0, RoutingPriority ?? 0);
            }

            WriteObject(Chart);
        }
    }
}
