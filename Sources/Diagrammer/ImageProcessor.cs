using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;
using SixLabors.ImageSharp.Processing;
using SixLabors.ImageSharp.Drawing.Processing;
using SixLabors.Fonts;
using System;
using System.Globalization;
using System.Xml.Linq;

namespace Diagrammer
{
    internal class ImageProcessor
    {
        internal static int GetImageWidthFromFile(string imagePath)
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
        internal static int GetImageHeightFromFile(string imagePath)
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

        internal static SixLabors.ImageSharp.Image? GetImagePropertiesFromFile(string imagePath)
        {
            try
            {
                return Image.Load(imagePath);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading image: {ex.Message}");
                return null; // Or throw a more specific exception
            }
        }
        internal static int GetImageWidthFromBase64(string base64String)
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
        internal static int GetImageHeightFromBase64(string base64String)
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

        internal static bool RotateImageFromFile(string imagePath, string outputPath, int angle)
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

        internal static bool ResizeImageFromFile(string imagePath, int newWidth, int newHeight, string outputPath)
        {
            try
            {
                using var image = Image.Load(imagePath);
                image.Mutate(x => x.Resize(newWidth, newHeight));
                image.Save(outputPath);
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error loading image from file: {ex.Message}");
                return false; // Or throw a more specific exception
            }
        }

        internal static bool AddWatermarkToImage(string imagePath, string watermarkText, string outputPath, int fontSize, System.Drawing.Color fontColor, string fontName = "Arial", float opacity = 0.7f, string fontPath = "")
        {
            try
            {
                using var image = Image.Load(imagePath);
                FontFamily family;
                if (!string.IsNullOrEmpty(fontPath) && File.Exists(fontPath))
                {
                    FontCollection collection = new();
                    family = collection.Add(fontPath);
                }
                else if (!SystemFonts.TryGet(fontName, out family))
                {
                    if (!SystemFonts.Families.Any())
                    {
                        throw new InvalidOperationException($"Font '{fontName}' not found and no system fonts are available. Please provide a valid font path via the WatermarkTextFontPath parameter.");
                    }
                    family = SystemFonts.Families.First();
                }

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
                float normalizedOpacity = NormalizeOpacity(opacity);
                byte alpha = (byte)Math.Round(255f * normalizedOpacity, MidpointRounding.AwayFromZero);
                var colorWithOpacity = Color.FromRgba(rgba.R, rgba.G, rgba.B, alpha);


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

        internal static bool AddWatermarkToSvg(string svgPath, string watermarkText, string outputPath, int fontSize, System.Drawing.Color fontColor, string fontName = "Arial", float opacity = 0.3f, int angle = -45)
        {
            try
            {
                XDocument document = XDocument.Load(svgPath);
                XElement? root = document.Root;
                if (root == null)
                {
                    throw new InvalidOperationException("Invalid SVG: root element not found.");
                }

                XNamespace ns = root.Name.Namespace;
                (float width, float height) = GetSvgSize(root);

                if (fontSize <= 0)
                {
                    int textLength = Math.Max(1, watermarkText.Length);
                    fontSize = (int)(((width + height) / 2f) / textLength);
                    fontSize = Math.Max(12, fontSize);
                }

                if (fontColor == System.Drawing.Color.Empty)
                {
                    fontColor = System.Drawing.Color.Red;
                }

                float normalizedOpacity = NormalizeOpacity(opacity);
                float centerX = width / 2f;
                float centerY = height / 2f;
                string fillColor = $"rgb({fontColor.R},{fontColor.G},{fontColor.B})";

                XElement watermarkGroup = new(
                    ns + "g",
                    new XAttribute("transform", $"translate({centerX.ToString(CultureInfo.InvariantCulture)} {centerY.ToString(CultureInfo.InvariantCulture)}) rotate({angle})"),
                    new XAttribute("pointer-events", "none"),
                    new XElement(
                        ns + "text",
                        new XAttribute("x", "0"),
                        new XAttribute("y", "0"),
                        new XAttribute("text-anchor", "middle"),
                        new XAttribute("dominant-baseline", "middle"),
                        new XAttribute("font-family", fontName),
                        new XAttribute("font-size", fontSize.ToString(CultureInfo.InvariantCulture)),
                        new XAttribute("font-style", "italic"),
                        new XAttribute("fill", fillColor),
                        new XAttribute("fill-opacity", normalizedOpacity.ToString("0.###", CultureInfo.InvariantCulture)),
                        watermarkText
                    )
                );

                root.Add(watermarkGroup);
                document.Save(outputPath);
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error adding watermark to SVG: {ex.Message}");
                return false;
            }
        }

        private static (float Width, float Height) GetSvgSize(XElement root)
        {
            XAttribute? viewBoxAttribute = root.Attribute("viewBox");
            if (viewBoxAttribute != null)
            {
                string[] parts = viewBoxAttribute.Value
                    .Split(new[] { ' ', ',' }, StringSplitOptions.RemoveEmptyEntries);

                if (parts.Length == 4
                    && float.TryParse(parts[2], NumberStyles.Float, CultureInfo.InvariantCulture, out float vbWidth)
                    && float.TryParse(parts[3], NumberStyles.Float, CultureInfo.InvariantCulture, out float vbHeight)
                    && vbWidth > 0
                    && vbHeight > 0)
                {
                    return (vbWidth, vbHeight);
                }
            }

            float width = ParseSvgDimension(root.Attribute("width")?.Value);
            float height = ParseSvgDimension(root.Attribute("height")?.Value);

            if (width <= 0 || height <= 0)
            {
                return (1000f, 1000f);
            }

            return (width, height);
        }

        private static float ParseSvgDimension(string? dimension)
        {
            if (string.IsNullOrWhiteSpace(dimension))
            {
                return 0f;
            }

            string numeric = new string(dimension
                .TakeWhile(ch => char.IsDigit(ch) || ch == '.' || ch == '-')
                .ToArray());

            if (float.TryParse(numeric, NumberStyles.Float, CultureInfo.InvariantCulture, out float value))
            {
                return value;
            }

            return 0f;
        }

        private static float NormalizeOpacity(float opacity)
        {
            // Accept opacity inputs in either 0..1 or 0..100 range.
            float normalized = opacity > 1f ? opacity / 100f : opacity;
            return Math.Clamp(normalized, 0f, 1f);
        }
    }
}