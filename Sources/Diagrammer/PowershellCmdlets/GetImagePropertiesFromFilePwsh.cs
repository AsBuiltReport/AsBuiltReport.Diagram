using System;
using System.IO;
using System.Management.Automation;

namespace AsBuiltReportDiagram.PowerShell
{
    [Cmdlet(VerbsCommon.Get, "ImagePropertiesFromFile")]
    public class GetImagePropertiesFromFileCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, HelpMessage = "Path to the source image file.")]
        public FileInfo? SourceImageFilePath { get; set; }

        protected override void ProcessRecord()
        {
            if (SourceImageFilePath != null && SourceImageFilePath.FullName != null && SourceImageFilePath.Exists)
            {
                if (SourceImageFilePath.Exists)
                {
                    SixLabors.ImageSharp.Image? imageProperties = ImageProcessor.GetImagePropertiesFromFile(SourceImageFilePath.FullName);
                    if (imageProperties != null)
                    {
                        WriteObject(imageProperties);
                    }
                    else
                    {
                        WriteError(new ErrorRecord(new IOException($"Failed to get image properties from file: {SourceImageFilePath}"), "FileProcessingFailed", ErrorCategory.WriteError, SourceImageFilePath));
                    }
                }
            }
            else
            {
                WriteError(new ErrorRecord(new FileNotFoundException($"The specified image file '{SourceImageFilePath}' does not exist."), "FileNotFound", ErrorCategory.InvalidArgument, SourceImageFilePath));
            }
        }
    }
}