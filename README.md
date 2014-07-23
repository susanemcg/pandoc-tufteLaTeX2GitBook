### pandoc-tufteLaTeX2GitBook


A modified version of the pandoc program that handles the sidenotes, marginnotes and footnote spacing adjustments that are part of the tufteLaTeX documentclass.

##### Why build this?

To streamline the publication of papers and short books across multiple formats, specifically PDF/print to versionable text with GitBook.

##### Background

I wrote a paper and formatted the print version as a PDF using the tufte-LaTeX book class, which allows citations and notes to float in the margin of the page. The resulting PDF can be used to update the print version, but the online version - published via GitBook - requires markdown. The tremendous [pandoc](https://github.com/jgm/pandoc), allows automatic conversion between LaTeX and markdown, but did not properly handle the tufte-LaTeX `sidenote` and `marginnote` elements, eliminating them from the resulting markdown. Similarly, in tufte-LaTeX the `footnote` element has optional numbering and positioning arguments, but footnotes that used these were also ignored. Though a combination of pandoc transformations and regular expressions could get the job done, I wanted a more elegant and (sort of) reliable solution.

And because hacking some Haskell sounded like fun.


##### Installing Haskell in order to modify/compile/run pandoc from source

As often happens, the hardest part is getting the environment set up. I strongly suggest that any organization with substantial resources claiming to care about diversifying the programming community tackle this problem head-on. High-level programming (even in functional languages like Haskell) requires intellectual capacity; setting up the environments for it usually requires arcane, OS-specific *knowledge* that newcomers will have difficulty acquiring if they don't have an existing network of people to ask. The result is that many people with an interest in programming but no personal network in the community are frustrated by the artificially high barrier to entry posed by simply getting the thing up and running. This is doubly worthless because the process of setting up the environment adds nothing on one's understanding of the programming langauge in question, or even programming in general.\*

> *\*I know this inimately because each year I spend many hours setting up Python environments for my journalism students on their own computers. Not one of them has ever failed to grasp the fundamentals of regular expressions or Python programming, but almost none of them could get a functioning version of Python working on their machine without help.*






