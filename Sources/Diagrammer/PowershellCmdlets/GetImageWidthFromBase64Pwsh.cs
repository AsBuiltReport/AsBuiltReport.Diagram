using System;
using System.IO;
using System.Management.Automation;
using iText.Layout.Element;

namespace Diagrammer.PowerShell
{
    [Cmdlet(VerbsCommon.Get, "ImageWidthFromBase64")]
    public class GetImageWidthFromBase64Command : PSCmdlet
    {
        [Parameter(Mandatory = true, HelpMessage = "Base64 string of the source image.")]
        public string? Base64 { get; set; }

        protected override void ProcessRecord()
        {
            if (!string.IsNullOrEmpty(Base64))
            {
                int imageWidth = ImageProcessor.GetImageWidthFromBase64(Base64);
                if (imageWidth != -1)
                {
                    WriteObject(imageWidth);
                }
                else
                {
                    WriteError(new ErrorRecord(new IOException("Failed to get image width from Base64 string."), "Base64ProcessingFailed", ErrorCategory.WriteError, Base64));
                }
            }
            else
            {
                WriteError(new ErrorRecord(new ArgumentException("The Base64 string cannot be null or empty."), "InvalidBase64", ErrorCategory.InvalidArgument, Base64));
            }
        }
    }
}