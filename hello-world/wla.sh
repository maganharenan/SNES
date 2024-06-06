# ==========================================================================
#                             * ROM COMPILER *                             #
# ==========================================================================
# This script is a simple build automation tool for compiling and linking 
# 65816 assembly code using the WLA-DX toolchain. It takes the name of an 
# assembly file as input, compiles it into an object file, links the object 
# file into a SMC file, and then cleans up the temporary files it created
# ==========================================================================
#                                 * USAGE *                                #
# ==========================================================================
# To use this script, you would call it from the command line, passing the 
# name of your assembly file (without the .asm extension) as an argument. 
# For example, if your assembly file is named program.asm, you would 
# run the script like this: `./wla.sh program`
# If the permission denied error happened, just use: `chmod +x wla.sh`
# ==========================================================================

echo '[objects]' > temp
echo $1.obj >> temp

wla-65816 -o $1.obj $1.asm
wlalink -r temp $1.smc

rm $1.obj
rm temp