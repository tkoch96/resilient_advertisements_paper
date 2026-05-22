# Build the paper from plain LaTeX sources.
#
# Sources:
#   resilience.tex  -- main paper (hand-edited LaTeX)
#   packages.tex    -- \usepackage block, included via \input{packages}
#   macros.tex      -- macros, included via \input{macros}
#   mybib.bib       -- bibliography
#   figures/        -- figure assets
#
# Requirements:
#   pdflatex, bibtex (e.g. MiKTeX or TeX Live)
#
# Usage:
#   make           # build resilience.pdf
#   make clean     # remove LaTeX build artifacts (keeps sources and final PDF)
#   make distclean # clean + also remove resilience.pdf

NAME=resilience
TARGET=$(NAME).pdf

LATEX=pdflatex
LATEX_FLAGS=-interaction=nonstopmode -halt-on-error
BIBTEX=bibtex

# LaTeX intermediate files to remove on `make clean`.
AUX_EXTS=aux bbl blg log out toc lot lof nav snm vrb fls fdb_latexmk run.xml synctex.gz

.PHONY: all clean distclean

all: $(TARGET)

# Iterate pdflatex + bibtex until cross-references stabilize.
$(TARGET): $(NAME).tex packages.tex macros.tex mybib.bib
	$(LATEX) $(LATEX_FLAGS) $(NAME)
	$(BIBTEX) $(NAME)
	$(LATEX) $(LATEX_FLAGS) $(NAME)
	$(LATEX) $(LATEX_FLAGS) $(NAME)

clean:
	rm -f $(foreach ext,$(AUX_EXTS),$(NAME).$(ext))
	rm -f $(NAME)-blx.bib authors.aux

distclean: clean
	rm -f $(TARGET)
