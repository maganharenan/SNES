# Assembly SNES Study Hub

![Platform][Platform] 

Welcome to my SNES Assembly Study hub! Here, you'll find various examples for programming for Super Nintendo Entertainment System (SNES) using assembly language.

<img src = https://proxy.olhardigital.com.br/wp-content/uploads/2023/10/imagem_2023-10-24_124051098.png>

#### About
This repository serves as a learning hub for SNES assembly development. If you're a beginner like me, you maybe can find valuable resources to help you understand and improve SNES programming here.

#### Getting Started
1. Clone this repo to your local machine;
2. Navigate to the desired study topic;

#### Generating the ROM file
To generate the rom file you will need to install an assembler.
I am currently using the assembler [WLA-DX](https://github.com/vhelin/wla-dx). I work on a macbook so I install it using Homebrew

``` bash
brew install wla-dx
```

In each project folder I have included a shell script called `wla.sh`. This script is responsible for generating the ROM. Here is the script content:

``` shell
echo '[objects]' > temp
echo $1.obj >> temp

wla-65816 -o $1.obj $1.asm
wlalink -r temp $1.smc

rm $1.obj
rm temp
```

In the original example the `wlalink` line was like this: `wlalink -vr temp $1.smc` but everytime I tried that I got and error, so I replaced the `-vr` with `-r`

Well, to generate the rom, you only need to navigate to the desired project folder and run the command:

``` bash
./wla.sh main
```

Remember that **main**  is just the name of the project, it stands for `main.asm`. If you named your project different than that, so make sure of replacing when running the shell script.

Another important thing is that you will probably face an permisson error when trying to run the script. To quickly solve that you can just run this command before executing the script:

``` bash
chmod +x wla.sh
```

#### Running the ROMs
I personaly recommend using the [bsnes](https://bsnes.org) to run the rom files.
I don't linke to use [OpenEmu](https://openemu.org) because I always have some problem related to the keyboard.

#### Contents

* [Setting Up Background Color](https://github.com/maganharenan/SNES/tree/main/001-background-color)
* [Hello World Example](https://github.com/maganharenan/SNES/tree/main/002-hello-world)
* [Bitmap Example](https://github.com/maganharenan/SNES/tree/main/003-bitmap)
* [Moving Bitmap Example](https://github.com/maganharenan/SNES/tree/main/004-moving-bitmap)
* [Compiling with cc65](https://github.com/maganharenan/SNES/tree/main/005-compiling-with-cc65)
* (Add more topics as you create and upload new content)

#### Contributing
If you'd like to contribute to this repository by adding new projects, improving existing ones, or fixing issues, feel free to submit a pull request. Your contributions are greatly appreciated!

#### Recommended Resources

##### Websites
* [SFC Development Wiki](https://wiki.superfamicom.org) - A wonderful wiki with a lot of resources about programming for SNES. By the way, the very first program that I wrote using assembly I followed the Bazz's tutorials.
* [Super NES Programming](https://en.wikibooks.org/wiki/Super_NES_Programming) - Another cool site to learn how to program for SNES. There are some tutorials, another cool resources and some techniques there.
* [SNES Assembly Adventure](https://georgjz.github.io/snesaa01/) - This one id new for me, but I really liked it. You should check it out.

##### Youtube Channels
* [ChibiAkumas](https://www.youtube.com/@ChibiAkumas) - Great channel! I followed his tutorials to make the complex examples like the hello-world and the bitmap related stuff.
* [Manual do Código](https://www.youtube.com/watch?v=WoOVbPnpyjk&list=PLLFRf_pkM7b6Vi0ehPPovl1gQ5ubHTy5P) - If you speak portuguese you need to know this channel. Great content, very well explained.

##### Books
* [Learn Multiplatform Assembly Programming with ChibiAkumas](https://www.amazon.com/Learn-Multiplatform-Assembly-Programming-ChibiAkumas/dp/B0D2TV15LP/ref=sr_1_2?crid=23K2IU2TO7BLZ&dib=eyJ2IjoiMSJ9.zKXJ5odQirG7uRlQkwgZ1oflC7_iPdwY_uyAssG_x8kdyte-qEmS69vGU1wQRr0E.npqlDURFeXTXYwi_9cTywRJ-GrKr_eXIYV1_wyw6nfw&dib_tag=se&keywords=chibiakumas&qid=1717768793&sprefix=chibiakum%2Caps%2C261&sr=8-2) - Great book. I bought the volume 2, but he already release the volume 3.

##### Libs, SDKs, etc
* [PVSnesLib](https://github.com/alekmaul/pvsneslib) - Great lib! I used it a lot in some other stuff that I wrote in C.


[Platform]: https://img.shields.io/badge/platform%20-%20snes%20-%20lightblue