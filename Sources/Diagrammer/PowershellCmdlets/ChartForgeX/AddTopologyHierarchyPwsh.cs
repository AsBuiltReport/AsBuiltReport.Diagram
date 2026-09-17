using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using ChartForgeX.Topology;

namespace AsBuiltReportDiagram.PowerShell.ChartForgeX
{
    /// <summary>
    /// Adds parent-child hierarchy items to a ChartForgeX TopologyChart.
    /// </summary>
    [Cmdlet(VerbsCommon.Add, "TopologyHierarchy")]
    [OutputType(typeof(TopologyChart))]
    public class AddTopologyHierarchyCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, HelpMessage = "The TopologyChart to add the hierarchy to.")]
        public TopologyChart Chart { get; set; } = null!;

        [Parameter(Mandatory = true, HelpMessage = "Hierarchy items. Each item must provide Id and Label; ParentId is optional.")]
        public PSObject[] Items { get; set; } = Array.Empty<PSObject>();

        [Parameter(HelpMessage = "Lowest primary visible hierarchy level.")]
        public int? MinLevel { get; set; }

        [Parameter(HelpMessage = "Highest visible hierarchy level.")]
        public int? MaxLevel { get; set; }

        [Parameter(HelpMessage = "Keep ancestors below MinLevel as context breadcrumbs.")]
        public SwitchParameter IncludeAncestorContext { get; set; }

        [Parameter(HelpMessage = "Level used for root items when levels are inferred.")]
        public int RootLevel { get; set; }

        [Parameter(HelpMessage = "Apply ChartForgeX layered layout to the hierarchy.")]
        public SwitchParameter ApplyLayeredLayout { get; set; }

        [Parameter(HelpMessage = "Layered flow direction.")]
        public TopologyLayoutDirection LayoutDirection { get; set; }

        [Parameter(HelpMessage = "Default layout policy inherited by hierarchy items that do not define one.")]
        public TopologyHierarchyLayoutPolicy LayoutPolicy { get; set; }

        [Parameter(HelpMessage = "Default generated node display mode.")]
        public TopologyNodeDisplayMode? NodeDisplayMode { get; set; }

        [Parameter(HelpMessage = "Default node width in pixels.")]
        public double NodeWidth { get; set; }

        [Parameter(HelpMessage = "Default node height in pixels.")]
        public double NodeHeight { get; set; }

        [Parameter(HelpMessage = "Generated hierarchy edge kind.")]
        public TopologyEdgeKind EdgeKind { get; set; }

        [Parameter(HelpMessage = "Generated hierarchy edge health state.")]
        public TopologyHealthStatus EdgeStatus { get; set; }

        [Parameter(HelpMessage = "Generated hierarchy edge direction.")]
        public global::ChartForgeX.Primitives.VisualLinkDirection EdgeDirection { get; set; }

        [Parameter(HelpMessage = "Generated hierarchy edge routing.")]
        public TopologyEdgeRouting EdgeRouting { get; set; }

        [Parameter(HelpMessage = "Preferred length of generated hierarchy edges for layout calculations.")]
        public double? EdgeLength { get; set; }

        [Parameter(HelpMessage = "Stroke width in pixels for generated hierarchy edges.")]
        public double? EdgeWidth { get; set; }

        [Parameter(HelpMessage = "Generated hierarchy edge ID prefix.")]
        public string? EdgeIdPrefix { get; set; }

        protected override void ProcessRecord()
        {
            var options = new TopologyHierarchyOptions();
            if (MyInvocation.BoundParameters.ContainsKey(nameof(MinLevel))) options.MinLevel = MinLevel;
            if (MyInvocation.BoundParameters.ContainsKey(nameof(MaxLevel))) options.MaxLevel = MaxLevel;
            if (MyInvocation.BoundParameters.ContainsKey(nameof(IncludeAncestorContext))) options.IncludeAncestorContext = IncludeAncestorContext;
            if (MyInvocation.BoundParameters.ContainsKey(nameof(RootLevel))) options.RootLevel = RootLevel;
            if (MyInvocation.BoundParameters.ContainsKey(nameof(ApplyLayeredLayout))) options.ApplyLayeredLayout = ApplyLayeredLayout;
            if (MyInvocation.BoundParameters.ContainsKey(nameof(LayoutDirection))) options.LayoutDirection = LayoutDirection;
            if (MyInvocation.BoundParameters.ContainsKey(nameof(LayoutPolicy))) options.LayoutPolicy = LayoutPolicy;
            if (MyInvocation.BoundParameters.ContainsKey(nameof(NodeDisplayMode))) options.NodeDisplayMode = NodeDisplayMode;
            if (MyInvocation.BoundParameters.ContainsKey(nameof(NodeWidth))) options.NodeWidth = NodeWidth;
            if (MyInvocation.BoundParameters.ContainsKey(nameof(NodeHeight))) options.NodeHeight = NodeHeight;
            if (MyInvocation.BoundParameters.ContainsKey(nameof(EdgeKind))) options.EdgeKind = EdgeKind;
            if (MyInvocation.BoundParameters.ContainsKey(nameof(EdgeStatus))) options.EdgeStatus = EdgeStatus;
            if (MyInvocation.BoundParameters.ContainsKey(nameof(EdgeDirection))) options.EdgeDirection = EdgeDirection;
            if (MyInvocation.BoundParameters.ContainsKey(nameof(EdgeRouting))) options.EdgeRouting = EdgeRouting;
            if (MyInvocation.BoundParameters.ContainsKey(nameof(EdgeIdPrefix))) options.EdgeIdPrefix = EdgeIdPrefix!;

            var hierarchyItems = new List<TopologyHierarchyItem>(Items.Length);
            foreach (var item in Items)
            {
                hierarchyItems.Add(CreateItem(item));
            }

            var existingEdgeIds = Chart.Edges
                .Select(edge => edge.Id)
                .ToHashSet(StringComparer.Ordinal);

            Chart = Chart.AddHierarchy(hierarchyItems, options);

            if (EdgeLength.HasValue || EdgeWidth.HasValue)
            {
                foreach (var edge in Chart.Edges.Where(edge => !existingEdgeIds.Contains(edge.Id)))
                {
                    if (EdgeLength.HasValue)
                    {
                        Chart = Chart.WithEdgeLayoutHints(edge.Id, EdgeLength, 1, 0);
                    }

                    if (EdgeWidth.HasValue)
                    {
                        Chart = Chart.WithEdgeStroke(edge.Id, EdgeWidth, null, []);
                    }
                }
            }

            WriteObject(Chart);
        }

        private static TopologyHierarchyItem CreateItem(PSObject source)
        {
            if (source.BaseObject is TopologyHierarchyItem hierarchyItem)
            {
                return hierarchyItem;
            }

            var id = GetRequiredValue<string>(source, "Id");
            var label = GetRequiredValue<string>(source, "Label");
            var item = new TopologyHierarchyItem(id, label, GetValue<string>(source, "ParentId"))
            {
                Level = GetValue<int?>(source, "Level"),
                Kind = GetValue<TopologyNodeKind?>(source, "Kind") ?? TopologyNodeKind.Generic,
                Status = GetValue<TopologyHealthStatus?>(source, "Status") ?? TopologyHealthStatus.Unknown,
                Subtitle = GetValue<string>(source, "Subtitle"),
                Symbol = GetValue<string>(source, "Symbol"),
                IconId = GetValue<string>(source, "IconId"),
                GroupId = GetValue<string>(source, "GroupId"),
                Color = GetValue<string>(source, "Color"),
                BackgroundColor = GetValue<string>(source, "BackgroundColor"),
                Width = GetValue<double?>(source, "Width"),
                Height = GetValue<double?>(source, "Height"),
                LayoutPolicy = GetValue<TopologyHierarchyLayoutPolicy?>(source, "LayoutPolicy")
            };

            if (GetRawValue(source, "Metadata") is IDictionary metadata)
            {
                foreach (DictionaryEntry entry in metadata)
                {
                    item.WithMetadata(
                        LanguagePrimitives.ConvertTo<string>(entry.Key),
                        LanguagePrimitives.ConvertTo<string>(entry.Value));
                }
            }

            return item;
        }

        private static T GetRequiredValue<T>(PSObject source, string name)
        {
            var value = GetValue<T>(source, name);
            if (value is null || value is string text && string.IsNullOrWhiteSpace(text))
            {
                throw new PSArgumentException($"Hierarchy item must provide a non-empty {name} property.");
            }

            return value;
        }

        private static T? GetValue<T>(PSObject source, string name)
        {
            var value = GetRawValue(source, name);
            if (value is null)
            {
                return default;
            }

            return LanguagePrimitives.ConvertTo<T>(value);
        }

        private static object? GetRawValue(PSObject source, string name)
        {
            if (source.BaseObject is IDictionary dictionary && dictionary.Contains(name))
            {
                return dictionary[name];
            }

            return source.Properties[name]?.Value;
        }
    }
}
