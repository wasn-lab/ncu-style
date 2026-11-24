% Class declarations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ncu}
\LoadClassWithOptions{article}

% Layout %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ncu: footskip (distance from the last text line to the page number) is set
% explicitly, see the Page style section.
\RequirePackage[top=2.25cm, bottom=2.5cm, left=2.5cm, right=2.5cm, columnsep=0.65cm,
  footskip=1.1cm]{geometry}
\RequirePackage{microtype}
\RequirePackage{placeins}
\RequirePackage{hyphenat}
\RequirePackage{setspace}
\RequirePackage{parskip}
% ncu: Latin is only there for the hyphenation of the lipsum placeholder text.
% Not every TeX installation has babel-latin, and without it the class stopped
% with an error, so Latin is loaded only when it is available.
\IfFileExists{latin.ldf}%
  {\RequirePackage[latin, english]{babel}}%
  {\RequirePackage[english]{babel}}
\RequirePackage{lipsum}
\RequirePackage{etoolbox}

\DisableLigatures[f]{family=sf*} 

% Math %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{mathtools}

% Graphics %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{graphicx}
\RequirePackage{subcaption}

% Tables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{booktabs}
\RequirePackage{nicematrix}
\RequirePackage{multirow}
\RequirePackage{bm}
\RequirePackage{threeparttable}
\newcommand{\nm}[1]{#1}

% Colorful stuff %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[most]{tcolorbox}
\RequirePackage{xcolor}
\definecolor{ncublue}{HTML}{00609A}
\definecolor{ncufg}{HTML}{1C2B33}
% ncu: the title box background was a neutral gray (F2F2F2). A cool gray
% matches the blue-gray text color ncufg and the blue accent.
\definecolor{ncubg}{HTML}{F1F4F7}
% ncu: accent for the heading numbers (change it here to recolor all of them)
% and a muted gray for the bar in the captions.
\colorlet{ncuaccent}{ncublue}
\definecolor{ncumuted}{HTML}{5F6B73}
% ncu: color of the rule under the running header.
\colorlet{ncurule}{ncumuted!60}

% References %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{hyperref}
\RequirePackage{xurl}
\RequirePackage[noabbrev,nameinlink]{cleveref}
\hypersetup{
  colorlinks,
  linkcolor=ncublue,
  citecolor=ncublue,
  urlcolor=ncublue,
  bookmarksdepth=3
}

\RequirePackage[round,authoryear]{natbib}
\def\bibfont{\small}

% Section and caption format %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{titlesec}
% ncu: The title and the headings use the semibold weight of IBM Plex Sans.
% The series is requested explicitly, so \bfdefault (used by the body text and
% by \textbf) is left untouched. Change "sb" to "bx" to go back to true bold.
\newcommand*{\ncuheadseries}{sb}
\newcommand{\ncuheadbf}{\sffamily\fontseries{\ncuheadseries}\selectfont}
% Heading text uses IBM Plex Sans (\sffamily, semibold), while the heading
% math mode uses IBM Plex Serif through \ncuheadmath (defined in the Fonts
% section below).
% ncu: only the number is colored (ncuaccent), the heading text stays black.
\titleformat{\paragraph}[runin]{\normalfont\ncuheadmath\ncuheadbf}{}{0pt}{}
\titlespacing*{\paragraph}{0pt}{1.25mm}{1em}
\titleformat{\section}{\ncuheadmath\Large\ncuheadbf}%
  {\textcolor{ncuaccent}{\thesection}}{1em}{}
\titleformat{\subsection}{\ncuheadmath\large\ncuheadbf}%
  {\textcolor{ncuaccent}{\thesubsection}}{1em}{}
\titleformat{\subsubsection}{\ncuheadmath\normalsize\ncuheadbf}%
  {\textcolor{ncuaccent}{\thesubsubsection}}{1em}{}
% ncu: \textbf is no longer redefined to IBM Plex Sans bold. It made the bold
% numbers in tables and the bold words in the text switch to the sans font.
% \textbf is the bold Latin Modern again, and \textsfb gives the old sans bold.
\DeclareTextFontCommand{\textsfb}{\bfseries\sffamily}
\DeclareTextFontCommand{\textbfps}{\bfseries\sffamily\ncuheadmath}

\newcommand{\subsubsubsection}[1]{\paragraph{#1}\mbox{}\\}
% ncu: \paragraph prints no number, so numbering it only leaked entries such
% as "1.0.0.1 Run-in heading" into the table of contents. Stop at level 3.
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{3}

\RequirePackage{caption}
% ncu: captions read "Figure 1 | Caption text". The label uses the semibold
% heading font and is followed by a thin vertical bar in a muted gray.
% Subfigure labels stay "(a) Caption text", without the bar.
\DeclareCaptionLabelFormat{ncu}{{\ncuheadbf #1~#2}}
\DeclareCaptionLabelFormat{ncusub}{{\ncuheadbf (#2)}}
\DeclareCaptionLabelSeparator{ncubar}{%
  \enspace{\color{ncumuted!55}\rule[-0.18em]{0.6pt}{0.95em}}\enspace}
\captionsetup{labelformat=ncu,labelsep=ncubar,singlelinecheck=false,font=small}
\captionsetup[sub]{labelformat=ncusub,labelsep=space,singlelinecheck=true,font=small}

% Key findings %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ncu: a tinted box for the main findings, numbered "Finding 1", "Finding 2".
%   \begin{keyfinding}[Optional title]\label{fd:main} ... \end{keyfinding}
% \cref{fd:main} prints "finding 1". The box does not break across pages. For
% a long finding, pass tcolorbox options as a second optional argument:
%   \begin{keyfinding}[Optional title][breakable] ... \end{keyfinding}
\newcommand\ncufindingname{Finding}
% tcolorbox steps the counter inside a scratch box, so a \label written in the
% box saw the enclosing section instead. The label data is saved globally
% there and restored at the start of the box content.
\newcommand\ncu@savefindinglabel{%
  \global\let\ncu@findinglabel\@currentlabel
  \ifdefined\cref@currentlabel
    \global\let\ncu@findingcreflabel\cref@currentlabel\fi}
\newcommand\ncu@restorefindinglabel{%
  \let\@currentlabel\ncu@findinglabel
  \ifdefined\cref@currentlabel
    \let\cref@currentlabel\ncu@findingcreflabel\fi}
\DeclareTColorBox[auto counter]{keyfinding}{ O{} O{} }{%
  enhanced, unbreakable, before skip=9pt, after skip=9pt,
  colback=ncuaccent!6!white, colframe=ncuaccent!35!white, boxrule=0.6pt,
  arc=7pt, outer arc=7pt, left=12pt, right=12pt, top=8pt, bottom=8pt,
  phantom={\ncu@savefindinglabel},
  before upper={\ncu@restorefindinglabel
    \noindent{\ncuheadbf\color{ncuaccent}\ncufindingname~\thetcbcounter}%
    \ifblank{#1}{}{\enspace\textbf{#1.}}\enspace},
  #2}
% The crefname option of tcolorbox did not register the names, so they are
% given to cleveref directly.
\crefname{tcb@cnt@keyfinding}{finding}{findings}
\Crefname{tcb@cnt@keyfinding}{Finding}{Findings}

% Fonts %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Body text uses Latin Modern (lmodern); IBM Plex Sans is the sans family
% used by titles and headings; IBM Plex Mono is the monospace family used by
% code and URLs.
% ncu: the LGR encoding (greek-fontenc) gives access to the Greek letters of
% IBM Plex Serif for the heading math. Without it, the class still works and
% the heading math falls back to bold Latin Modern Greek letters.
\newif\ifncu@lgr
\IfFileExists{lgrenc.def}%
  {\ncu@lgrtrue\RequirePackage[LGR,T1]{fontenc}}%
  {\RequirePackage[T1]{fontenc}}
\RequirePackage{lmodern}
\RequirePackage[scale=0.92, semibold]{plex-sans}
\renewcommand{\bfdefault}{bx}
\RequirePackage[scale=0.92]{plex-mono}

% Load IBM Plex Serif only to obtain its NFSS family for the math version.
% plex-serif sets \rmdefault to the IBM Plex Serif family, so we save the
% current body roman default first, capture the IBM Plex Serif family, and
% then restore the body roman font (Latin Modern) afterwards.
\let\ncubodyrmdefault\rmdefault
\RequirePackage[scale=0.92]{plex-serif}
\edef\ncuplexseriffamily{\rmdefault}
\let\rmdefault\ncubodyrmdefault

% Math version for the title and the headings: IBM Plex Serif %%%%%%%%%%%%%%%%%
% This math version is activated only inside the title and the section
% headings (through \ncuheadmath), so the body math keeps the default Latin
% Modern fonts.
% ncu: its weight follows \ncuheadseries, so the heading math matches the
% semibold heading text. Replace \ncuheadseries by \bfdefault to get bold.
%
% ncu: the "letters" symbol font must stay OML-encoded. It also holds the
% lowercase Greek letters and the math "." "," "/" "<" ">", \partial and \ell,
% and a T1 font put other glyphs in those slots (for example $\delta$ came out
% as a guillemet and $3.5$ as "3:5"). So "letters" and "symbols" use bold
% Latin Modern here, the Latin letters a-z and A-Z get a symbol font of their
% own (ncuplexletters), and \ncuheadmath points them and the Greek letters to
% IBM Plex Serif locally, inside the heading only.
\DeclareMathVersion{plexserif}
\SetSymbolFont{letters}{plexserif}{OML}{lmm}{b}{it}
\SetSymbolFont{symbols}{plexserif}{OMS}{lmsy}{b}{n}
% Digits and upright operators use the IBM Plex Serif upright shape.
\SetSymbolFont{operators}{plexserif}{T1}{\ncuplexseriffamily}{\ncuheadseries}{n}
% Variable letters a-z and A-Z use the IBM Plex Serif italic shape.
\DeclareSymbolFont{ncuplexletters}{T1}{\ncuplexseriffamily}{m}{it}
\SetSymbolFont{ncuplexletters}{plexserif}{T1}{\ncuplexseriffamily}{\ncuheadseries}{it}

\SetMathAlphabet{\mathbf}{plexserif}{T1}{\ncuplexseriffamily}{\ncuheadseries}{n}
\SetMathAlphabet{\mathrm}{plexserif}{T1}{\ncuplexseriffamily}{\mddefault}{n}
\SetMathAlphabet{\mathit}{plexserif}{T1}{\ncuplexseriffamily}{\mddefault}{it}
\SetMathAlphabet{\mathsf}{plexserif}{T1}{\sfdefault}{\mddefault}{n}
\SetMathAlphabet{\mathtt}{plexserif}{T1}{\ttdefault}{\mddefault}{n}

% \ncuheadmath: switch the math of the current group to IBM Plex Serif.
% All assignments are local, so they end with the heading.
\newcount\ncu@cnt
\def\ncu@plexletters{\ncu@cnt=`A \ncu@plexletters@step}
\def\ncu@plexletters@step{%
  \mathcode\ncu@cnt=\numexpr"7000+"100*\symncuplexletters+\ncu@cnt\relax
  \mathcode\numexpr\ncu@cnt+32\relax=%
    \numexpr"7000+"100*\symncuplexletters+\ncu@cnt+32\relax
  \advance\ncu@cnt\@ne
  \ifnum\ncu@cnt<`[ \expandafter\ncu@plexletters@step\fi}
% "." "," "/" "<" ">" from the upright IBM Plex Serif (the operators font).
\def\ncu@plexpunct{%
  \mathcode`\.="002E \mathcode`\,="602C \mathcode`\/="002F
  \mathcode`\<="303C \mathcode`\>="303E }
% Greek letters from IBM Plex Serif (LGR): lowercase italic, uppercase upright.
\def\ncu@greek#1#2{\mathord{\text{\fontencoding{LGR}%
  \fontfamily{\ncuplexseriffamily}\fontseries{\ncuheadseries}%
  \fontshape{#1}\selectfont#2}}}
\def\ncu@g#1#2#3{\def#1{\ncu@greek{#2}{#3}}}
\def\ncu@plexgreek{%
  \ifncu@lgr
    \ncu@g\alpha{it}\textalpha     \ncu@g\beta{it}\textbeta
    \ncu@g\gamma{it}\textgamma     \ncu@g\delta{it}\textdelta
    \ncu@g\epsilon{it}\textepsilon \ncu@g\varepsilon{it}\textepsilon
    \ncu@g\zeta{it}\textzeta       \ncu@g\eta{it}\texteta
    \ncu@g\theta{it}\texttheta     \ncu@g\vartheta{it}\texttheta
    \ncu@g\iota{it}\textiota       \ncu@g\kappa{it}\textkappa
    \ncu@g\lambda{it}\textlambda   \ncu@g\mu{it}\textmu
    \ncu@g\nu{it}\textnu           \ncu@g\xi{it}\textxi
    \ncu@g\pi{it}\textpi           \ncu@g\varpi{it}\textpi
    \ncu@g\rho{it}\textrho         \ncu@g\varrho{it}\textrho
    \ncu@g\sigma{it}\textsigma     \ncu@g\varsigma{it}\textfinalsigma
    \ncu@g\tau{it}\texttau         \ncu@g\upsilon{it}\textupsilon
    \ncu@g\phi{it}\textphi         \ncu@g\varphi{it}\textphi
    \ncu@g\chi{it}\textchi         \ncu@g\psi{it}\textpsi
    \ncu@g\omega{it}\textomega
    \ncu@g\Gamma{n}\textGamma      \ncu@g\Delta{n}\textDelta
    \ncu@g\Theta{n}\textTheta      \ncu@g\Lambda{n}\textLambda
    \ncu@g\Xi{n}\textXi            \ncu@g\Pi{n}\textPi
    \ncu@g\Sigma{n}\textSigma      \ncu@g\Upsilon{n}\textUpsilon
    \ncu@g\Phi{n}\textPhi          \ncu@g\Psi{n}\textPsi
    \ncu@g\Omega{n}\textOmega
  \else
    % Fallback: the uppercase Greek letters live in the operators font, which
    % is T1 here, so take the italic ones from the (OML) letters font instead.
    \let\Gamma\varGamma \let\Delta\varDelta \let\Theta\varTheta
    \let\Lambda\varLambda \let\Xi\varXi \let\Pi\varPi \let\Sigma\varSigma
    \let\Upsilon\varUpsilon \let\Phi\varPhi \let\Psi\varPsi
    \let\Omega\varOmega
  \fi}
\newcommand*{\ncuheadmath}{%
  \mathversion{plexserif}\ncu@plexletters\ncu@plexpunct\ncu@plexgreek}

% Authors, affiliations, infos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ncu: this helper used to overwrite \addtolist, a scratch macro of geometry.
% A \geometry call in the preamble that sets the paper size (a4paper,
% paperwidth=...) redefined it again, and every \author after it broke.
% It has its own name now.
\newcommand\ncu@addtolist[5][]{%
  \begingroup
    \if\relax#3\relax\def\sep{}\else\def\sep{#5}\fi
    \let\protect\@unexpandable@protect
    \xdef#3{\expandafter{#3}\sep #4[#1]{#2}}%
  \endgroup
}

\newcommand\authorlist{}
\newcommand\authorformat[2][]{{\sffamily \bfseries #2$^{#1}$}}
\renewcommand\author[2][]{\ncu@addtolist[#1]{#2}{\authorlist}{\authorformat}{, }}

\newcommand\affiliationlist{}
\newcommand\affiliationformat[2][]{{\normalsize $^{#1}$#2}}
\newcommand\affiliation[2][]{\ncu@addtolist[#1]{#2}{\affiliationlist}{\affiliationformat}{, }}

\newcommand\contributionlist{}
\newcommand\contributionformat[2][]{{\small $^{#1}$#2}}
\newcommand\contribution[2][]{\ncu@addtolist[#1]{#2}{\contributionlist}{\contributionformat}{, }}

\newcommand\ncudatalist{}
\newcommand\ncu@datalabel[1]{{\sffamily\bfseries #1:}}
\newcommand\ncudataformat[2][]{{\small \ncu@datalabel{#1} #2}}
\newcommand\ncudataindent[1]{\hphantom{\ncu@datalabel{#1} }}
\newcommand\ncudata[2][]{\ncu@addtolist[#1]{#2}{\ncudatalist}{\ncudataformat}{\par}}

% ncu: empty defaults, so \maketitle works without \title or \abstract.
\newcommand\titlelist{}
\newcommand\abstractlist{}
\renewcommand{\abstract}[1]{\def\abstractlist{{\color{ncufg} #1}}}
\AtBeginDocument{\urlstyle{tt}}
\newcommand{\code}[1]{\texttt{#1}}
\newcommand{\codeurl}[1]{\href{#1}{\nolinkurl{#1}}}
\newcommand{\email}[1]{\href{mailto:#1}{\nolinkurl{#1}}}

\renewcommand\date[1]{\ncudata[Date]{#1}}
\newcommand\correspondence[1]{\ncudata[Correspondence]{#1}}
\newcommand\codelink[1]{\ncudata[Code]{\codeurl{#1}}}
\newcommand\preprintformat[2][]{{\small\sffamily\bfseries #2}}
\newcommand\preprint[1]{\ncu@addtolist{#1}{\ncudatalist}{\preprintformat}{\par}}

% Title text uses IBM Plex Sans (\sffamily, semibold), while the title math
% mode uses IBM Plex Serif through \ncuheadmath.
% ncu: \def instead of \newcommand, so a second \title no longer errors.
% The title is also kept as written (\ncu@rawtitle) for the running header.
% \textls[-10] tightens the letter spacing slightly, as large sans titles need.
\newcommand\ncu@rawtitle{}
\renewcommand{\title}[1]{%
  \def\ncu@rawtitle{#1}%
  \def\titlelist{{\ncuheadmath\huge\ncuheadbf\textls[-10]{#1}\par}}}

\newcommand{\beginappendix}{\appendix{\huge\ncuheadbf Appendix\par}}

% Page style %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ncu: as in the ICLR template, the running title sits on the left of the
% header with a thin rule under it (color ncurule), and the page number is
% centered at the bottom of every page. Both use small muted IBM Plex Sans.
% The first page (the "plain" style, set by \maketitle) has no header, only
% the page number.
% \shorttitle{...} sets the header text. Without it, the full title is used.
% \pagestyle{plain} on every page drops the header altogether.
%
% Footnotes are set inside the text block, and the page number sits \footskip
% (1.1cm, set in the geometry options) below the last line of that block, so
% a footnote cannot run into the page number.
\RequirePackage{fancyhdr}
\newcommand\ncu@shorttitle{}
\newcommand\shorttitle[1]{\def\ncu@shorttitle{#1}}
\newcommand\ncu@headfont{\footnotesize\sffamily\color{ncumuted}}
\newcommand\ncu@runningtitle{%
  {\let\\\space\ifdefempty{\ncu@shorttitle}{\ncu@rawtitle}{\ncu@shorttitle}}}
% The rule under the header, in ncurule instead of black.
\renewcommand{\headrule}{{\color{ncurule}%
  \hrule\@height\headrulewidth\@width\headwidth\vskip-\headrulewidth}}
\fancypagestyle{ncu}{%
  \fancyhf{}%
  \fancyhead[L]{\ncu@headfont\ncu@runningtitle}%
  \fancyfoot[C]{\ncu@headfont\thepage}%
  \renewcommand{\headrulewidth}{0.4pt}%
  \renewcommand{\footrulewidth}{0pt}}
\fancypagestyle{plain}{%
  \fancyhf{}%
  \fancyfoot[C]{\ncu@headfont\thepage}%
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}}
\pagestyle{ncu}

% Titlebox %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\mymaketitle}{%
  \tcbset{enhanced,frame hidden}
  \tcbset{left=0.5cm}
  \tcbset{right=0.5cm}
  \tcbset{top=0.5cm}
  \tcbset{bottom=0.5cm}
  \tcbset{arc=10pt}
  \tcbset{colback=ncubg}
  \tcbset{before skip=0pt}
  \tcbset{grow to left by=1.5pt}
  \tcbset{grow to right by=1.5pt}
  \tcbset{
    overlay={\node[
        anchor=south east,
        at= (frame.south east),
        xshift=-0.30cm,
        yshift=-0.12cm] {\includegraphics[width=2.2cm]{assets/logo_ncu.pdf}};}
  }
  
  \begin{tcolorbox}
    \setlength{\parindent}{0cm}
    \setlength{\parskip}{0.5cm}
    {
      \setlength{\parskip}{0cm}
      \raggedright
      \nohyphens
      %
      % ncu: the \par that ends the title used to come after the \huge group
      % had closed, so a two-line title was set with the leading of the normal
      % text size, and \setstretch{1.618} widened that. \titlelist now ends
      % with its own \par, so the title gets the \huge leading (about 1.3
      % times the IBM Plex Sans size) and the stretch is gone.
      {
        \titlelist\par
      }
      \vskip 0.2cm
      %
      \authorlist\par
      \vskip 0.2cm
      %
      \affiliationlist\par
      %
      \contributionlist\par
    }
    %
    % ncu: the "ABSTRACT" label is switched off. The abstract paragraph gets the 0.5cm \parskip of the title box again, as in the old version.
    \ifdefempty{\abstractlist}{}{%
      % {\ncuheadbf\footnotesize\color{ncumuted}%
      %   \textls[160]{\MakeUppercase{\abstractname}}\par}%
      \abstractlist\par
    }
    %
    \vskip 0.5cm
    %
    {
      \setlength{\parskip}{0cm}
      \ifdefempty{\ncudatalist}{\vspace*{0.65cm}}{\ncudatalist\par}
    }
  \end{tcolorbox}
  \tcbset{reset}
  \FloatBarrier
}

% ncu: \thispagestyle{plain} keeps the running header off the first page.
\if@twocolumn%
\renewcommand{\maketitle}{
\twocolumn[%
  \thispagestyle{plain}%
  \mymaketitle
  \vskip 0.38cm
]
}%
\else%
\renewcommand{\maketitle}{
  \thispagestyle{plain}%
  \mymaketitle
}%
\fi