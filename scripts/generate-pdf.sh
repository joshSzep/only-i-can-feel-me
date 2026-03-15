#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(cd -- "$script_dir/.." && pwd)
manuscript_builder="$script_dir/create-manuscript.sh"
manuscript_md="$repo_root/MANUSCRIPT.md"
manuscript_pdf="$repo_root/MANUSCRIPT.pdf"
cover_image="$repo_root/cover.png"
tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/only-i-can-feel-me-pdf.XXXXXX")
body_file="$tmp_dir/manuscript-body.md"
before_body_tex="$tmp_dir/before-body.tex"
header_tex="$tmp_dir/header.tex"

cleanup() {
  rm -rf "$tmp_dir"
}

trap cleanup EXIT

require_command() {
  local command_name=$1

  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$command_name" >&2
    exit 1
  fi
}

require_file() {
  local file_path=$1

  if [[ ! -f "$file_path" ]]; then
    printf 'Required file not found: %s\n' "$file_path" >&2
    exit 1
  fi
}

require_command pandoc
require_command pdflatex
require_file "$cover_image"
require_file "$manuscript_builder"

bash "$manuscript_builder"

require_file "$manuscript_md"

title_line=$(sed -n '1p' "$manuscript_md")
subtitle_line=$(sed -n '3p' "$manuscript_md")

if [[ "$title_line" != '# Only I Can Feel Me' ]]; then
  printf 'Unexpected manuscript title line: %s\n' "$title_line" >&2
  exit 1
fi

if [[ "$subtitle_line" != 'A Novel - Joshua Szepietowski' ]]; then
  printf 'Unexpected manuscript subtitle line: %s\n' "$subtitle_line" >&2
  exit 1
fi

tail -n +5 "$manuscript_md" > "$body_file"

cat > "$before_body_tex" <<EOF
\\frontmatter

\\newgeometry{margin=0in}
\\thispagestyle{empty}
\\begin{titlepage}
  \\centering
  \\includegraphics[width=\\paperwidth,height=\\paperheight]{${cover_image}}
\\end{titlepage}
\\restoregeometry

\\clearpage
\\thispagestyle{empty}
\\vspace*{\\fill}
\\begin{center}
  {\\fontsize{28}{32}\\selectfont\\bfseries Only I Can Feel Me\\par}
  \\vspace{1.5em}
  {\\Large A Novel\\par}
  \\vspace{0.9em}
  {\\large Joshua Szepietowski\\par}
\\end{center}
\\vspace*{\\fill}

\\clearpage
\\mainmatter
EOF

cat > "$header_tex" <<'EOF'
\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
\usepackage[sc]{mathpazo}
\usepackage{graphicx}
\usepackage{xcolor}
\usepackage{titlesec}
\usepackage{fancyhdr}
\usepackage{setspace}
\usepackage{emptypage}

\definecolor{ManuscriptInk}{HTML}{1F1B18}
\definecolor{ManuscriptAccent}{HTML}{8B6B4F}

\AtBeginDocument{\color{ManuscriptInk}}

\setlength{\parindent}{1.25em}
\setlength{\parskip}{0pt}
\setlength{\headheight}{14pt}
\linespread{1.06}
\raggedbottom

\pagestyle{fancy}
\fancyhf{}
\fancyfoot[C]{\thepage}
\renewcommand{\headrulewidth}{0pt}

\fancypagestyle{plain}{
  \fancyhf{}
  \fancyfoot[C]{\thepage}
  \renewcommand{\headrulewidth}{0pt}
}

\titleformat{\part}[display]
  {\thispagestyle{empty}\centering\normalfont}
  {}
  {0pt}
  {\vspace*{\fill}\Huge\bfseries\scshape\color{ManuscriptInk}}
  [\vspace{1.25em}{\color{ManuscriptAccent}\rule{0.24\textwidth}{0.8pt}}\vspace*{\fill}]

\titlespacing*{\part}{0pt}{0pt}{0pt}

\titleformat{\chapter}[display]
  {\thispagestyle{plain}\centering\normalfont}
  {}
  {0pt}
  {\vspace*{1.5em}\Large\bfseries\color{ManuscriptInk}}
  [\vspace{0.75em}{\color{ManuscriptAccent}\rule{0.34\textwidth}{0.6pt}}]

\titlespacing*{\chapter}{0pt}{0pt}{2em}

\titleformat{\section}
  {\large\bfseries\color{ManuscriptInk}}
  {}
  {0pt}
  {}
EOF

pandoc "$body_file" \
  --standalone \
  --from=markdown+smart+raw_tex \
  --pdf-engine=pdflatex \
  --output "$manuscript_pdf" \
  --resource-path "$repo_root" \
  --include-in-header "$header_tex" \
  --include-before-body "$before_body_tex" \
  --shift-heading-level-by=-1 \
  --top-level-division=part \
  --variable documentclass=book \
  --variable classoption=oneside \
  --variable classoption=openany \
  --variable fontsize=11pt \
  --variable geometry:paperwidth=6in \
  --variable geometry:paperheight=9in \
  --variable geometry:top=0.8in \
  --variable geometry:bottom=0.85in \
  --variable geometry:left=0.8in \
  --variable geometry:right=0.8in

printf 'Wrote %s\n' "$manuscript_pdf"