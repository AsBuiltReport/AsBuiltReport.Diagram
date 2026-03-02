using System;
using System.IO;
using System.Management.Automation;
using iText.Layout.Element;

namespace Diagrammer.PowerShell
{
    [Cmdlet(VerbsCommon.Get, "ImageWidthFromFile")]
    public class GetImageWidthFromFileCommand : PSCmdlet
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
                        int imageWidth = ImageProcessor.GetImageWidthFromFile(SourceImageFilePath.FullName);
                        if (imageWidth > 0)
                        {
                            WriteObject(imageWidth);
                        }
                        else
                        {
                            WriteError(new ErrorRecord(new IOException($"Failed to get image width from file: {SourceImageFilePath}"), "FileProcessingFailed", ErrorCategory.WriteError, SourceImageFilePath));
                        }
                    }
                    else
                    {
                        WriteError(new ErrorRecord(new IOException($"Failed to get image width from file: {SourceImageFilePath}"), "FileProcessingFailed", ErrorCategory.WriteError, SourceImageFilePath));
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