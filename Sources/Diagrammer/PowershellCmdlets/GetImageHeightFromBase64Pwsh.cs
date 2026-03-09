using System;
using System.IO;
using System.Management.Automation;
using iText.Layout.Element;

namespace AsBuiltReportDiagram.PowerShell
{
    [Cmdlet(VerbsCommon.Get, "ImageHeightFromBase64")]
    public class GetImageHeightFromBase64Command : PSCmdlet
    {
        [Parameter(Mandatory = true, HelpMessage = "Base64 string of the source image.")]
        public string? Base64 { get; set; }

        protected override void ProcessRecord()
        {
            if (!string.IsNullOrEmpty(Base64))
            {
                int imageHeight = ImageProcessor.GetImageHeightFromBase64(Base64);
                if (imageHeight != -1)
                {
                    WriteObject(imageHeight);
                }
                else
                {
                    WriteError(new ErrorRecord(new IOException("Failed to get image height from Base64 string."), "Base64ProcessingFailed", ErrorCategory.WriteError, Base64));
                }
            }
            else
            {
                WriteError(new ErrorRecord(new ArgumentException("The Base64 string cannot be null or empty."), "InvalidBase64", ErrorCategory.InvalidArgument, Base64));
            }
        }
    }
}