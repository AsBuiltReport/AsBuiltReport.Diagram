using System;
using System.IO;
using System.Management.Automation;

namespace AsBuiltReportDiagram.PowerShell
{
    [Cmdlet(VerbsCommon.Set, "ImageOpacity")]
    public class SetImageOpacityCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, HelpMessage = "Path to the source image file.")]
        public FileInfo SourceImageFilePath { get; set; }

        [Parameter(Mandatory = true, HelpMessage = "Path to save the opacity-adjusted image file.")]
        public FileInfo OutputImageFilePath { get; set; }

        [Parameter(Mandatory = true, HelpMessage = "Opacity percentage to apply to the image (1-100).")]
        [ValidateRange(1, 100)]
        public int Opacity { get; set; }

        protected override void ProcessRecord()
        {
            if (SourceImageFilePath != null && SourceImageFilePath.FullName != null && SourceImageFilePath.Exists)
            {
                if (OutputImageFilePath != null && OutputImageFilePath.FullName != null)
                {
                    bool result = ImageProcessor.SetImageOpacity(SourceImageFilePath.FullName, Opacity, OutputImageFilePath.FullName);
                    if (result)
                    {
                        WriteObject(result);
                    }
                    else
                    {
                        WriteError(new ErrorRecord(new IOException($"Failed to set opacity on image: {SourceImageFilePath}"), "FileProcessingFailed", ErrorCategory.WriteError, SourceImageFilePath));
                    }
                }
                else
                {
                    WriteError(new ErrorRecord(new ArgumentException("Output image file path is invalid."), "InvalidOutputPath", ErrorCategory.InvalidArgument, OutputImageFilePath));
                }
            }
            else
            {
                WriteError(new ErrorRecord(new FileNotFoundException($"The specified image file '{SourceImageFilePath}' does not exist."), "FileNotFound", ErrorCategory.InvalidArgument, SourceImageFilePath));
            }
        }
    }
}
