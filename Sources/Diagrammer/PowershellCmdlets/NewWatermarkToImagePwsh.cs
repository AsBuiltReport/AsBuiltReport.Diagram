using System;
using System.IO;
using System.Management.Automation;
using iText.Layout.Element;

namespace Diagrammer.PowerShell
{
    [Cmdlet(VerbsCommon.New, "WatermarkToImage")]
    public class AddWatermarkToImageCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, HelpMessage = "Path to the source image file.")]
        public string? SourceImagePath { get; set; }

        [Parameter(Mandatory = true, HelpMessage = "Text to be used as the watermark.")]
        public string? WatermarkText { get; set; }

        [Parameter(Mandatory = true, HelpMessage = "Path to save the image file with the watermark.")]
        public FileInfo? OutputImageFilePath { get; set; }

        [Parameter(Mandatory = false, HelpMessage = "Font size for the watermark text.")]
        public int WatermarkTextFontSize { get; set; } = 24;

        [Parameter(Mandatory = false, HelpMessage = "Color for the watermark text.")]
        public System.Drawing.Color WatermarkTextFontColor { get; set; } = System.Drawing.Color.Red;

        [Parameter(Mandatory = false, HelpMessage = "Font name for the watermark text.")]
        public string WatermarkTextFontName { get; set; } = "Arial";

        [Parameter(Mandatory = false, HelpMessage = "Opacity for the watermark text.")]
        public float WatermarkTextOpacity { get; set; } = 0.7f;

        [Parameter(Mandatory = false, HelpMessage = "Path to the font file for the watermark text.")]
        public string WatermarkTextFontPath { get; set; } = "";

        protected override void ProcessRecord()
        {
            if (SourceImagePath != null && File.Exists(SourceImagePath))
            {
                bool result = ImageProcessor.AddWatermarkToImage(SourceImagePath, WatermarkText ?? string.Empty, OutputImageFilePath?.FullName ?? SourceImagePath, WatermarkTextFontSize, WatermarkTextFontColor, WatermarkTextFontName, WatermarkTextOpacity, WatermarkTextFontPath);
                if (result)
                {
                    WriteObject(result);
                }
                else
                {
                    WriteError(new ErrorRecord(new IOException("Failed to add watermark to image."), "WatermarkProcessingFailed", ErrorCategory.WriteError, SourceImagePath));
                }
            }
            else
            {
                WriteError(new ErrorRecord(new ArgumentException("The source image path is invalid."), "InvalidSourcePath", ErrorCategory.InvalidArgument, SourceImagePath));
            }
        }
    }
}