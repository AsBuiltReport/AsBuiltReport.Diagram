using System;
using System.IO;
using System.Management.Automation;

namespace Diagrammer.PowerShell
{
    [Cmdlet(VerbsCommon.Get, "ImageHeightFromFile")]
    public class GetImageHeightFromFileCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, HelpMessage = "Path to the source image file.")]
        public FileInfo? SourceImageFilePath { get; set; }

        protected override void ProcessRecord()
        {
            if (SourceImageFilePath != null && SourceImageFilePath.FullName != null && SourceImageFilePath.Exists)
            {
                if (SourceImageFilePath != null)
                {
                    if (SourceImageFilePath.Exists)
                    {
                        int imageHeight = ImageProcessor.GetImageHeightFromFile(SourceImageFilePath.FullName);
                        if (imageHeight != 0)
                        {
                            WriteObject(imageHeight);
                        }
                        else
                        {
                            WriteError(new ErrorRecord(new IOException($"Failed to get image height from file: {SourceImageFilePath}"), "FileProcessingFailed", ErrorCategory.WriteError, SourceImageFilePath));
                        }
                    }
                    else
                    {
                        WriteError(new ErrorRecord(new IOException($"Failed to get image height from file: {SourceImageFilePath}"), "FileProcessingFailed", ErrorCategory.WriteError, SourceImageFilePath));
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