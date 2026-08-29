#!/usr/bin/env bash
#-----------------------------------------------------------------------------
# process_covers.sh
#
# Sorts a folder of "make matrix" thesis PDFs into cover pages, ready for the
# Showcase. Run it FROM INSIDE the folder that holds the built PDFs, e.g.:
#
#   cd AUXDIR/matrix/2026-08-08@14-06-06
#   /path/to/Scripts/process_covers.sh [pdf] [svg] [png] [-b|--border] [--width N|--height N]
#
# With no phase name, all three phases run (pdf, then svg, then png). Pass
# one or more phase names, in any order, to run only those parts:
#   pdf   Phase 1 only: extract + classify pages into Covers/PDF and
#         Covers/TO_DELETE (also (re)writes the review manifest/contact
#         sheet).
#   svg   Phase 2 only: convert whatever is currently in Covers/PDF into
#         Covers/SVG (optimized). Useful to re-run after hand-correcting
#         files in Covers/PDF without redoing the classification.
#   png   Phase 3 only: render whatever is currently in Covers/PDF into
#         Covers/PNG at a decent screen resolution (see --width/--height
#         below).
#   -b, --border      also stamp a visible border on each generated SVG's
#         root element. Off by default.
#   --width <px>      target PNG width, in pixels; height follows the
#         page's own aspect ratio. Mutually exclusive with --height.
#         Default: 1200.
#   --height <px>     target PNG height, in pixels; width follows the
#         page's own aspect ratio. Mutually exclusive with --width.
#
# For every <file>.pdf found in the current directory, it extracts:
#   <file>-1.pdf   physical page 1                         -> always kept
#   <file>-2.pdf   physical page 2, IF it looks like a front page -> kept;
#                  if it's a plain text/chapter page (running header + rule,
#                  or blank) -> Covers/TO_DELETE instead
#   <file>-S.pdf   the book spine (short, wide last page)   -> always kept,
#                  when present
#   <file>-N.pdf   the last physical page (before the spine, if any), IF it
#                  looks like a back cover -> kept; if it's a plain text page
#                  or blank -> Covers/TO_DELETE instead
#   <file>-L1.pdf  the "logical page 1": the first physical page whose PDF
#                  page label is the arabic numeral "1" -- i.e. where
#                  hyperref's page-label ranges show mainmatter numbering
#                  restarting at 1 (see detect_logical_page1()) -> always
#                  kept, when it can be determined
#   ("-S", "-N" and "-L1" are always literal suffixes, never the real page
#   number.)
#
# Kept pages land in Covers/PDF. Every decision (kept or not) is logged to
# Covers/_review/manifest.csv, and Covers/_review/index.html renders a
# thumbnail contact sheet so borderline calls can be eyeballed and, if
# needed, fixed by hand (move the PDF between Covers/PDF and
# Covers/TO_DELETE yourself -- this script does not re-read the manifest).
#
# Only once every file has been classified does the script make its later
# passes: every PDF that ended up in Covers/PDF gets converted to Covers/SVG
# (optimized with svgo, if installed) and/or rendered to Covers/PNG. Nothing
# in Covers/TO_DELETE is ever converted.
#
# Page 2 / page N classification ("has_cover_content"): a plain body/chapter
# page in this template has, at most, a running header followed by a thin
# rule near the top -- nothing else. A genuine cover (front or back) always
# has a sizeable block of ink somewhere in its top or bottom 30%: a logo, a
# crest, a decorative graphic, or -- for schools whose front page is pure
# typography -- the title/author/committee text block itself. So instead of
# hunting for "is there a logo" (which false-negatives on text-only front
# pages) or measuring total ink (which false-positives on dense body text
# and can't tell a bare rule from "nothing"), we render the page, collapse
# its top 30% and bottom 30% to a 1-pixel-wide column each (one value per
# row = that row's average darkness across the FULL page width -- isolated
# words/glyphs get diluted by whitespace and stay light, while a wide logo,
# graphic or block of title text stays dark), and take the longest run of
# consecutive dark rows in either band:
#   short run (<16 rows, ~1cm)  -> nothing but a thin rule, or nothing at
#                                   all -> DELETE (plain/blank page)
#   long run (>=16 rows)        -> a real block of content -> KEEP (cover)
# 16 was picked empirically: plain header+rule pages measured 11-13, every
# real cover we sampled (logos, crests, decorative graphics, pure-text title
# pages) measured 20+. A page that embeds an actual raster image is always
# kept without running this test (pdfimages already tells us that cheaply
# and unambiguously). The same KEEP/DELETE call is cached per school+degree
# prefix (e.g. "nova-fct-di-adc") so the -en/-pt and -lua/-pdf variants of
# the same school don't re-render/re-analyze the same artwork twice.
#
# Requires (Homebrew): poppler (pdfinfo/pdftocairo/pdftoppm/pdfimages), bc.
# Optional: imagemagick (magick or convert) for the cover-content test --
# without it, page 2/N are always kept (safe default: nothing gets deleted
# without evidence). Optional: svgo for SVG optimization. Optional: qpdf and
# jq, to read the PDF's embedded page labels for logical-page-1 detection --
# without them, -L1 extraction is skipped.
#-----------------------------------------------------------------------------
set -uo pipefail

usage() {
  echo "Usage: $(basename "$0") [pdf] [svg] [png] [-b|--border] [--width <px>|--height <px>]" >&2
  echo "  pdf              extract + classify cover pages into Covers/PDF and Covers/TO_DELETE" >&2
  echo "  svg              convert whatever is currently in Covers/PDF to Covers/SVG (optimized)" >&2
  echo "  png              render whatever is currently in Covers/PDF to Covers/PNG" >&2
  echo "  -b, --border     also stamp a visible border on each generated SVG's root element (default: off)" >&2
  echo "  --width <px>     target PNG width in pixels; height follows the page's aspect ratio (default: 1200)" >&2
  echo "  --height <px>    target PNG height in pixels; width follows the page's aspect ratio" >&2
  echo "                   (mutually exclusive with --width)" >&2
  echo "  no phase name, or all three: run every phase, in order" >&2
  exit 1
}

# Which phase(s) to run. No phase name -> all three (unchanged default spirit).
RUN_PDF=0
RUN_SVG=0
RUN_PNG=0
BORDER=0
PHASES_GIVEN=0
PNG_WIDTH=""
PNG_HEIGHT=""
while [ $# -gt 0 ]; do
  case "$1" in
    pdf) RUN_PDF=1; PHASES_GIVEN=1 ;;
    svg) RUN_SVG=1; PHASES_GIVEN=1 ;;
    png) RUN_PNG=1; PHASES_GIVEN=1 ;;
    -b|--border) BORDER=1 ;;
    --width)
      [ -n "$PNG_HEIGHT" ] && { echo "Error: --width and --height are mutually exclusive" >&2; usage; }
      shift
      PNG_WIDTH="${1:-}"
      [[ "$PNG_WIDTH" =~ ^[0-9]+$ ]] || { echo "Error: --width requires a positive integer (pixels)" >&2; usage; }
      ;;
    --height)
      [ -n "$PNG_WIDTH" ] && { echo "Error: --width and --height are mutually exclusive" >&2; usage; }
      shift
      PNG_HEIGHT="${1:-}"
      [[ "$PNG_HEIGHT" =~ ^[0-9]+$ ]] || { echo "Error: --height requires a positive integer (pixels)" >&2; usage; }
      ;;
    -h|--help) usage ;;
    *) echo "Error: unknown argument '$1'" >&2; usage ;;
  esac
  shift
done
if [ "$PHASES_GIVEN" -eq 0 ]; then
  RUN_PDF=1; RUN_SVG=1; RUN_PNG=1
fi
# Default PNG target: 1200px wide (≈1200x1697 for an A4-ish portrait page) --
# sharp enough for on-screen/showcase use, without ballooning file size the
# way a print-resolution (300ppi) render would.
if [ -z "$PNG_WIDTH" ] && [ -z "$PNG_HEIGHT" ]; then
  PNG_WIDTH=1200
fi

# Colors for the KEEP/DELETE decision lines. Disabled when stdout isn't a
# terminal (e.g. piped to a log file) or NO_COLOR is set.
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  C_GREEN=$'\033[32m'; C_RED=$'\033[31m'; C_RESET=$'\033[0m'
else
  C_GREEN=""; C_RED=""; C_RESET=""
fi

# Ensure required dependencies are available (only for the phase(s) requested)
REQUIRED_CMDS=(pdftocairo)
[ "$RUN_PDF" -eq 1 ] && REQUIRED_CMDS+=(pdfinfo pdftoppm pdfimages bc)
[ "$RUN_PNG" -eq 1 ] && REQUIRED_CMDS+=(pdfinfo bc)
[ "$BORDER" -eq 1 ] && REQUIRED_CMDS+=(perl)
for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" &> /dev/null; then
    echo "Error: Required command '$cmd' is not installed." >&2
    exit 1
  fi
done
HAVE_MAGICK=0
command -v magick &> /dev/null && HAVE_MAGICK=1
command -v convert &> /dev/null && HAVE_MAGICK=1
[ "$RUN_PDF" -eq 1 ] && [ "$HAVE_MAGICK" -eq 0 ] && echo "Note: imagemagick not found; page 2/N will always be kept (brew install imagemagick to enable the cover-content filter)." >&2
HAVE_SVGO=0
command -v svgo &> /dev/null && HAVE_SVGO=1
[ "$RUN_SVG" -eq 1 ] && [ "$HAVE_SVGO" -eq 0 ] && echo "Note: svgo not found; SVGs will be written unoptimized (brew install svgo, or: npm install -g svgo)." >&2
HAVE_QPDF=0
command -v qpdf &> /dev/null && HAVE_QPDF=1
HAVE_JQ=0
command -v jq &> /dev/null && HAVE_JQ=1
if [ "$RUN_PDF" -eq 1 ] && { [ "$HAVE_QPDF" -eq 0 ] || [ "$HAVE_JQ" -eq 0 ]; }; then
  echo "Note: qpdf and/or jq not found; the logical-page-1 (-L1, arabic '1') page will not be extracted (brew install qpdf jq to enable it)." >&2
fi

# Target directories
PDF_DIR="Covers/PDF"
DEL_DIR="Covers/TO_DELETE"
SVG_DIR="Covers/SVG"
PNG_DIR="Covers/PNG"
REVIEW_DIR="Covers/_review"
THUMB_DIR="$REVIEW_DIR/thumbs"
mkdir -p "$PDF_DIR" "$DEL_DIR" "$SVG_DIR" "$PNG_DIR" "$THUMB_DIR"

MANIFEST="$REVIEW_DIR/manifest.csv"
HTML="$REVIEW_DIR/index.html"
if [ "$RUN_PDF" -eq 1 ]; then
  echo "file,role,physical_page,total_pages,decision,metric,notes" > "$MANIFEST"
  cat > "$HTML" <<'HTMLHEAD'
<!DOCTYPE html><html><head><meta charset="utf-8"><title>Covers review</title>
<style>
body{font-family:-apple-system,sans-serif;background:#111;color:#eee;margin:0;padding:16px}
h1{font-size:18px}
.grid{display:flex;flex-wrap:wrap;gap:10px}
.card{background:#1c1c1c;border-radius:6px;padding:8px;width:150px;text-align:center}
.card img{width:100%;border:1px solid #444;background:#fff}
.kept{border:2px solid #3fb950}
.deleted{border:2px solid #f85149;opacity:.6}
.role{font-weight:bold}
.meta{font-size:11px;color:#aaa;word-break:break-all}
</style></head><body>
<h1>Covers review &mdash; kept pages are green, deleted are red/dim</h1>
<div class="grid">
HTMLHEAD
fi

declare -A DECISION_CACHE
LAST_METRIC=0   # set by has_cover_content(), since bash functions can't return strings

# Extract cache key prefix: everything up to -{phd,msc,bsc}-
get_template_prefix() {
  local filename="$1"
  if [[ "$filename" =~ ^uminho- ]]; then
    echo "uminho"; return
  fi
  if [[ "$filename" =~ ^(.*)-(phd|msc|bsc)- ]]; then
    echo "${BASH_REMATCH[1]}"
  else
    echo "$filename" | cut -d'-' -f1
  fi
}

# is_wide_page <pdf>  -> true (0) if width > height (landscape / spine-shaped)
is_wide_page() {
  local pdf_file="$1" size w h
  size=$(pdfinfo "$pdf_file" 2>/dev/null | grep "^Page size:")
  w=$(echo "$size" | awk '{print $3}')
  h=$(echo "$size" | awk '{print $5}')
  [ -z "$w" ] || [ -z "$h" ] && return 1
  [ "$(echo "$w > $h" | bc -l)" -eq 1 ]
}

# detect_logical_page1 <pdf> -> prints the 1-based physical page number whose
# PDF page label is the arabic numeral "1", or nothing if it can't be
# determined. Reads the PDF's embedded page-label ranges (qpdf --json) --
# the same data hyperref writes whenever \pagenumbering is called -- and
# looks for a Decimal-style (/S /D) range starting at (/St) 1.
#
# NOVAthesis documents typically carry THREE such ranges: an incidental one
# at physical page 1 (arabic numbering is active by default before
# \frontmatter switches to roman), then a Roman range for the front matter,
# then the real one where mainmatter numbering restarts at arabic 1. We
# want that last one, so we take the LAST matching range, not the first --
# verified against real novathesis output where the first match is the
# cover page itself and the last is the actual chapter-1 opening page.
detect_logical_page1() {
  local pdf_file="$1" idx
  { [ "$HAVE_QPDF" -eq 1 ] && [ "$HAVE_JQ" -eq 1 ]; } || return 1
  idx=$(qpdf --json=latest "$pdf_file" 2>/dev/null | jq -r '
      [.pagelabels[]? | select(.label."/S" == "/D") | select((.label."/St" // 1) == 1)]
      | sort_by(.index) | .[-1].index // empty
    ' 2>/dev/null)
  [[ "$idx" =~ ^[0-9]+$ ]] || return 1
  echo $((idx + 1))
}

# render_png <pdf> <out_png> <width_px> <height_px>  (exactly one of
# width/height is non-empty)
# pdftocairo's -scale-to-x/-scale-to-y each constrain only ONE axis and
# leave the other at the default 150ppi -- fine for A4-ish pages by
# coincidence, but it visibly distorts non-A4 pages (e.g. a wide
# front+spine+back spread). So instead we read the page's own size (in
# points, via pdfinfo) and derive a single uniform -r that hits the
# requested pixel target on the requested axis, which preserves the page's
# native aspect ratio on the other axis exactly.
render_png() {
  local pdf_file="$1" out_png="$2" want_w="$3" want_h="$4"
  local size w h dpi
  size=$(pdfinfo "$pdf_file" 2>/dev/null | grep "^Page size:")
  w=$(echo "$size" | awk '{print $3}')
  h=$(echo "$size" | awk '{print $5}')
  if [ -z "$w" ] || [ -z "$h" ]; then
    echo "    (could not read page size for $pdf_file; skipping PNG)" >&2
    return 1
  fi
  if [ -n "$want_w" ]; then
    dpi=$(echo "$want_w * 72 / $w" | bc -l)
  else
    dpi=$(echo "$want_h * 72 / $h" | bc -l)
  fi
  pdftocairo -png -r "$dpi" -singlefile "$pdf_file" "${out_png%.png}" 2>/dev/null
}

# _maxrun <img> <gravity>  -> longest run of consecutive non-white rows in
# the top or bottom 30% of <img> (gravity North/South), used by
# has_cover_content(). Collapses that band to a 1px-wide column first (one
# value per row = average darkness across the full page width).
_maxrun() {
  local img="$1" gravity="$2" img_cmd="magick"
  command -v magick &> /dev/null || img_cmd="convert"
  "$img_cmd" "$img" -gravity "$gravity" -crop 100%x30%+0+0 +repage \
    -colorspace Gray -resize 1x! -depth 8 txt:- 2>/dev/null \
  | grep -oE 'gray\([0-9]+\)' | grep -oE '[0-9]+' \
  | awk '{ if ($1<230){run++; if(run>max) max=run} else run=0 } END{print max+0}'
}

# has_cover_content <pdf> -> true (0) if the page has a sizeable block of
# ink (logo/crest/graphic, or a title page's own text) in its top or bottom
# 30%, rather than just a thin rule (or nothing). See header comment.
has_cover_content() {
  local pdf_file="$1"
  LAST_METRIC="maxrun:n/a"
  [ "$HAVE_MAGICK" -eq 0 ] && return 0   # can't test -> default to KEEP (safe)

  local tmp_prefix="/tmp/band_thumb_$$"
  pdftoppm -png -r 150 -f 1 -l 1 "$pdf_file" "$tmp_prefix" 2>/dev/null
  local rendered_img
  rendered_img=$(ls "${tmp_prefix}"*.png 2>/dev/null | head -n 1)
  [ -z "$rendered_img" ] && { LAST_METRIC="maxrun:no-render"; return 0; }

  local top_run bottom_run
  top_run=$(_maxrun "$rendered_img" North)
  bottom_run=$(_maxrun "$rendered_img" South)
  rm -f "${tmp_prefix}"*
  top_run=${top_run:-0}; bottom_run=${bottom_run:-0}
  LAST_METRIC="maxrun:${top_run}/${bottom_run}"

  [ "$top_run" -ge 16 ] || [ "$bottom_run" -ge 16 ]
}

# make_thumb <pdf> <png>  (best-effort; contact sheet just skips it on failure)
make_thumb() {
  local pdf_file="$1" out_png="$2" tmp="${2%.png}"
  pdftoppm -png -r 70 -f 1 -l 1 "$pdf_file" "$tmp" 2>/dev/null
  local produced
  produced=$(ls "${tmp}"*.png 2>/dev/null | head -n 1)
  [ -n "$produced" ] && mv -f "$produced" "$out_png"
}

# log_row <file> <role> <phys_page> <total> <decision> <metric> <notes>
log_row() {
  echo "$1,$2,$3,$4,$5,$6,$7" >> "$MANIFEST"
  local css="deleted"; [ "$5" = "KEEP" ] && css="kept"
  {
    echo "<div class=\"card $css\">"
    echo "  <img src=\"thumbs/$1-$2.png\" onerror=\"this.style.display='none'\">"
    echo "  <div class=\"role\">$1-$2</div>"
    echo "  <div class=\"meta\">page $3/$4 &middot; $5 &middot; $6</div>"
    echo "</div>"
  } >> "$HTML"
}

# classify_and_place <src_pdf> <base> <role> <prefix> <page_type> <phys_page>
#                     <total_pages> <always_keep: true|false>
# Extracts one page from src_pdf, decides KEEP/DELETE (unless always_keep),
# moves the result into Covers/PDF or Covers/TO_DELETE, logs it, and drops a
# thumbnail into Covers/_review/thumbs for the contact sheet.
classify_and_place() {
  local src="$1" base="$2" role="$3" prefix="$4" page_type="$5" phys="$6" total="$7" always="$8"
  local staged decision="KEEP" metric="-" notes="-"

  staged="$(mktemp -t cover_XXXXXX).pdf"
  pdftocairo -pdf -f "$phys" -l "$phys" "$src" "$staged" 2>/dev/null

  if [ "$always" != "true" ]; then
    local cache_key="${prefix}_${page_type}"
    if [ -n "${DECISION_CACHE[$cache_key]:-}" ]; then
      decision="${DECISION_CACHE[$cache_key]}"
      notes="cache"
    else
      local raster_count
      raster_count=$(pdfimages -list "$staged" 2>/dev/null | tail -n +3 | wc -l | tr -d ' ')
      if [ "${raster_count:-0}" -gt 0 ]; then
        decision="KEEP"; metric="raster:$raster_count"; notes="rule-set"
      elif has_cover_content "$staged"; then
        decision="KEEP"; metric="$LAST_METRIC"; notes="rule-set"
      else
        decision="DELETE"; metric="$LAST_METRIC"; notes="rule-set"
      fi
      DECISION_CACHE["$cache_key"]="$decision"
    fi
  else
    notes="always-kept"
  fi

  local dest="$PDF_DIR/${base}-${role}.pdf"
  [ "$decision" = "DELETE" ] && dest="$DEL_DIR/${base}-${role}.pdf"
  mv -f "$staged" "$dest"
  make_thumb "$dest" "$THUMB_DIR/${base}-${role}.png"
  log_row "$base" "$role" "$phys" "$total" "$decision" "$metric" "$notes"

  local color="$C_RED" label="[$decision]"
  if [ "$decision" = "KEEP" ]; then color="$C_GREEN"; label="${label}  "; fi  # 2 extra spaces to align with "[DELETE]"
  echo "  ${color}${label}${C_RESET} ${base}-${role}.pdf  ($notes${metric:+, $metric})"
}

if [ "$RUN_PDF" -eq 1 ]; then
  echo "=== Phase 1: classifying pages ==="

  shopt -s nullglob
  pdf_files=(*.pdf)
  if [ ${#pdf_files[@]} -eq 0 ]; then
    echo "No PDF files found in current directory."
  fi

  for pdf in "${pdf_files[@]}"; do
    base="${pdf%.pdf}"
    prefix=$(get_template_prefix "$pdf")
    total_pages=$(pdfinfo "$pdf" 2>/dev/null | awk '/^Pages:/ {print $2}')
    if [ -z "$total_pages" ] || [ "$total_pages" -le 0 ]; then
      echo "Skipping $pdf (could not determine page count)"
      continue
    fi

    echo "------------------------------------------------"
    echo "File: $pdf ($total_pages pages) [Prefix: ${prefix}]"

    # Page 1: always the cover
    classify_and_place "$pdf" "$base" "1" "$prefix" "p1" 1 "$total_pages" "true"

    # Page 2: front page (keep) vs. plain text/blank page (delete)
    if [ "$total_pages" -ge 2 ]; then
      tmp2="$(mktemp -t p2_XXXXXX).pdf"
      pdftocairo -pdf -f 2 -l 2 "$pdf" "$tmp2" 2>/dev/null
      always2="false"
      is_wide_page "$tmp2" && always2="true"   # oddly-shaped page 2: keep rather than guess
      rm -f "$tmp2"
      classify_and_place "$pdf" "$base" "2" "$prefix" "p2" 2 "$total_pages" "$always2"
    fi

    # Last physical page: spine (always keep) and/or back cover vs. text/blank (filtered)
    if [ "$total_pages" -gt 2 ]; then
      tmpLast="$(mktemp -t plast_XXXXXX).pdf"
      pdftocairo -pdf -f "$total_pages" -l "$total_pages" "$pdf" "$tmpLast" 2>/dev/null

      if is_wide_page "$tmpLast"; then
        rm -f "$tmpLast"
        # Spine: always kept, as its own file
        classify_and_place "$pdf" "$base" "S" "$prefix" "pSpine" "$total_pages" "$total_pages" "true"
        # The real "last content page" is the one before the spine
        content_last=$((total_pages - 1))
        if [ "$content_last" -gt 2 ]; then
          classify_and_place "$pdf" "$base" "N" "$prefix" "pN" "$content_last" "$total_pages" "false"
        fi
      else
        rm -f "$tmpLast"
        classify_and_place "$pdf" "$base" "N" "$prefix" "pN" "$total_pages" "$total_pages" "false"
      fi
    fi

    # Logical page 1: the first physical page whose PDF page label is the
    # arabic numeral "1" (mainmatter's opening page), always kept when it
    # can be determined -- see detect_logical_page1().
    logical1=$(detect_logical_page1 "$pdf")
    if [ -n "$logical1" ] && [ "$logical1" -ge 1 ] && [ "$logical1" -le "$total_pages" ]; then
      classify_and_place "$pdf" "$base" "L1" "$prefix" "pL1" "$logical1" "$total_pages" "true"
    else
      echo "  (logical page 1 not found -- no matching PDF page label, or qpdf/jq unavailable)"
    fi
  done

  echo "</div></body></html>" >> "$HTML"
  echo "Manifest: $MANIFEST"
  echo "Review:   $REVIEW_DIR/index.html"
fi

if [ "$RUN_SVG" -eq 1 ]; then
  echo "=== Phase 2: converting Covers/PDF to SVG ==="
  shopt -s nullglob
  kept=("$PDF_DIR"/*.pdf)
  if [ ${#kept[@]} -eq 0 ]; then
    echo "Nothing kept in $PDF_DIR; skipping SVG generation."
  else
    for pdf in "${kept[@]}"; do
      base="$(basename "${pdf%.pdf}")"
      svg="$SVG_DIR/${base}.svg"
      echo "  -> ${base}.pdf -> ${base}.svg"
      pdftocairo -svg "$pdf" "$svg" 2>/dev/null
      if [ "$HAVE_SVGO" -eq 1 ]; then
        svgo "$svg" --quiet
      fi
      if [ "$BORDER" -eq 1 ]; then
        # Stamp a visible border on the root <svg> element (added last,
        # after svgo, so optimization can't strip or reformat it away).
        perl -0777 -i -pe 's/<svg /<svg style="border: 4px solid #888888; box-sizing: border-box;" /' "$svg"
      fi
    done
  fi
fi

if [ "$RUN_PNG" -eq 1 ]; then
  target="width ${PNG_WIDTH}px"; [ -n "$PNG_HEIGHT" ] && target="height ${PNG_HEIGHT}px"
  echo "=== Phase 3: rendering Covers/PDF to PNG (target $target) ==="
  shopt -s nullglob
  kept=("$PDF_DIR"/*.pdf)
  if [ ${#kept[@]} -eq 0 ]; then
    echo "Nothing kept in $PDF_DIR; skipping PNG generation."
  else
    for pdf in "${kept[@]}"; do
      base="$(basename "${pdf%.pdf}")"
      png="$PNG_DIR/${base}.png"
      echo "  -> ${base}.pdf -> ${base}.png"
      render_png "$pdf" "$png" "$PNG_WIDTH" "$PNG_HEIGHT"
    done
  fi
fi

echo "=== Complete ==="
