using System.Management.Automation;
using ChartForgeX.Topology;

namespace AsBuiltReportDiagram.PowerShell.ChartForgeX
{
    /// <summary>
    /// Attaches a TopologyLegend to a TopologyChart.
    /// </summary>
    [Cmdlet(VerbsCommon.Set, "TopologyChartLegend")]
    [OutputType(typeof(TopologyChart))]
    public class SetTopologyChartLegendCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, HelpMessage = "The TopologyChart to attach the legend to.")]
        public TopologyChart Chart { get; set; } = null!;

        [Parameter(Mandatory = true, HelpMessage = "The TopologyLegend to attach.")]
        public TopologyLegend Legend { get; set; } = null!;

        protected override void ProcessRecord()
        {
            Chart = Chart.WithLegend(Legend);
            WriteObject(Chart);
        }
    }
}
