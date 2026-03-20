using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

namespace AsBuiltReportDiagram
{
    internal class ImageProcessor
    {
        internal static bool SetImageOpacity(string imagePath, int opacity, string outputPath)
        {
            try
            {
                float opacityValue = Math.Max(0f, Math.Min(1f, opacity / 100f));

                using (Bitmap srcImage = new Bitmap(imagePath))
                using (Bitmap destImage = new Bitmap(srcImage.Width, srcImage.Height, PixelFormat.Format32bppArgb))
                using (Graphics graphics = Graphics.FromImage(destImage))
                {
                    graphics.Clear(Color.Transparent);

                    ColorMatrix colorMatrix = new ColorMatrix();
                    colorMatrix.Matrix33 = opacityValue;

                    ImageAttributes imageAttributes = new ImageAttributes();
                    imageAttributes.SetColorMatrix(colorMatrix, ColorMatrixFlag.Default, ColorAdjustType.Bitmap);

                    graphics.DrawImage(
                        srcImage,
                        new Rectangle(0, 0, srcImage.Width, srcImage.Height),
                        0, 0, srcImage.Width, srcImage.Height,
                        GraphicsUnit.Pixel,
                        imageAttributes);

                    string ext = Path.GetExtension(outputPath).ToLowerInvariant();
                    ImageFormat format;
                    if (ext == ".jpg" || ext == ".jpeg")
                        format = ImageFormat.Jpeg;
                    else if (ext == ".bmp")
                        format = ImageFormat.Bmp;
                    else if (ext == ".gif")
                        format = ImageFormat.Gif;
                    else
                        format = ImageFormat.Png;

                    destImage.Save(outputPath, format);
                    return true;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error setting image opacity: {ex.Message}");
                return false;
            }
        }
    }
}
