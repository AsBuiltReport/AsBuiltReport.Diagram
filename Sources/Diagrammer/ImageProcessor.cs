using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;
using SixLabors.ImageSharp.Processing;
using SixLabors.ImageSharp.Drawing.Processing;
using SixLabors.Fonts;
using System;

namespace Diagrammer
{
    public class ImageProcessor
    {
        public static int GetImageWidthFromFile(string imagePath)
        {
            try
            {
                using var image = Image.Load(imagePath);
                return image.Width;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading image from file: {ex.Message}");
                return -1; // Or throw a more specific exception
            }
        }
        public static int GetImageHeightFromFile(string imagePath)
        {
            try
            {
                using var image = Image.Load(imagePath);
                return image.Height;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading image from file: {ex.Message}");
                return -1; // Or throw a more specific exception
            }
        }

        public static SixLabors.ImageSharp.Image? GetImagePropertiesFromFile(string imagePath)
        {
            try
            {
                using var image = Image.Load(imagePath);
                return image;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading image: {ex.Message}");
                return null; // Or throw a more specific exception
            }
        }
        public static int GetImageWidthFromBase64(string base64String)
        {
            try
            {
                using var image = Image.Load(Convert.FromBase64String(base64String));
                return image.Width;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading image from Base64: {ex.Message}");
                return -1; // Or throw a more specific exception
            }
        }
        public static int GetImageHeightFromBase64(string base64String)
        {
            try
            {
                using var image = Image.Load(Convert.FromBase64String(base64String));
                return image.Height;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading image from Base64: {ex.Message}");
                return -1; // Or throw a more specific exception
            }
        }

        public static bool RotateImageFromFile(string imagePath, string outputPath, int angle)
        {
            try
            {
                using var image = Image.Load(imagePath);
                image.Mutate(x => x.Rotate(angle));
                image.Save(outputPath);
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading image from file: {ex.Message}");
                return false; // Or throw a more specific exception
            }
        }

        public static bool ResizeImageFromFile(string imagePath, int newWidth, int newHeight, string outputPath)
        {
            try
            {
                using var image = Image.Load(imagePath);
                image.Mutate(x => x.Resize(newWidth, newHeight));
                image.Save(outputPath);
                image.Dispose();
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading image from file: {ex.Message}");
                return false; // Or throw a more specific exception
            }
        }

        public static bool AddWatermarkToImage(string imagePath, string watermarkText, string outputPath, int fontSize, System.Drawing.Color fontColor, string fontName = "Arial", float opacity = 0.7f, string fontPath = "")
        {
            try
            {
                using var image = Image.Load(imagePath);
                FontCollection collection = new();
                FontFamily family = collection.Add(fontPath);

                if (fontSize == 0)
                {
                    fontSize = ((image.Width + image.Height) / 2) / watermarkText.Length;
                }

                Font font = family.CreateFont(fontSize, FontStyle.Regular);

                // Set default font color to red if not provided
                if (fontColor == System.Drawing.Color.Empty)
                {
                    fontColor = System.Drawing.Color.Red;
                }



                // Parse font color
                var color = Color.FromRgba(fontColor.R, fontColor.G, fontColor.B, fontColor.A);
                var rgba = color.ToPixel<Rgba32>();
                var colorWithOpacity = Color.FromRgba(rgba.R, rgba.G, rgba.B, (byte)(255 * opacity));


                // Calculate center position
                var textOptions = new TextOptions(font);
                var textSize = TextMeasurer.MeasureSize(watermarkText, textOptions);
                float x = (image.Width - textSize.Width) / 2;
                float y = (image.Height - textSize.Height) / 2;

                image.Mutate(ctx => ctx.DrawText(new DrawingOptions() { Transform = Matrix3x2Extensions.CreateRotationDegrees(-45, new PointF(x + textSize.Width / 2, y + textSize.Height / 2)) }, watermarkText, font, colorWithOpacity, new SixLabors.ImageSharp.PointF(x, y)));

                image.Save(outputPath);
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error adding watermark to image: {ex.Message}");
                return false;
            }
        }
    }
}