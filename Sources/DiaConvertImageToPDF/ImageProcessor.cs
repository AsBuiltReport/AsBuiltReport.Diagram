using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Globalization;
using System.IO;
using System.Xml.Linq;

namespace AsBuiltReportDiagram
{
    internal class ImageProcessor
    {
        internal static bool AddWatermarkToSvg(string svgPath, string watermarkText, string outputPath, int fontSize, System.Drawing.Color fontColor, string fontName = "Arial", float opacity = 0.3f, int angle = -45)
        {
            try
            {
                XDocument document = XDocument.Load(svgPath);
                XElement root = document.Root;
                if (root == null)
                {
                    throw new InvalidOperationException("Invalid SVG: root element not found.");
                }

                XNamespace ns = root.Name.Namespace;
                float[] size = GetSvgSize(root);
                float width = size[0];
                float height = size[1];

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
                string fillColor = string.Format("rgb({0},{1},{2})", fontColor.R, fontColor.G, fontColor.B);

                XElement watermarkGroup = new XElement(
                    ns + "g",
                    new XAttribute("transform", string.Format(CultureInfo.InvariantCulture, "translate({0} {1}) rotate({2})", centerX, centerY, angle)),
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
                Console.WriteLine(string.Format("Error adding watermark to SVG: {0}", ex.Message));
                return false;
            }
        }

        private static float[] GetSvgSize(XElement root)
        {
            XAttribute viewBoxAttribute = root.Attribute("viewBox");
            if (viewBoxAttribute != null)
            {
                string[] parts = viewBoxAttribute.Value
                    .Split(new char[] { ' ', ',' }, StringSplitOptions.RemoveEmptyEntries);

                if (parts.Length == 4
                    && float.TryParse(parts[2], NumberStyles.Float, CultureInfo.InvariantCulture, out float vbWidth)
                    && float.TryParse(parts[3], NumberStyles.Float, CultureInfo.InvariantCulture, out float vbHeight)
                    && vbWidth > 0
                    && vbHeight > 0)
                {
                    return new float[] { vbWidth, vbHeight };
                }
            }

            float width = ParseSvgDimension(root.Attribute("width") != null ? root.Attribute("width").Value : null);
            float height = ParseSvgDimension(root.Attribute("height") != null ? root.Attribute("height").Value : null);

            if (width <= 0 || height <= 0)
            {
                return new float[] { 1000f, 1000f };
            }

            return new float[] { width, height };
        }

        private static float ParseSvgDimension(string dimension)
        {
            if (string.IsNullOrWhiteSpace(dimension))
            {
                return 0f;
            }

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            foreach (char ch in dimension)
            {
                if (char.IsDigit(ch) || ch == '.' || ch == '-')
                    sb.Append(ch);
                else
                    break;
            }

            if (float.TryParse(sb.ToString(), NumberStyles.Float, CultureInfo.InvariantCulture, out float value))
            {
                return value;
            }

            return 0f;
        }

        private static float NormalizeOpacity(float opacity)
        {
            float normalized = opacity > 1f ? opacity / 100f : opacity;
            return Math.Max(0f, Math.Min(1f, normalized));
        }


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
