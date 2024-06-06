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
I am currently using the assembler [WLA-DX]('https://github.com/vhelin/wla-dx'). I work on a macbook so I install it using Homebrew

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

#### Contents

* [Setting Up Background Color]('https://github.com/maganharenan/SNES/tree/main/background-color')
* [Hello World Example]('https://github.com/maganharenan/SNES/tree/main/hello-world')
* (Add more topics as you create and upload new content)

#### Contributing
If you'd like to contribute to this repository by adding new projects, improving existing ones, or fixing issues, feel free to submit a pull request. Your contributions are greatly appreciated!

[Platform]: https://img.shields.io/badge/platform%20-%20snes%20-%20lightblue