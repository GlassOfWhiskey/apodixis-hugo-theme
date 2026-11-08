# AGENTS.md

Guidance for AI agents and developers working on the **apodixis** Hugo theme.

## Project overview

A reusable Hugo theme that provides the shared shell of research-project
websites: navigation (with submenus), manual + OS-aware dark/light mode, a
home-page hero, publications and people pages, JSON-LD structured data, and a
`.bib → YAML` publication pipeline. Each consuming site keeps its **own**
`publications.bib`, `data/*.yaml` files, and `static/images`.

## Architecture & key files

- `layouts/_default/baseof.html` — global shell: theme-toggle checkbox, header
  (`partials/header.html`), **hero** on home pages, `main` block, footer.
  Sources `site.Params` directly (hero, `hero_actions`, `github`).
- `layouts/_default/{list,single}.html` — generic list/single fallbacks.
- `layouts/publications/list.html`, `layouts/people/list.html` — section lists
  driven by `data/publications.yaml` and `data/people.yaml` respectively.
- `layouts/use-cases/{list,single}.html` — section templates for a `use-cases`
  section: when `site.Params.use_cases.pagination.enabled` (default true) the
  list renders a paginated card grid of the section's child pages (from
  `.Paginate .Pages` with `site.Params.use_cases.pagination.size` per page,
  default 6; prev/page-numbers/next via `partials/pagination.html`); when
  disabled it renders every child on one page. Each card shows an optional
  `category` badge, the title, and a summary (front-matter `summary` if
  provided, else Hugo's automatic `.Summary`), linking to its individual page;
  the single renders a `.Resize` "featured" image (at its natural contained
  aspect ratio, centered) of the first image plus the page content and a "back
  to all" link to `.Parent`.
  **Images resolve from front-matter `image` (via `resources.Get`) when present,
  else fall back to the first page-bundle image in the page's folder.** Both
  render responsive images via `partials/srcset.html` (card =
  a `.Resize` thumbnail displayed at its full aspect ratio, centered and capped
  at `use_cases.image_max_height.card`, default 180px; single = a contained
  featured image, centered and capped at
  `use_cases.image_max_height.full`, default 500px). Because the featured image
  is height-capped and never fills a 100vw column, its srcset widths are
  **bounded to the cap** (`0.75× / 1× / 2×` of it, e.g. 375/500/1000w at 500px)
  rather than going up to full resolution. Both card and single `<img>` set
  explicit `width`/`height` (from srcset) and `fetchpriority="high"` (never
  `loading="lazy"`).
- `layouts/partials/pagination.html` — generic prev/page-numbers/next pager for a
  Hugo Paginator; renders nothing when there is a single page.
- `layouts/partials/srcset.html` — helper that returns a `dict` of responsive
  image attribute values (`src`, optional `srcset` with per-width descriptors,
  optional `sizes`, plus `width`/`height` for the largest variant's intrinsic px)
  for a raster Hugo image resource (`Fill` if `.height` is
  given, else `Resize` by width); callers place these into an `<img>` as ordinary
  template attributes. SVG is passed through verbatim with empty `srcset`.
  Returns `false` when no image is supplied.
- `layouts/partials/head.html` — meta/OG, `structured-data.html`, and the CSS
  pipeline (`resources.Get -> toCSS (transpiler: dartsass) -> resources.Concat ->
  minify`). It transpiles `variables.scss` (palette/`:root`), `main.scss` and the
  site's `extra.scss`, concatenates all three into a single bundle, minifies it,
  and **inlines** it into one `<style>` tag (via `safeCSS`) on every page, so the
  site ships ONE stylesheet with no extra CSS request.
- `assets/css/variables.scss` (+ the internal `_variables.scss` partial) — the
  **single overridable source** for brand colours: `$defaults` (light `--*`) and
  `$dark-defaults` (dark `--dark-*`), emitted into `:root`. Sites override by
  copying `variables.scss` (not the `_variables` partial), typically with
  `map-merge`. There is **no `params.theme_vars` in `hugo.yaml` anymore**.
- `layouts/partials/brand-logo.html`, `footer-logos.html`, `social-icons.html`,
  `structured-data.html`, `terminal.html` — overridable partials (see below).
- `layouts/partials/quickstart.html`, `homepage-cards.html` (+
  `homepage-cards/icon.html`) — reusable, data-driven homepage components
  (quickstart block and cards strip); rendered from the theme's default
  `layouts/index.html` (or a site override).
- `layouts/index.html` — the theme's default homepage `main` block: renders the
  homepage cards, quickstart, and the `homepage-after` hook in order (each no-ops
  until configured, so an unconfigured site still just shows the hero). Sites
  may override it with their own `layouts/index.html`.
- `layouts/partials/homepage-after.html` — homepage extension hook rendered below
  the quickstart in `layouts/index.html`; ships empty and is meant to be
  overridden by sites for further custom homepage content (receives the home
  page as its context).
- `layouts/partials/logo-img.html` — shared helper that renders a logo path:
  `.svg` files are inlined verbatim (no CSS classes injected) from the site's
  `assets/` (via `resources.Get`, with a `static/` readFile fallback); `.png`
  files render as an `<img>` targeting the asset's `RelPermalink` (or `static/`
  URL). Used by `brand-logo.html` (header) and `footer-logos.html` (footer).
- `layouts/partials/inline-svg.html` — shared helper that inlines an SVG file
  from the site's `assets/` (via `resources.Get`) by path with no CSS classes
  injected; used by the homepage-card icons. `footer_logos` entries take a
  path-based `logo` (light) plus optional `logo_dark` variant, swapped by the
  `theme-swap` mixin (see the `.footer-logo--dual` rules).
- `assets/css/main.scss` — all theme styles. It `@use "variables"` (the
  `_variables` partial) for the `light-theme`/`dark-theme` mixins. Palette values
  themselves come from `variables.scss`'s emitted `:root`. Theme mode is driven
  by the `data-theme` attribute on `<html>` (`auto`/`dark`/`light`, from
  `params.theme_mode`) — see the mode block near the theme-variable section.
- `theme.toml` — theme metadata (Hugo-standard; was `theme.yaml`).
- `scripts/bib_to_yaml.py` — publication pipeline (byte-identical to upstream).
- `Makefile` — **template** for consumers (default
  `SCRIPT = themes/apodixis/scripts/bib_to_yaml.py`); the `exampleSite/Makefile`
  is the runnable working reference (`SCRIPT = ../scripts/bib_to_yaml.py`).

## Design conventions (do not regress)

- **Sites own assets & per-site files; the theme never hardcodes image URLs.**
  Logos, footer logos, and social icons are parameter-driven or overridable
  partials. Per-site overrides belong in the site's own `layouts/`/`assets/`.
- Sites can override the theme's default `layouts/index.html` with their own;
  the theme contributes the hero via `baseof.html` and ships a default `main`
  block that sites may replace.
- **Browser support:** the nav hamburger↔X swap and theme toggle must NOT use
  `:has()`. Use the `~` general-sibling combinator (see the `nav-toggle-input`
  and `theme-toggle-input` rules). `:has()` is only acceptable for progressive
  enhancement (e.g. homepage quickstart `.qs-pills` tabs).
- Use `site.` / `hugo.` namespaces (avoid deprecated `Site` / `.Site` globals
  where possible; `.Site` is fine inside page-scoped templates).
- In template logic, prefer `(slice ...)` over `range` tuples, and build data
  structures with `dict` + `append` + variables (see `structured-data.html`).
- JSON-LD `@type` strings render with a space after the colon; when grepping
  output use the full `"@type": "<T>"` pattern.

## Publication pipeline

- Each site keeps `publications.bib`. Convert with the bundled script:
  `python3 scripts/bib_to_yaml.py publications.bib data/publications.yaml`.
  Requires `PyYAML` and `pandoc` on `PATH`; the Makefile uses
  `uv run --with pyyaml python` so PyYAML needn't be pre-installed.
- The generated `data/publications.yaml` groups entries by `years:[{year,
  entries:[...]}]`. Each entry: `key`, `type` (CSL), `authors:[{given, family,
  initials, highlight}]` (`highlight` via biblatex `author+an`), `title`,
  `venue` (original capitalisation), `keyword` (journal|conference|book|
  poster|thesis), and optional `doi`, `volume`, `number`, `pages`, `note`,
  `isbn`, `url`, `abstract`, `publisher`, `publisher_place`,
  `thesis_type`, `editor`, `bibtex`. See the schema block in the README.

## Local dev (exampleSite)

```sh
mkdir -p exampleSite/themes
ln -sfn ../.. exampleSite/themes/apodixis   # dev-only symlink, gitignored
hugo serve -s exampleSite
```

The symlink is dev-only and removed after builds; recreate it to run the
exampleSite. `make pubs && make serve` inside `exampleSite/` works directly.

## Gotchas

- `exampleSite/hugo.yaml` is the authoritative params reference; when adding a
  param, update it and the README contract together.
- The theme compiles SCSS through the `dartsass` transpiler (extended Hugo),
  avoiding the deprecated libsass path. The `# line` comment syntax in
  `main.scss` (used under the old libsass parser) also compiles under dartsass,
  but prefer `//` comments for new SCSS.
- Favicon / OG favicon links resolve from `static/images`; `og_image` defaults
  to `/images/logos/logo-1200-630.png`. The Twitter/X summary-card image uses a
  separate `twitter_image` param (default `/images/logos/logo-1200-675.png`, 16:9)
  in `head.html`.