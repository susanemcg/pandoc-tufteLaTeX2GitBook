### pandoc-tufteLaTeX2GitBook


A modified version of the pandoc program that handles the sidenotes, marginnotes and footnote spacing adjustments that are part of the tufteLaTeX documentclass.

##### Why build this?

To streamline the publication of papers and short books across multiple formats, specifically PDF/print to versionable text with GitBook.

##### Background

I wrote a paper and formatted the print version as a PDF using the tufte-LaTeX book class, which allows citations and notes to float in the margin of the page. The resulting PDF can be used to update the print version, but the online version - published via GitBook - requires markdown. The tremendous [pandoc](https://github.com/jgm/pandoc), allows automatic conversion between LaTeX and markdown, but did not properly handle the tufte-LaTeX `sidenote` and `marginnote` elements, eliminating them from the resulting markdown. Similarly, in tufte-LaTeX the `footnote` element has optional numbering and positioning arguments, but footnotes that used these were also ignored. Though a combination of pandoc transformations and regular expressions could get the job done, I wanted a more elegant and (sort of) reliable solution.

And because hacking some Haskell sounded like fun.


##### Installing Haskell in order to modify/compile/run pandoc from source

As often happens, the hardest part is getting the environment set up. I strongly suggest that any organization with substantial resources claiming to care about diversifying the programming community tackle this problem head-on. High-level programming (even in functional languages like Haskell) requires intellectual capacity; setting up the environments for it usually requires arcane, OS-specific *knowledge* that newcomers will have difficulty acquiring if they don't have an existing network of people to ask. The result is that many people with an interest in programming but no personal network in the community are frustrated by the artificially high barrier to entry posed by simply getting the thing up and running. This is doubly worthless because the process of setting up the environment adds nothing on one's understanding of the programming langauge in question, or even programming in general.\*

> *\*I know this intimately because each year I spend many hours setting up Python environments for my journalism students on their own computers. Not one of them has ever failed to grasp the fundamentals of regular expressions or Python programming, but almost none of them could get a functioning version of Python working on their machine without help.*


*The following instructions work on Mac OSX 10.6. Any additions adjustments for other operating systems welcome.*

###### What to get and where to get it
+ Download and install [The Haskell Platform](https://www.haskell.org/platform/). Note that by default this will install Haskell *globally* (e.g. for all user profiles on your computer). More on that later.
+ Depending on what kind of modification you're doing, you may need up to 2 or 3 related folders of code, which you'll probably want to group together in a single folder for yourself.
  1. The main repository [pandoc](https://github.com/jgm/pandoc) lets you modify the "readers" and "writers" of different file types. For example, in this project, I modified the latex.hs file in the "Readers" folder to ignore optional arguments passed to the LaTeX `footnote` tag (of the format `[][-1.0cm]\footnote{MyFootnoteHere}`).
  2. There is a related repository, called [pandoc-types](https://github.com/jgm/pandoc-types), which you'll need to modify if you need new types or commands to be recognized by your readers or writers. In my case, I needed the LaTeX reader to be able to handle two new commands, `marginnote` and `sidenote`. This meant modifying pandoc-types.
  3. Finally, there is a [pandoc-filters](https://github.com/jgm/pandocfilters) repo, which allows you to write/run "filters" written in Python (if you need help installing Python, I have done some [video walkthroughs of installing Python](http://youtu.be/iZzMm2RlvaE] which may be helpful). In this project, I wanted to change how the markdown output format rendered footnotes so that it rendered them in superscript and linked them to a specified html file. While I obviously *could* have done this directly in the markdown.hs "writer", it's not something I want to happen with *every* markdown file I create with pandoc; making it a filter provides more flexibility and control.
+ Download and unzip/expand the source code from the latest release of each of the codebases you need, and move the folder into your project folder (in each case, click on the "Releases" tab for the latest stable code release):
  + [pandoc](https://github.com/jgm/pandoc)
  + [pandoc-types](https://github.com/jgm/pandoc-types)
  + [pandoc-filters](https://github.com/jgm/pandocfilter)

>If you have an existing install of `pandoc` on your machine, it's important that you uninstall it before installing it from source. If you used the OSX installer for your current version, re-download the zipfile, expand it, and run the `uninstall-pandoc.pl`. You can do this by moving into that folder and running the commmand: `perl uninstall-pandoc.pl`
from the terminal.

###### Configuring your system and compiling the code

There are two basic steps you need to complete before you can run pandoc from the source code you just downloaded. First, you need to install the code itself, and then you need to update your "PATH" file so that your computer knows where to look for the appropriate code when you type the `pandoc` command. 

1. Compile your source code (in order!) using the `cabal` command.
  + In terminal, move into the `pandoc-types` folder (the actual name will probably end in a version number), and run 'cabal update`. If prompted, run the provided update command for `cabal` itself: `cabal install cabal-install`. Finally, run `cabal install --force`. (When you later make changes to the code in `pandoc-types` you'll need to recompile it using `cabal install --force-reinstall` before your changes will take effect). Note that the first compile can take many minutes.
  + Next, do move into your main `pandoc` code folder and run `cabal install` there. Again, this can take many minutes to compile, especially the first time, so get a cup of coffee or take a walk. 
  + Finally, do the same with the code in your `pandoc-filters` folder. `cabal install` is the general "compile" command for pandoc/Haskell(?).
2. Update your `PATH` file so that pandoc will actually *run* from the code you just installed.
  + In terminal, type `open ~/.cabal/config` and hit enter. A text file should open up in TextEdit or a similar program that starts with "--This is the configuration file for the 'cabal' command line tool." About 20 lines down you'll see a something that says: 

      >--You may wish to place this on your PATH by adding the following  
      --line to your ~/.bash_profile:  
      --export PATH="$HOME/Library/Haskell/bin:$PATH"  
  
  + To actually **do** this, go back to terminal and type `open ~/.bash_profile` and hit enter. Don't worry if the file is empty, just add the line above to the file, save and then close it. 
3. Test it out! In terminal, type `pandoc --help` and hit return. If a whole bunch of instructions appear, you're up and running!










