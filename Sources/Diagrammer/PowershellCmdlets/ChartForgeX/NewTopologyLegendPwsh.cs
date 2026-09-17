using System.Management.Automation;
using ChartForgeX.Topology;

namespace AsBuiltReportDiagram.PowerShell.ChartForgeX
{
    /// <summary>
    /// Creates a new ChartForgeX TopologyLegend, optionally seeded with the built-in defaults.
    /// Populate it with Add-TopologyLegendItem, then attach it with Set-TopologyChartLegend.
    /// </summary>
    [Cmdlet(VerbsCommon.New, "TopologyLegend")]
    [OutputType(typeof(TopologyLegend))]
    public class NewTopologyLegendCommand : PSCmdlet
    {
        [Parameter(HelpMessage = "Legend title.")]
        public string Title { get; set; } = "Legend";

        [Parameter(HelpMessage = "Seed the legend with ChartForgeX's built-in default entries.")]
        public SwitchParameter UseDefaults { get; set; }

        protected override void ProcessRecord()
        {
            var legend = UseDefaults.IsPresent ? TopologyLegend.Default() : TopologyLegend.Create(Title);
            if (!UseDefaults.IsPresent)
            {
                legend.Title = Title;
            }

            WriteObject(legend);
        }
    }
}
