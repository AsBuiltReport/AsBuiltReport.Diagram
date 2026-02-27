using System;
using System.IO;
using System.Management.Automation;

namespace Diagrammer.PowerShell
{
    [Cmdlet(VerbsCommon.Get, "RotateImageFromFile")]
    public class GetRotateImageFromFileCommand : PSCmdlet
    {
        [Parameter(Mandatory = true, HelpMessage = "Path to the source image file.")]
        public FileInfo? SourceImageFilePath { get; set; }

        [Parameter(Mandatory = true, HelpMessage = "Path to save the rotated image file.")]
        public FileInfo? OutputImageFilePath { get; set; }

        [Parameter(Mandatory = true, HelpMessage = "Angle to rotate the image (in degrees).")]
        public int Angle { get; set; }

        protected override void ProcessRecord()
        {
            if (SourceImageFilePath != null && SourceImageFilePath.FullName != null && SourceImageFilePath.Exists)
            {
                if (OutputImageFilePath != null && OutputImageFilePath.FullName != null)
                {
                    bool result = ImageProcessor.RotateImageFromFile(SourceImageFilePath.FullName, OutputImageFilePath.FullName, Angle);
                    if (result)
                    {
                        WriteObject(result);
                    }
                    else
                    {
                        WriteError(new ErrorRecord(new IOException($"Failed to rotate image from file: {SourceImageFilePath}"), "FileProcessingFailed", ErrorCategory.WriteError, SourceImageFilePath));
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