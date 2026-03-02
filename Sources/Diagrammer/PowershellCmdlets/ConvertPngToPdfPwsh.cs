using System;
using System.IO;
using System.Management.Automation;

namespace Diagrammer.PowerShell
{
    [Cmdlet(VerbsCommon.New, "ConvertPngToPdf")]
    public class ConvertPngToPdfCommand : PSCmdlet
    {
        // Declare the parameters for the cmdlet.
        [Parameter(Mandatory = false, HelpMessage = "Output filename for the pdf. If not specified, a random token will be generated.")]
        public string OutputFilename { get; set; } = ConvertImageToPDF.GenerateToken(8);

        [Parameter(Mandatory = true, HelpMessage = "Path to the source PNG file.")]
        public FileInfo? SourcePngFile { get; set; }

        // Set OutputFolderPath
        [Parameter(Mandatory = false, HelpMessage = "Output folder path where the pdf will be saved.")]
        public string OutputFolderPath { get; set; } = Directory.GetCurrentDirectory();

        [Parameter(Mandatory = false, HelpMessage = "Full Path Output filename for the pdf.")]
        public string? OutputFileNamePath { get; set; }

        protected override void ProcessRecord()
        {
            if (SourcePngFile != null && SourcePngFile.FullName != null && SourcePngFile.Exists)
            {
                if (OutputFileNamePath != null)
                {
                    ConvertImageToPDF.ConvertPngToPdf(SourcePngFile.FullName, OutputFileNamePath);
                    FileInfo outputPath = new FileInfo(OutputFileNamePath);
                    if (outputPath.Exists)
                    {
                        WriteObject(outputPath);
                    }
                    else
                    {
                        WriteError(new ErrorRecord(new IOException($"Failed to create PDF file: {OutputFileNamePath}"), "FileCreationFailed", ErrorCategory.WriteError, OutputFileNamePath));
                    }
                }
                else
                {
                    FileInfo outputPath = new FileInfo(Path.Combine(OutputFolderPath, $"{OutputFilename}.pdf"));
                    ConvertImageToPDF.ConvertPngToPdf(SourcePngFile.FullName, outputPath.FullName);
                    if (outputPath.Exists)
                    {
                        WriteObject(outputPath);
                    }
                    else
                    {
                        WriteError(new ErrorRecord(new IOException($"Failed to create PDF file: {outputPath}"), "FileCreationFailed", ErrorCategory.WriteError, outputPath));
                    }
                }
            }
            else
            {
                WriteError(new ErrorRecord(new FileNotFoundException($"The specified PNG file '{SourcePngFile}' does not exist."), "FileNotFound", ErrorCategory.InvalidArgument, SourcePngFile));
            }
        }
    }
}