# LeCroyParser
Wolfram Mathematica library to import and parse binary data from LeCroy oscilloscopes.

Standalone usage (no installation):
1. Download "LeCroyParser.m" to your computer.
2. In your Wolfram Mathematica notebook, use the following command to load the package:
    Import["$PATH/LeCroyParser.m"]
3. You can now use the ImportLecroyBinary[] function to parse the binary data.

Package installation:
1. Download the "LeCroyParser.m" package.
2. From the Wolfram Mathematica menu, select "Install..."
3. From the drop-down menus select "Install Name -> LeCroyParser", "Type -> Package", and "Source -> From File...". 
4. Select the file downloaded. This will load the package into the Wolfram Mathematica library (FileNameJoin[{$UserBaseDirectory, "Applications"}])
5. In your Wolfram Mathematica notebook, use the following command to load the package:
    Needs["LeCroyParser`"]
6. You can now use the ImportLecroyBinary[] function to parse the binary data.
