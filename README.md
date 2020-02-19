# LeCroyParser
Wolfram Mathematica library to import and parse binary data from LeCroy oscilloscopes.
For installation, see instructions provided below.

The package provides the user with the function:
    ImportLecroyBinary["path"]
This function takes as argument the path of a binary trace saved in the LeCroy oscilloscope format and yields the list of {time, voltage} values. For a trace with 1001 points, the list will have dimensions of {1001, 2} (i.e., 1001 points where each element consists of the time and the trace value at that time).
The function also accepts an optional value:
    ImportLecroyBinary["path", option]
If option==True, the data will be loaded in verbose mode and the function will also print additional information on the trace (vertical/horizontal scale, sampling rate).

Standalone usage (no installation):
1. Download "LeCroyParser.m" to your computer.
2. In your Wolfram Mathematica notebook, use the following command to load the package:
    Import["<path>/LeCroyParser.m"]
3. You can now use the ImportLecroyBinary[] function to parse the binary data.

Package installation:
1. Download the "LeCroyParser.m" package.
2. From the Wolfram Mathematica menu, select "Install..."
3. From the drop-down menus select "Install Name -> LeCroyParser", "Type -> Package", and "Source -> From File...". 
4. Select the file downloaded. This will load the package into the Wolfram Mathematica library (FileNameJoin[{$UserBaseDirectory, "Applications"}])
5. In your Wolfram Mathematica notebook, use the following command to load the package:
    Needs["LeCroyParser`"]
6. You can now use the ImportLecroyBinary[] function to parse the binary data.
