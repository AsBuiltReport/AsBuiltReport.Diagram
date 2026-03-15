using System;
using System.IO;
using System.Management.Automation;

namespace AsBuiltReportDiagram.PowerShell
{
    [Cmdlet(VerbsCommon.Get, "ResizeImageFromFile")]
    public class GetResizeImageFromFileCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, HelpMessage = "Path to the source image file.")]
        public FileInfo? SourceImageFilePath { get; set; }

        [Parameter(Mandatory = true, HelpMessage = "Path to save the resized image file.")]
        public FileInfo? OutputImageFilePath { get; set; }

        [Parameter(Mandatory = true, HelpMessage = "New width for the resized image.")]
        public int NewWidth { get; set; }

        [Parameter(Mandatory = true, HelpMessage = "New height for the resized image.")]
        public int NewHeight { get; set; }

        protected override void ProcessRecord()
        {
            if (SourceImageFilePath != null && SourceImageFilePath.FullName != null && SourceImageFilePath.Exists)
            {
                if (OutputImageFilePath != null && OutputImageFilePath.FullName != null)
                {
                    bool result = ImageProcessor.ResizeImageFromFile(SourceImageFilePath.FullName, NewWidth, NewHeight, OutputImageFilePath.FullName);
                    if (result)
                    {
                        WriteObject(result);
                    }
                    else
                    {
                        WriteError(new ErrorRecord(new IOException($"Failed to resize image from file: {SourceImageFilePath}"), "FileProcessingFailed", ErrorCategory.WriteError, SourceImageFilePath));
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