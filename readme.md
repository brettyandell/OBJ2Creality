# OBJ2Creality

**Convert textured 3D models to vertex-colored OBJ files for Creality multi-color 3D printing.**

Developed by **Brett Yandell** for the Monolith.

---

## 🎨 What is OBJ2Creality?

OBJ2Creality is a command-line tool that converts textured OBJ and GLB/glTF 3D models into vertex-colored OBJ files compatible with **Creality Print/Slicer** for multi-color 3D printing.

The tool automatically maps texture colors to the closest available **Creality filament colors** and generates a shopping list with Amazon links for easy purchasing.

### Key Features

- ✅ **GLB/glTF Support** - Load GLB files with embedded textures
- ✅ **OBJ Support** - Load OBJ files with external textures and MTL files
- ✅ **Material Filtering** - Choose PLA, PETG, ABS, TPU, or all materials
- ✅ **Color Quantization** - Limit output to a specific number of colors
- ✅ **138+ Creality Colors** - Comprehensive palette from [3dfilamentprofiles.com](https://3dfilamentprofiles.com/filaments/creality)
- ✅ **CIELAB Color Matching** - Perceptually accurate color distance calculations
- ✅ **Shopping List Generator** - Creates filament list with Amazon links
- ✅ **Batch Script** - Easy-to-use Windows batch file with interactive menus

---

## 📦 Installation

### Download Pre-built Binary

Download the latest release from the [Releases](../../releases) page.

## 🚀 Usage

### Command Line

obj2creality <model> [texture] [options]
Options
Option	Description
-o <name>	Output file base name
-m <material>	Material type: PLA, PETG, ABS, TPU, ALL (default: ALL)
-c <count>	Maximum colors to use (quantization), 0 = unlimited
-list	Show all available filament colors
Examples

# Basic GLB conversion (auto-detects embedded texture)
obj2creality model.glb

# OBJ with external texture
obj2creality model.obj texture.png

# PLA filaments only, limit to 8 colors
obj2creality model.glb -m PLA -c 8

# PETG filaments only
obj2creality model.glb -m PETG

# Custom output name, 4 color limit
obj2creality character.glb -m PLA -c 4 -o myprint

# List all available PLA colors
obj2creality -list -m PLA

# List all available PETG colors
obj2creality -list -m PETG
Output Files
For input model.glb:

model_vertexcolor.obj - OBJ with vertex colors for Creality Slicer
model_filaments.txt - Shopping list with filament details and Amazon links

## 🖥️ Batch Script (Windows)

### For easier use on Windows, use the included glbOBJ2Creality.bat script:

Place glbOBJ2Creality.bat in the same folder as obj2creality.exe
Double-click the batch file
Follow the interactive prompts:
Enter folder path (e.g., C:\Models\Batman)
Enter base file name (e.g., batman)
Select material type (PLA, PETG, ABS, TPU, ALL)
Enter max colors (or press Enter for unlimited)
The tool will find all related files automatically:
batman.glb or batman.obj
batman.jpg, batman.png, etc.
batman.mtl

## 📁 Supported Formats

### 3D Model Formats
Format	Extension	Notes
GLB	.glb	Binary glTF, supports embedded textures
glTF	.gltf	JSON glTF
OBJ	.obj	Wavefront OBJ, uses MTL for materials
Texture Formats
Format	Extension
JPEG	.jpg, .jpeg
PNG	.png
BMP	.bmp
TGA	.tga

## 🎨 Supported Filaments

### OBJ2Creality includes 138+ Creality filament colors sourced from ​3dfilamentprofiles.com​:

PLA Filaments (~100 colors)
CR-PLA - Standard PLA colors
Hyper PLA - High-speed PLA (600mm/s)
Ender PLA - Budget-friendly PLA
CR-PLA Matte - Non-reflective finish
CR-Silk - Metallic/shiny finish
CR-Wood - Wood composite (30%+ real wood)
Hyper PLA CF - Carbon fiber reinforced
PLA Plus Pro - Enhanced PLA
PETG Filaments (~12 colors)
CR-PETG - Standard PETG
Hyper PETG - High-speed PETG
ABS Filaments (~5 colors)
CR-ABS - Standard ABS
TPU Filaments (~6 colors)
CR-TPU - Flexible TPU

## 🔧 How It Works

Load Model - Parses OBJ or GLB/glTF files, extracting vertices, UV coordinates, and triangles
Load Texture - Loads embedded (GLB) or external texture files
Filter Palette - Filters the Creality palette based on selected material type
Sample Colors - Samples texture color at each vertex UV coordinate
Match Colors - Finds closest Creality filament using CIELAB color distance
Quantize (optional) - Reduces color count by keeping most-used colors and remapping others
Export OBJ - Saves vertex-colored OBJ file with RGB values appended to vertex lines
Generate List - Creates shopping list with filament names, RGB values, temperatures, and Amazon links
Color Matching Algorithm
The tool uses CIELAB (L*a*b*) color space for perceptually accurate color matching:

Convert RGB to linear RGB (sRGB gamma correction)
Convert linear RGB to XYZ color space
Convert XYZ to CIELAB
Calculate Euclidean distance in CIELAB space
This produces much better results than simple RGB distance calculations.

## 📋 Filament Shopping List

### An example of the _filaments.txt file includes:


=============================================================
         FILAMENT SHOPPING LIST FOR CREALITY SLICER
         Developed by Brett Yandell for the Monolith
=============================================================

Material Type: PLA
Total Colors:  8 filament(s)
Max Colors:    8 (quantized)

-------------------------------------------------------------
                    FILAMENTS NEEDED
-------------------------------------------------------------

SLOT 1: Hyper PLA White
  Color:       #FFFFFF
  RGB:         255, 255, 255
  Type:        Hyper PLA
  Nozzle Temp: 200C
  Bed Temp:    50C
  Usage:       12543 vertices (34.2%)
  Amazon:      https://www.amazon.com/s?k=Creality+Hyper+PLA+White

SLOT 2: Hyper PLA Black
  Color:       #231F20
  RGB:         35, 31, 32
  ...

-------------------------------------------------------------
                   QUICK AMAZON LINKS
-------------------------------------------------------------

* Hyper PLA White:
  https://www.amazon.com/s?k=Creality+Hyper+PLA+White

* Hyper PLA Black:
  https://www.amazon.com/s?k=Creality+Hyper+PLA+Black
  ...

## 🖨️ Importing into Creality Print/Slicer

Open Creality Print or Creality Slicer
Go to File > Import and select the *_vertexcolor.obj file
The model should appear with vertex colors visible
Add filament slots matching the colors in your *_filaments.txt file
Assign filaments to the model based on vertex colors
Slice and print!

## 📊 Command Reference

Usage: obj2creality <model> [texture] [options]

Options:
  -o <name>       Output file base name
  -m <material>   Material type: PLA, PETG, ABS, TPU, ALL (default: ALL)
  -c <count>      Max colors to use (quantization), 0 = unlimited
  -list           Show all available filament colors

Supported formats: OBJ, GLB, glTF
Supported textures: JPG, PNG, BMP, TGA

Examples:
  obj2creality model.glb -m PLA -c 8
  obj2creality model.obj texture.png -m PETG
  obj2creality model.glb -m PLA -c 4 -o myprint

## 🙏 Acknowledgments
​stb_image​ - Image loading library
​tinygltf​ - GLB/glTF loading library
​nlohmann/json​ - JSON parsing library
​3dfilamentprofiles.com​ - Filament color database

