using System;
using System.IO;
using System.Management.Automation;

namespace Diagrammer.PowerShell
{
    [Cmdlet(VerbsCommon.New, "WatermarkToSvg")]
    public class AddWatermarkToSvgCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, HelpMessage = "Path to the source SVG file.")]
        public FileInfo? SourceSvgFilePath { get; set; }

        [Parameter(Mandatory = true, HelpMessage = "Text to be used as the watermark.")]
        public string? WatermarkText { get; set; }

        [Parameter(Mandatory = true, HelpMessage = "Path to save the SVG file with the watermark.")]
        public FileInfo? OutputSvgFilePath { get; set; }

        [Parameter(Mandatory = false, HelpMessage = "Font size for the watermark text.")]
        public int WatermarkTextFontSize { get; set; } = 0;

        [Parameter(Mandatory = false, HelpMessage = "Color for the watermark text.")]
        public System.Drawing.Color WatermarkTextFontColor { get; set; } = System.Drawing.Color.Red;

        [Parameter(Mandatory = false, HelpMessage = "Font name for the watermark text.")]
        public string WatermarkTextFontName { get; set; } = "Arial";

        [Parameter(Mandatory = false, HelpMessage = "Opacity for the watermark text.")]
        public float WatermarkTextOpacity { get; set; } = 0.3f;

        [Parameter(Mandatory = false, HelpMessage = "Rotation angle in degrees for the watermark text.")]
        public int WatermarkTextAngle { get; set; } = -45;

        protected override void ProcessRecord()
        {
            if (SourceSvgFilePath == null || SourceSvgFilePath.FullName == null || !SourceSvgFilePath.Exists)
            {
                WriteError(new ErrorRecord(new FileNotFoundException($"The specified SVG file '{SourceSvgFilePath}' does not exist."), "FileNotFound", ErrorCategory.InvalidArgument, SourceSvgFilePath));
                return;
            }

            if (OutputSvgFilePath == null || OutputSvgFilePath.FullName == null)
            {
                WriteError(new ErrorRecord(new ArgumentException("Output SVG file path is invalid."), "InvalidOutputPath", ErrorCategory.InvalidArgument, OutputSvgFilePath));
                return;
            }

            bool result = ImageProcessor.AddWatermarkToSvg(
                SourceSvgFilePath.FullName,
                WatermarkText ?? string.Empty,
                OutputSvgFilePath.FullName,
                WatermarkTextFontSize,
                WatermarkTextFontColor,
                WatermarkTextFontName,
                WatermarkTextOpacity,
                WatermarkTextAngle
            );

            if (result)
            {
                WriteObject(result);
            }
            else
            {
                WriteError(new ErrorRecord(new IOException("Failed to add watermark to SVG."), "WatermarkProcessingFailed", ErrorCategory.WriteError, SourceSvgFilePath));
            }
        }
    }
}
