# ==========================================================================
#                             * ROM COMPILER *                             #
# ==========================================================================
# This script is a simple build automation tool for compiling and linking
# 65816 assembly code using the ca65 toolchain. It takes the name of an
# assembly file as input, compiles it into an object file, links the object
# file into a binary file, and then cleans up the temporary files it created.
# ==========================================================================
#                                 * USAGE *                                #
# ==========================================================================
# To use this script, you would call it from the command line, passing the
# name of your assembly file (without the .asm extension) as an argument.
# For example, if your assembly file is named program.asm, you would
# run the script like this: `./ca65.sh program`
# If the permission denied error happens, just use: `chmod +x ca65.sh`
# ==========================================================================


ca65 --cpu 65816 -s -o $1.o $1.s
ld65 -C memmap.cfg $1.o -o $1.smc

rm $1.o