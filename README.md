[![Deploy CV](https://github.com/klaeufer/cv/actions/workflows/main.yml/badge.svg)](https://github.com/klaeufer/cv/actions/workflows/main.yml)

## Curriculum Vitae

This is my CV in LaTeX based on the [moderncv](https://ctan.org/pkg/moderncv) class following [gkthiruvathukal's example](https://github.com/gkthiruvathukal/cv).

You can view/download the latest version [here](https://github.com/klaeufer/cv/releases/latest/download/klaeufer.pdf).

## Document structure

All personal CV content is in LaTeX sources in the `./data` subdirectory, from which the main LaTeX source gets generated automatically:

- Files named `0[0-9]-*.tex` become part of the document *preamble*.
- Files named `[1-9][0-9]-*.tex` constitute the document *body*.
- The files `99-github-contributions.tex` and `99-scholarly-bibliometrics.tex` are generated automatically and can be included in a section of the document body.
- `data/personal-settings.sh` contains these settings:

  - `FULLNAME` for the Google Scholar data
  - `GITHUB_USER` for the activity stats
  - `DOMAIN`, optional local directory, parallel to this repo, containing the user's static website source; the collated bib gets copied to `../${DOMAIN}/_bibliography/papers.bib`


## Bibliography management

We use [Zotero](https://www.zotero.org/) as the single source of truth (SSoT) for our bibliographic data.

In addition, we use the [Better BibTeX](https://retorque.re/zotero-better-bibtex/) (BBT) plugin for Zotero to retain custom BibTeX fields required for additional functionality, such as

- annotation of authors, e.g., students or self, using `author+an`
- tags used by jekyll-scholar, e.g., `bibtex_show`, `abbr`, and `selected`

Each category of bibliographic references should be a separate Zotero collection, e.g.,

- laufer-inproceedings
- laufer-techreport
- ...

This makes it easy to use `\nocite` to pull in all references in the desired category, e.g.,

```LaTeX
\begin{refsection}[bibliography/laufer-inproceedings.bib]
\nocite{*}
\printbibliography[heading=subbibintoc,title={Refereed Conference Papers},sorting=ynt]
\end{refsection}
```

Before the in

- We fetch the bibliography data from the Zotero group URLs in `zotero-bibs.txt`.
