### pandoc-tufteLaTeX2GitBook


A modified version of the pandoc program that handles the sidenotes, marginnotes and footnote spacing adjustments that are part of the tufteLaTeX documentclass.

##### Why build this?

To streamline the publication of papers and short books across multiple formats, specifically PDF/print to versionable text with GitBook. Specifically, the LaTeX that generates [this print book](http://www.lulu.com/shop/susan-mcgregor/digital-security-and-source-protection-for-journalists/paperback/product-21720537.html) into the markdown that generated [this GitBook](https://www.gitbook.io/book/susanemcg/digital-security-for-journalists).

##### Background

I recently wrote a paper ([Digital Security and Source Protection for Journalists](http://towcenter.org/digital-security-and-source-protection-for-journalists/)), and formatted the print version as a PDF using the tufte-LaTeX book class, which allows citations and notes to float in the margin of the page. The resulting PDF can be used to update the print version, but the online version - published via GitBook - requires markdown. The tremendous [pandoc](https://github.com/jgm/pandoc) allows automatic conversion between LaTeX and markdown, but did not properly handle the tufte-LaTeX `sidenote` and `marginnote` elements, eliminating them from the resulting output. Similarly, in tufte-LaTeX the `footnote` element has optional numbering and positioning arguments, but footnotes that used these in the original document were also ignored in the markdown version. Though a combination of pandoc transformations and regular expressions could get the job done, I wanted a more elegant and (sort of) reliable solution.

And because hacking some Haskell sounded like fun.


##### Installing Haskell in order to modify/compile/run pandoc from source

As often happens, the hardest part is getting the environment set up. I strongly suggest that any organization with substantial resources claiming to care about diversifying the programming community tackle this problem head-on. High-level programming (even in functional languages like Haskell) requires intellectual capacity; setting up the environments for it usually requires arcane, OS-specific *knowledge* that newcomers will have difficulty acquiring if they don't have an existing network of people to ask. The result is that many people with an interest in programming but no personal network in the community are frustrated by the artificially high barrier to entry posed by simply getting the thing up and running. This is doubly worthless because the process of setting up the environment adds nothing on one's understanding of the programming langauge in question, or even programming in general.\*

> *\*I know this intimately because each year I spend many hours setting up Python environments for my journalism students on their own computers. Not one of them has ever failed to grasp the fundamentals of regular expressions or Python programming, but almost none of them could get a functioning version of Python working on their machine without help.*


*The following instructions work on Mac OSX 10.6. Any additions adjustments for other operating systems welcome.*

###### What to get and where to get it
+ Download and install [The Haskell Platform](https://www.haskell.org/platform/). Note that by default this will install Haskell *globally* (e.g. for all user profiles on your computer). More on that later.
+ Depending on what kind of modification you're doing, you may need up to 2 or 3 related folders of code, which you'll probably want to group together in a single folder for yourself.
  1. The main repository [pandoc](https://github.com/jgm/pandoc) lets you modify the "readers" and "writers" of different file types. For example, in this project, I modified the latex.hs file in the "Readers" folder to ignore optional arguments passed to the LaTeX `footnote` tag (of the format `[][-1.0cm]\footnote{MyFootnoteHere}`). You'll also need to download the [pandoc-templates](https://github.com/jgm/pandoc-templates/) repo.
  2. There is a related repository, called [pandoc-types](https://github.com/jgm/pandoc-types), which you'll need to modify if you need new types or commands to be recognized by your readers or writers. In my case, I needed the LaTeX reader to be able to handle two new commands, `marginnote` and `sidenote`. This meant modifying pandoc-types.
  3. Finally, there is a [pandoc-filters](https://github.com/jgm/pandocfilters) repo, which allows you to write/run "filters" written in Python (if you need help installing Python, I have done some [video walkthroughs of installing Python](http://youtu.be/iZzMm2RlvaE] which may be helpful). In this project, I wanted to change how the markdown output format rendered footnotes so that it rendered them in superscript and linked them to a specified html file. While I obviously *could* have done this directly in the markdown.hs "writer", it's not something I want to happen with *every* markdown file I create with pandoc; making it a filter provides more flexibility and control.
+ Download and unzip/expand the source code from the latest release of each of the codebases you need, and move the folder into your project folder (in each case, click on the "Releases" tab for the latest stable code release):
  + [pandoc](https://github.com/jgm/pandoc)
  + [pandoc-templates](https://github.com/jgm/pandoc-templates/)
  + [pandoc-types](https://github.com/jgm/pandoc-types)
  + [pandoc-filters](https://github.com/jgm/pandocfilters)

>If you have an existing install of `pandoc` on your machine, it's important that you uninstall it before installing it from source. If you used the OSX installer for your current version, re-download the zipfile, expand it, and run the `uninstall-pandoc.pl`. You can do this by moving into that folder and running the commmand: `perl uninstall-pandoc.pl`
from the terminal.

###### Configuring your system and compiling the code

There are two basic steps you need to complete before you can run pandoc from the source code you just downloaded. First, you need to install the code itself, and then you need to update your "PATH" file so that your computer knows where to look for the appropriate code when you type the `pandoc` command. 

1. Compile your source code (in order!) using the `cabal` command.
  + In terminal, move into the `pandoc-types` folder (the actual name will probably end in a version number), and run 'cabal update`. If prompted, run the provided update command for `cabal` itself: `cabal install cabal-install`. Finally, run `cabal install --force`. (When you later make changes to the code in `pandoc-types` you'll need to recompile it using `cabal install --force-reinstalls` before your changes will take effect). Note that the first compile can take many minutes.
  + Next, move all of the files in your unzipped `pandoc-templates` folder into `pandoc-[version number]/data/templates`. You can just copy and paste them as you would any other files, and then delete the (now empty) original folder.
  + In terminal, move into your main `pandoc` code folder and run `cabal install` there. Again, this can take many minutes to compile, especially the first time, so get a cup of coffee or take a walk. 
  + Finally, move into your `pandoc-filters` folder and run the command `python setup.py install`.
2. Update your `PATH` file so that pandoc will actually *run* from the code you just installed.
  + In terminal, type `open ~/.cabal/config` and hit enter. A text file should open up in TextEdit or a similar program that starts with "--This is the configuration file for the 'cabal' command line tool" (if this doesn't work, try `open -a "TextEdit" .bash_profile`) About 20 lines down you'll see something that says: 

      >--You may wish to place this on your PATH by adding the following  
      --line to your ~/.bash_profile:  
      --export PATH="$HOME/Library/Haskell/bin:$PATH"  
  
  + To actually **do** this, go back to terminal and type `open ~/.bash_profile` and hit enter. If the file doesn't exist, try `touch .bash_profile` (this will create the file). Don't worry if the file is empty, just add the line above to the file, save and then close it. Then in terminal run `source .bash_profile`, which will force your system to recognize the changes (there is a helpful how-to on these steps on [StackOverflow](https://superuser.com/questions/409501/edit-bash-profile-in-os-x))
3. Test it out! In terminal, type `pandoc --help` and hit return. If a whole bunch of instructions appear, you're up and running!

##### The modifications

###### Modifying `pandoc-types`

The document elements that pandoc recognizes are enumerated and described (primarily) in two files found in `pandoc-types -> Text -> Pandoc`: `Definition.hs` and `Builder.hs`. Modifying these is fairly straightforward (though my implementation is not exhaustive - hence why this repo is *not* currently a fork). I needed pandoc to be able recognize `marginnote` and `sidenote` as legitimate LaTeX tags, and so inserted them by following the pattern used for other inline text elements like emphasis and super/sub scripting tags. This means they will be part of the intermediate document tree than pandoc creates when moving from LaTeX to another format. (These changes can be compiled into the executable code using the same `cabal install --force-reinstalls` command noted above)

###### Modifying `pandoc`

Once the types have been modified and recompiled, the next step is to modify the appropriate "reader" and "writer" files so that pandoc knows what to do with the new elements. Because I was centrally concerned with the LaTeX -> markdown transformation, I worked with the LaTeX reader and the markdown writer.

  1. Open the appropriate "reader" file in `pandoc -> src -> Text -> Pandoc -> Readers`, in this case, `LaTeX.hs`.
  2. Add your new elements to the appropriate `-Commands` function. Because I added "inline" elements, mine were added to `inlineCommands`.
  3. As I had no prior experience with either the pandoc codebase or Haskell, working out how to produce the tags I was looking for took a fair amount of trial and error. Eventually, however, I worked out the following:
    + In the line `("marginnote", skipopts *> (marginnote <$> tok))`, the "marginnote" needs to match the name of the element that will appear in the LaTeX source file. This also needs to match the element/tag added to `Builder.hs` in `pandoc-types`. The description *of* that element in `Builder.hs`, however, needs to match the format that was added to `Definition.hs` in that same library. In this case, that was `MarginNote`.
    + The function `skipopts` already existed to skip bracketed options on other LaTeX elements. The `*>` and `<$> tok` arguments were determined by trial-and-error after reviewing how some similar tags were handled. A similar process followed for modifying the `footnote` element, which was handled properly except that those with leading bracketed options were ignored. In that case, just adding the `skipopts *>` call and closing the parens properly was sufficient.
  4. Open the appropriate "writer" file in `pandoc -> src -> Text -> Pandoc -> Writers`, in this case, `Markdown.hs`.
  5. Describe how the new elements should be converted expressed/formatted in markdown by adding them to the appropriate `-ToMarkdown` function, in this case `inlineToMarkdown`. I decided to render `sidenote` and `marginnote` elements as block quotes, which meant surrounding them with blank lines (pandoc already had a handy `blankline` method for that) and preceding the actual text with a `>` character. The general pattern of the resulting code was modifying from other inline elements (note that `MarginNote` matches the type definition we created in `Definition.hs` within `pandoc-types`):

      inlineToMarkdown opts (MarginNote lst) = do
      contents <- inlineListToMarkdown opts lst
      return $ blankline <> " > " <> contents <> "" <> blankline  
  
  6. Once all the changes are made, recompile the pandoc with the `cabal install` command used above. Note that this will both take a while and that the compiler will yell at you for not making the new elements that you've made "readable" via the `LaTeX.hs` reader also "writable" by all types (not just markdown). So unless/until you modify all the available writers to handle your new elements, you will many warnings like this when you compile, but it will still work for the reader/writer combination that you *have* modified properly:

      src/Text/Pandoc/Writers/AsciiDoc.hs:325:1: Warning:
      Pattern match(es) are non-exhaustive
      In an equation for `inlineToAsciiDoc':
        Patterns not matched:
            _ (MarginNote _)
            _ (SideNote _)

###### Creating the filter

The modifications to `pandoc` and `pandoc-types` handled the most essential issues, i.e. making sure that no content was lost in the document conversion process. But I was not entirely happy with the inline treatment of the footnotes: while they were formatted as a nice list of links at the end of the markdown file, the inline citations were plaintext, of the format `[^3]` for example. Not linked, not superscripted. Given the format of my GitBook, I wanted to make all inline footnote citations render as superscripted numerals that link to a specified html file (when I port the markdown to GitBook, it means breaking up the generated markdown into multiple files).

Of course I could (and at first did) hack this by hard-coding the html (including the filename) into the footnote handling method of the `Markdown.hs` writer. Turns out I could only live with that for about 5 hours, and after hunting around a bit determined that my best option was to write a filter in Python that would transform all `Note` elements from the pandoc document tree and render them as inline html.

Since there are a number of examples in the repo and I'm pretty familiar with Python, the trickiest part of this was identifying the correct data type both to search for (i.e. `Note`) and to output to the markdown file (filters work on the intermediate pandoc document tree). Doing this very robustly would have required a much more intimate understand of both pandoc and Haskell that I have or am willing to acquire in the near future, so I settled for writing `RawInline` html. 

This was sufficient to add the required `<sup></sup>` tags without their being subsequently escaped in the translation to markdown (which was the result when I tried to use the `Str` type). For the actual number, I borrowed a trick from the `theorem.py` example, and simply created a global variable. Finally, I learned that metadata arguments passed the the `pandoc` command are accessible to filters via the `meta` parameter, and so used that to pass in the name of the file to which I wanted all of my footnotes to link. Though I am sure there is a more elegant way to pull the necessary info from the unicode parameter, I also wasn't ready to invest the time to locate it for this example, hence the `meta['footnote_file']['c']`.

In order to actually *use* your filter, you'll need to do the following:

1. Make it executable by running `chmod +x your_new_filter.py` 
2. Assuming you've place it within the `pandocfilters -> examples` folder, you'll also need to re-run the `python setup.py install` command.
3. Finally, you need to add that examples folder to your `PATH` by once again editing your `~/. bash_profile` file (don't forget to run `source ~/.bash_profile` afterwards!). So, for example, I added the line:

  `export PATH="$HOME/Desktop/Projects/pandoc/pandoc-tufteLaTeX2GitBook/pandocfilters-1.2.1/examples/:$PATH"`


##### Using the modified version of pandoc with your filter

If everything is working correctly, you should be able to run both pandoc and your new filter(s) on any file within your current user (e.g. on this same login). The final command for running the pandoc conversion with the `footnote_file` metadata parameter and filter is:

`pandoc YourTexFile.tex -f latex -t markdown -o YourMarkdownFile.md -M footnote_file=footnotes/README.html --filter external_footnotes.py`

> Note that using the filter currently eliminates the default footnote list at the bottom of the markdown file, which means running the above once without the filter (and extracting the footnote markdown to your external file) and then again with the filter to get the correct formatting/linking for the footnotes.















