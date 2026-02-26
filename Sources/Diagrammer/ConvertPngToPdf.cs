using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;
using iText.IO.Image;

namespace Diagrammer
{
    public class ConvertImageToPDF
    {
        public static bool ConvertPngToPdf(string pngFilePath, string pdfFilePath)
        {
            try
            {
                // Create a new PDF document
                using var pdfWriter = new PdfWriter(pdfFilePath);
                using var pdfDocument = new PdfDocument(pdfWriter);

                // Get image dimensions to set page size
                var tempImageData = ImageDataFactory.Create(pngFilePath);
                var pageSize = new iText.Kernel.Geom.PageSize(tempImageData.GetWidth(), tempImageData.GetHeight());
                pdfDocument.SetDefaultPageSize(pageSize);

                // Create Document with page properties
                var document = new Document(pdfDocument);

                // Load the PNG image
                ImageData imageData = ImageDataFactory.Create(pngFilePath);
                Image image = new(imageData);

                // Adjust image size
                image.SetAutoScaleWidth(true); // Scale image to fit page width
                image.SetAutoScaleHeight(true);
                // Add the image to the document
                document.Add(image);

                // Close the document
                document.Close();
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error generating pdf from image: {ex.Message}");
                return false; // Or throw a more specific exception
            }
        }
        public static string GenerateToken(Byte length)
        {
            var bytes = new byte[length];
            var rnd = new Random();
            rnd.NextBytes(bytes);
            return Convert.ToBase64String(bytes).Replace("=", "").Replace("+", "").Replace("/", "");
        }
    }
}