using System.Management.Automation;
using ChartForgeX.Topology;

namespace AsBuiltReportDiagram.PowerShell.ChartForgeX
{
    /// <summary>
    /// Adds a node to a ChartForgeX TopologyChart. Supports plain nodes, built-in icon shapes (-IconShape)
    /// and custom image icons (-IconHref, typically a data: URI produced by ConvertTo-Base64).
    /// </summary>
    [Cmdlet(VerbsCommon.Add, "TopologyNode")]
    [OutputType(typeof(TopologyChart))]
    public class AddTopologyNodeCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, HelpMessage = "The TopologyChart to add the node to.")]
        public TopologyChart Chart { get; set; } = null!;

        [Parameter(Mandatory = true, HelpMessage = "Unique identifier for the node.")]
        public string Id { get; set; } = string.Empty;

        [Parameter(Mandatory = true, HelpMessage = "Display label for the node.")]
        public string Label { get; set; } = string.Empty;

        [Parameter(HelpMessage = "X coordinate. Ignored by auto layout modes.")]
        public double X { get; set; }

        [Parameter(HelpMessage = "Y coordinate. Ignored by auto layout modes.")]
        public double Y { get; set; }

        [Parameter(HelpMessage = "Semantic node kind (Server, Database, Cloud, etc.).")]
        public TopologyNodeKind Kind { get; set; } = TopologyNodeKind.Generic;

        [Parameter(HelpMessage = "Health status badge.")]
        public TopologyHealthStatus Status { get; set; } = TopologyHealthStatus.Unknown;

        [Parameter(HelpMessage = "Identifier of the group/cluster this node belongs to.")]
        public string? GroupId { get; set; }

        [Parameter(HelpMessage = "Secondary line of text under the label.")]
        public string? Subtitle { get; set; }

        [Parameter(HelpMessage = "Hyperlink applied to the node in HTML/SVG output.")]
        public string? Href { get; set; }

        [Parameter(HelpMessage = "Tooltip text shown on hover.")]
        public string? Tooltip { get; set; }

        [Parameter(HelpMessage = "Node width in pixels.")]
        public double Width { get; set; } = 150;

        [Parameter(HelpMessage = "Node height in pixels.")]
        public double Height { get; set; } = 64;

        [Parameter(HelpMessage = "Short symbol/abbreviation rendered inside built-in icon shapes.")]
        public string? Symbol { get; set; }

        [Parameter(HelpMessage = "CSS class applied to the node in HTML/SVG output.")]
        public string? CssClass { get; set; }

        [Parameter(HelpMessage = "Foreground/accent color (hex).")]
        public string? Color { get; set; }

        [Parameter(HelpMessage = "Background fill color (hex).")]
        public string? BackgroundColor { get; set; }

        [Parameter(HelpMessage = "Built-in renderer icon shape hint, e.g. Server, Database, Cloud.")]
        public TopologyIconShape? IconShape { get; set; }

        [Parameter(HelpMessage = "Custom icon image reference: a data: URI, absolute URL, or renderer-safe asset path.")]
        public string? IconHref { get; set; }

        [Parameter(HelpMessage = "SVG viewBox to use with -IconHref, e.g. '0 0 32 32'.")]
        public string IconViewBox { get; set; } = "0 0 32 32";

        [Parameter(HelpMessage = "Node display mode (Card, Icon, Artwork, Pill, Dot, Hidden, etc.).")]
        public TopologyNodeDisplayMode? DisplayMode { get; set; }

        protected override void ProcessRecord()
        {
            if (!string.IsNullOrEmpty(IconHref))
            {
                var artwork = TopologyIconArtwork.Image(IconHref, IconViewBox);
                // Card (not Artwork) is the default so the node label renders alongside the custom
                // icon; ChartForgeX's Artwork display mode intentionally omits the label text.
                var displayMode = DisplayMode ?? TopologyNodeDisplayMode.Card;
                Chart = Chart.AddArtworkNode(
                    Id, Label, artwork, X, Y, Kind, Status, GroupId ?? string.Empty, Subtitle ?? string.Empty,
                    Href ?? string.Empty, Tooltip ?? string.Empty, Width, Height, Symbol ?? string.Empty,
                    CssClass ?? string.Empty, Color ?? string.Empty, BackgroundColor ?? string.Empty, displayMode);
            }
            else
            {
                Chart = Chart.AddNode(
                    Id, Label, X, Y, Kind, Status, GroupId ?? string.Empty, Subtitle ?? string.Empty,
                    Href ?? string.Empty, Tooltip ?? string.Empty, Width, Height, Symbol ?? string.Empty,
                    CssClass ?? string.Empty, Color ?? string.Empty, string.Empty, BackgroundColor ?? string.Empty);

                if (IconShape.HasValue)
                {
                    Chart = Chart.WithNodeIcon(Id, IconShape.Value.ToString());
                }

                if (DisplayMode.HasValue)
                {
                    Chart = Chart.WithNodeDisplay(Id, DisplayMode.Value, string.Empty);
                }
            }

            WriteObject(Chart);
        }
    }
}
