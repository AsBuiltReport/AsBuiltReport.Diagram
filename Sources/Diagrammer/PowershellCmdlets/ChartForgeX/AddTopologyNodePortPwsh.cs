using System.Management.Automation;
using ChartForgeX.Topology;

namespace AsBuiltReportDiagram.PowerShell.ChartForgeX
{
    /// <summary>
    /// Adds a named attachment port to a node for use by topology edges.
    /// </summary>
    [Cmdlet(VerbsCommon.Add, "TopologyNodePort")]
    [OutputType(typeof(TopologyChart))]
    public class AddTopologyNodePortCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, ValueFromPipeline = true, HelpMessage = "The TopologyChart containing the node.")]
        public TopologyChart Chart { get; set; } = null!;

        [Parameter(Mandatory = true, HelpMessage = "Identifier of the node that owns the port.")]
        public string NodeId { get; set; } = string.Empty;

        [Parameter(Mandatory = true, HelpMessage = "Unique identifier for the port on the node.")]
        public string Id { get; set; } = string.Empty;

        [Parameter(HelpMessage = "Node side where the port is attached.")]
        public TopologyEdgePort Side { get; set; } = TopologyEdgePort.Auto;

        [Parameter(HelpMessage = "Position along the selected node side.")]
        public double Offset { get; set; }

        [Parameter(HelpMessage = "Optional label rendered with the port.")]
        public string? Label { get; set; }

        protected override void ProcessRecord()
        {
            Chart = Chart.AddNodePort(NodeId, Id, Side, Offset, Label ?? string.Empty);
            WriteObject(Chart);
        }
    }
}
