# Apodixis Hugo Theme

A clean, accessible Hugo theme for open-source research projects, released
under the [MIT license](LICENSE). The name comes from the Greek for
"proof / demonstration".

It provides responsive navigation with submenus, automatic dark/light mode, a
home-page hero, publications and people pages, JSON-LD structured data, and a
publication pipeline (`.bib → data/publications.yaml`).

## Features

- Responsive top navigation driven by `site.Menus.main` (supports submenus).
- Manual + OS-aware dark/light theme toggle.
- Brand colours as SCSS variables (`assets/css/variables.scss`), overridable per site.
- Home page hero with subtitle, description, optional action buttons, and an
  optional GitHub button with a live star-count badge.
- `layouts/publications/list.html` — year-grouped and typed
  (journal/conference/book/poster/thesis), with Abstract/BibTeX/DOI toggles.
- `layouts/people/list.html` — card grid from `data/people.yaml`, with photo,
  role, and website/ORCID/Google Scholar icons.
- `layouts/use-cases/{list,single}.html` — optional card-grid list and single
  templates for a `use-cases` section (cards show an optional category badge and
  summary; the list paginates per `params.use_cases.pagination`).
- JSON-LD structured data (WebSite, Organization, WebPage/CollectionPage,
  BreadcrumbList, Person) — parametrised.
- Image handling via params and overridable partials, so you don't hardcode
  asset URLs in templates.

## Try the exampleSite

```sh
mkdir -p exampleSite/themes
ln -sfn ../.. exampleSite/themes/apodixis
hugo serve -s exampleSite
```

## Requirements

- Hugo (extended) ≥ 0.135.0
- To regenerate publications: `python3` + `PyYAML` + `pandoc` on `PATH`.
  The provided Makefile runs the script via `uv run --with pyyaml python`.

## Installation

```sh
# As a git submodule
git submodule add https://github.com/GlassOfWhiskey/apodixis-hugo-theme themes/apodixis

# Or a plain clone
git clone https://github.com/GlassOfWhiskey/apodixis-hugo-theme themes/apodixis
```

Then set `theme: apodixis` in your site's `hugo.yaml`.

## Configuration

A complete reference lives in [`exampleSite/hugo.yaml`](exampleSite/hugo.yaml).
Key params:

```yaml
params:
  subtitle: "The hero headline"          # big hero title
  description: "Short site/meta description"

  # Assets (social share + favicons)
  og_image: "/images/logos/my-logo-1200-630.png"
  twitter_image: "/images/logos/my-logo-1200-675.png" # Twitter/X summary card (16:9)
  favicon_16: "/images/logos/my-16x16.png"
  favicon_32: "/images/logos/my-32x32.png"

  # Header logo (via partials/brand-logo.html). A dict with `light`/`dark`
  # variants, or a plain string for the same logo in both modes. `.svg` logos
  # are inlined; `.png` logos render as an <img>.
  logo:
    light: "/images/logos/my-logo.svg"        # light mode
    dark: "/images/logos/my-logo-white.svg"   # dark mode

  # Footer social icons (omit keys you don't need)
  social:
    email: "team@example.org"
    github: "https://github.com/org/repo"
    pypi: "https://pypi.org/project/mypkg/"
    dockerhub: "https://hub.docker.com/r/org/image"
    orcid: ""

  # When set, the hero adds a GitHub button + live star-count badge
  github: "https://github.com/org/repo"

  # JSON-LD CollectionPage sections
  collection_sections: ["publications", "people"]

  # How the site picks light/dark (auto | dark | light).
  theme_mode: "auto"
```

Brand colours are **not** configured here. They are defined in the site's
`assets/css/variables.scss` — copy the theme's
[`assets/css/variables.scss`](assets/css/variables.scss) into your site and edit
the `$defaults` (light) / `$dark-defaults` (dark) maps. See
[Theme variables](#theme-variables) below.

> **Accent & light-mode contrast:** `accent` drives light-mode UI — icons
> (`.hp-icon`, `.people-icon`), quote/border accents, and the quickstart pill
> hover border. It is *not* used on the navy hero, so don't set it to the pale
> hero-arrow cyan (`#5de8ef`), which has <2:1 contrast on white. Use a deep cyan
> sibling such as `#0d6f85`. The dark-mode accent is a distinct variable
> (`--dark-accent`, see "Theme variables" below) set via `variables.scss`.

### Theme variables

All theme colours are CSS custom properties emitted into `:root` from the theme's
`assets/css/variables.scss`. To restyle a site, copy that file into your own
`assets/css/variables.scss` and edit the `$defaults` (light) and `$dark-defaults`
(dark) maps — Hugo resolves the site copy before the theme's, so it "just works"
(no `theme_vars` in `hugo.yaml` needed).

| Variable | Purpose | Light default |
| --- | --- | --- |
| `bg` | Page background | `#f7f9fc` |
| `bg-alt` | Alternating/striped background | `#e7ebf3` |
| `bg-card` | Card & pane background | `#eef1f7` |
| `text` | Primary text colour | `#1a1d24` |
| `text-muted` | Secondary/less-emphasised text | `#5c6470` |
| `border` | Borders & dividers | `#dfe3ea` |
| `primary` | Brand/emphasis: links, headings, active nav | `#003262` |
| `hero-start` | Hero backdrop gradient — start stop (theme-invariant) | `#003262` |
| `hero-end` | Hero backdrop gradient — end stop (theme-invariant) | `#0a4d85` |
| `accent` | Light-mode highlight accent (icons, quotes, emphasis) — keep >4.5:1 on white | `#fdb515` |
| `success` | Positive/hover accent | `#2ea043` |
| `pubtype-journal` | Publication type colour — journal (badge & legend swatch, theme-invariant) | `#c32b72` |
| `pubtype-conference` | Publication type colour — conference (badge & legend swatch, theme-invariant) | `#196ca3` |
| `pubtype-book` | Publication type colour — book (badge & legend swatch, theme-invariant) | `#ef942d` |
| `pubtype-poster` | Publication type colour — poster (badge & legend swatch, theme-invariant) | `#626a70` |
| `pubtype-thesis` | Publication type colour — thesis (badge & legend swatch, theme-invariant) | `#f8c91f` |
| `btn-bg` | Hero button background | `#ffffff` |
| `btn-text` | Hero button text | `#5a606a` |

At a minimum, copy the theme's `variables.scss`, `map-merge` your overrides onto
the defaults (so every key is still emitted), and let it emit `:root` — this is
exactly what `exampleSite/assets/css/variables.scss` does. The
**theme-invariant** variables — `hero-start`, `hero-end`, and the `pubtype-*`
publication colours — stay identical in light and dark mode; overrides only ever
affect the shared `:root` value.

> **Pro tip:** because the maps live in SCSS, you can use Sass functions
> (`lighten()`, `mix()`, `darken()`, …) when you override them, not just literal
> hex values.

#### Dark palette — one definition point

The dark palette is driven by `--dark-*` variables emitted in `:root` from the
`$dark-defaults` map in `variables.scss`. The theme's `dark-theme` mixin maps
every surfaced `--*` variable (e.g. `--primary`) from its `--dark-*`
counterpart, and applies it automatically in **every** dark state — the OS-dark
switch, the manual toggle, or a forced `theme_mode: dark`. To restyle dark mode,
override these once in the same `variables.scss`:

| Variable | Purpose | Dark default |
| --- | --- | --- |
| `--dark-bg` | Page background | `#0d1016` |
| `--dark-bg-card` | Card & pane background | `#151a23` |
| `--dark-bg-alt` | Alternating/striped background | `#1a202b` |
| `--dark-text` | Primary text colour | `#e2e7ef` |
| `--dark-text-muted` | Secondary/less-emphasised text | `#838d9c` |
| `--dark-border` | Borders & dividers | `#242b36` |
| `--dark-primary` | Brand/emphasis in dark mode | `#fdb515` |
| `--dark-accent` | Highlight accent in dark mode | `#73c5c6` |
| `--dark-success` | Positive/hover accent in dark mode | `#2ea043` |
| `--dark-btn-bg` | Hero button background (dark) | `#1a202b` |
| `--dark-btn-text` | Hero button text (dark) | `#e2e7ef` |

Because dark mode is a single source, you never need to replicate the toggle's
light-revert logic yourself. For example, to give the site a cyan dark `--primary`
(as the apodixis brand does), a single `variables.scss` block suffices:

```scss
@use "variables" as *;
$dark-defaults: map-merge($dark-defaults, (
  "primary": #7ee0e6,
  "accent": #6af0f4,
  "text-muted": #9aa3b1,
));
```

This applies from the OS-dark switch, the manual toggle, and a forced
`theme_mode: dark`, and toggling back to light cleansly reverts to `:root` (the
`light-theme` mixin resets every surfaced variable to `inherit`).

### Theme mode (`auto` | `dark` | `light`)

`params.theme_mode` chooses how the site picks light/dark:

- `auto` (default) — follow the browser/OS `prefers-color-scheme`. The header
  toggle lets a visitor flip to the *opposite* of the OS preference.
- `dark` — always dark. No toggle is rendered and `auto`'s OS/media rule is
  bypassed.
- `light` — always light. Same, in reverse.

```yaml
params:
  theme_mode: "auto"
```

The mode is emitted as a `data-theme` attribute on `<html>`; the theme's SCSS
drives light/dark (and logo swaps) from it. Because `dark`/`light` are resolved
at build time (no JavaScript), there is no flash of the wrong theme on first
paint.

### Menus

Header navigation comes from `site.Menus.main`. Submenus use the standard
`parent` key.

### Home page

The `baseof.html` shell renders the hero automatically on the home page. The
theme ships a default `layouts/index.html` that fills the `main` block with the
homepage cards, quickstart, and the `homepage-after` hook (each renders nothing
until you configure it, so a bare site still gets the hero). Override it with
your own site `layouts/index.html` to define a custom `main` block (cards,
quickstart, etc.). See `exampleSite` for a minimal example.

### Homepage cards component

A reusable, configurable "homepage cards" strip (a row of icon + title + text
link cards shown under the hero). Render it from your homepage `main` block:

```go-html-template
{{ partial "homepage-cards.html" (dict "cards" site.Params.homepage_cards) }}
```

Configure it under `params.homepage_cards`, which takes an optional `icon_size`
(px, applied to every card's icon for a consistent strip) and the `cards` list.
Each card has `title`, `url`, `text`, and an `icon` — a path to an SVG file
under the site's `assets/images/icons` (e.g. `/images/icons/about.svg`); the
theme inlines the SVG and styles it via the `.hp-icon` span (the icon file
itself must contain no CSS classes — use plain `stroke="currentColor"`
markup). `target` is optional (rendered with `rel="noopener"`). When
`icon_size` is omitted (or 0), each icon renders at its natural SVG size:

```yaml
params:
  homepage_cards:
    icon_size: 64   # optional: one size in px for ALL card icons
    cards:
      - title: "About"
        url: "/about"
        text: "Learn about the project and its goals."
        icon: "/images/icons/about.svg"
      - title: "Publications"
        url: "/publications"
        text: "Browse the papers, theses and posters by the group."
        icon: "/images/icons/publications.svg"
      - title: "People"
        url: "/people"
        text: "Meet the researchers behind the project."
        icon: "/images/icons/people.svg"
```

`url` is optional per card. When present, **only the icon** is wrapped in a
clickable link — the title and `text` remain static text, and only the icon
highlights/moves on hover. When a card has no `url` (e.g. a decorative title
strip), the icon is static too and the card has no links or hover effects:

```yaml
    cards:
      - title: "Highlights from 2026"
        url: "/highlights"      # optional; link applies to the icon only
        text: "A banner card — only the icon is clickable."
        icon: "/images/icons/highlights.svg"
```

Notes:
- The partial renders nothing when no `cards` are configured, so sites without
  a homepage-cards strip are unaffected.
- `icon_size` is applied once to the whole strip, not per card, so the cards
  stay visually consistent regardless of each SVG's intrinsic dimensions.
- Icons are inlined at build time (not linked), so CSS custom properties and
  inherited `color`/`currentColor` flow straight from the theme's `.hp-card`
  hover styles.

### Quickstart component

A reusable, configurable "quickstart" block (step pills + terminal panes + an
optional footer call-to-action). Render it from your homepage `main` block:

```go-html-template
{{ partial "quickstart.html" (dict "data" site.Params.quickstart) }}
```

Configure it under `params.quickstart`:

```yaml
params:
  quickstart:
    title: "Get started in seconds"          # section heading (default "Quickstart")
    steps:                                    # required
      - label: "Install"
        comment: "Install the Python package from PyPI."
        terminal:                             # optional overrides (see extra-hints)
          title: "example"
          prompt: "$"
          code: "pip install example"
      - label: "Run"                          # add as many steps as you like
        comment: "Launch a workflow anywhere."
        terminal:
          title: "example"
          code: "example run workflow.yml"
    footer:                                   # optional
      html: 'Define your workflow once, <a href="/about">execute it anywhere</a>.'
```

Notes:
- Steps open mutually-exclusively (they share the same `details name`); the
  first step is open by default.
- Both `steps[].comment` and `footer.html` render as raw inline HTML (via
  `safeHTML`), so you can drop in links, `<code>`, `<span>`, etc.:
  ```yaml
  steps:
    - label: "Install"
      comment: 'Install the <code>example</code> package from <a href="/docs">PyPI</a>.'
  ```
  This is a theme-maintained `safeHTML`, so use trusted/author-curated content
  only — it is not sanitised.
- Each step's terminal prompt defaults to `$`. To render a step's code line
  with **no** prompt prefix (e.g. plain output), set `prompt: ""` on that step's
  `terminal`.
- The document block renders nothing when `steps` is absent, so sites without a
  quickstart are unaffected.

### Homepage extension hook

Below the quickstart, the example homepage also renders a dedicated override
hook so you can drop in further content without forking the theme:

```go-html-template
{{ partial "homepage-after.html" . }}
```

The theme's `layouts/partials/homepage-after.html` ships empty by default. To
add your own content below the quickstart, create
`layouts/partials/homepage-after.html` in **your site** (overriding the theme's)
and put any HTML there — it receives the home page as its context (`.`), so you
can pull site/page data too:

```html
<section class="about-section">
  <h2>Learn more</h2>
  <p>{{ site.Params.tagline }}</p>
</section>
```

This mirrors the other overridable partials (`footer-logos`, `social-icons`,
`terminal`, etc.) and keeps your homepage customisation in your site, not the
theme.

### Hero action buttons

```yaml
hero_actions:
  - label: "Get started"
    url: "https://docs.example.org"
    style: "primary"   # or omit for a regular hero button
    svg: ""            # optional inline SVG for a leading icon
```

The hero also auto-renders a GitHub button and a shields.io star-count badge
when `params.social.github` is set (the same value that drives the footer's
GitHub icon); both the badge URL and the `/stargazers` link are derived from
that value. These render inside the same `.hero-actions` row as any
`hero_actions` buttons.

### Footer images

Override `layouts/partials/footer-logos.html` to render your own
institution/sponsor logos, or use the default which iterates `params.footer_logos`.
Each entry supports:

```yaml
params:
  footer_logos:
    - label: "Example Group"      # aria-label + rel=noopener link target
      url: "https://example.org"
      logo:                        # dict with light/dark variants (inlined SVG)
        light: "/images/logos/fund/example-light.svg"
        dark: "/images/logos/fund/example-dark.svg"
      width: 100                  # optional CSS width for the inlined SVG
```

`logo` may instead be a plain string (e.g. `logo: "/images/logos/fund/example.svg"`)
to share a single logo across both modes; the deprecated `logo_dark` still supplies
the dark variant when `logo` is a string. SVGs live under the site's `assets/images`
and are **inlined** at build time (no CSS classes inside the SVG). A dark variant
(`logo.dark`) is swapped in automatically for dark mode / when the theme toggle is
dark (mirrors the header logo's light/dark swap).

A masked-image mode also remains for monochrome PNG/SVG logos: give the entry a
`logo` path plus `width`/`height` sizing (e.g.
`{label, url, logo, width, height}`) and it is rendered as a mask instead of an
inlined SVG.

### People page

Create a `content/people/_index.md` section page; the theme's
`layouts/people/list.html` renders a card grid (photo, name, role, and icons)
from `data/people.yaml`:

```yaml
members:
  - name: "Jane Doe"
    role: "Principal Investigator"
    photo: "/images/people/jane.png"
    website: "https://example.org/jane"
    google_scholar: ""             # Google Scholar user id, or omit
    orcid: "0000-0000-0000-0001"
```

`photo` is a path under `static/`; the optional fields are rendered as icons
and may be omitted per member. Add the section to `menus.main` for navigation.

### Use cases

Create a `content/use-cases/_index.md` section page, then one **page bundle**
(directory with `index.md`) per use case under `content/use-cases/`. The theme's
`layouts/use-cases/list.html` renders a card grid of the section's child pages,
each linking to its own page; `layouts/use-cases/single.html` renders the page
body plus a "back to all" link.

```text
content/use-cases/
├── _index.md                  # section page → card grid
└── distributed-training/
    ├── index.md               # front matter + Markdown body
    └── demo-1.png             # gallery image (page-bundle resource)
    └── demo-2.png
```

Each use-case `index.md` uses standard front matter (`title`, `category`,
`summary`, `description`) and its Markdown body. The card shows an optional
`category` badge, the title, and a `summary` excerpt. When no `summary` is
given, the theme falls back to Hugo's automatic `.Summary` (the first paragraph,
or the text before an explicit `<!--more-->`). Add the section to `menus.main`
for navigation.

When `use_cases.pagination.enabled` is true (default) and the section has more
cards than `use_cases.pagination.size` (cards per page, default `6`), the list
is split into paginated pages with prev/next and page-number navigation (see the
exampleSite config). Set `pagination.enabled: false` to show every card on a
single page.

#### Responsive images

A use-case image is rendered automatically with responsive `srcset`. The image
is the first image resource in the page bundle (e.g. a `demo-1.png` sitting next
to the page's `index.md`, as in the tree above). An optional front-matter
`image:` field overrides this with a global asset under the site's `assets/`
(e.g. `image: "/images/use-cases/demo-1.png"`) via `resources.Get`.

- **Listing card** — the full image rescaled to fit, centered. The image is
  shown at `width:100%` with its natural aspect ratio, capped at
  `use_cases.image_max_height.card` (default `180`px) via `object-fit: contain`,
  so the whole image is visible (never a cropped detail). Variants are `Resize`d
  at 320/640/960 wide with `sizes="(min-width: 601px) 33vw, 100vw"`. The `<img>`
  carries explicit `width`/`height` (the largest variant's intrinsic pixels, to
  prevent layout shift) and `fetchpriority="high"` (no `loading="lazy"`, so the
  card images load eagerly).
- **Detail page** — a **featured image** shown at the top of the content inside
  the theme's framed card (1px border + rounded corners). It keeps its natural
  **contained** aspect ratio (never stretched to the full column width), capped
  at `use_cases.image_max_height.full` (default `500`px, matching the data portal)
  with `object-fit: contain` and no cropping. Because it is height-capped it never
  fills a 100vw column, so the `srcset` variants are **bounded to the cap** rather
  than going up to full-resolution: `0.75× / 1× / 2×` of the cap (e.g.
  `375/500/1000w` for the default 500px) so the browser fetches only as much as
  it displays (a 2× member covers retina). It carries explicit `width`/`height`
  (the largest variant's intrinsic pixels) and `fetchpriority="high"`. It is much
  larger than the card thumbnail.

Both keys nest under `use_cases.image_max_height` and both cap an un-cropped
`contain` image — the **`card`** key for the list thumbnail, the **`full`** key
for the single-page featured image. Neither crops, so the full image is always
shown. Cards without any image fall back to
just the category badge, title and summary.

Both are generated by [`layouts/partials/srcset.html`](layouts/partials/srcset.html).
The partial takes a `dict` (`image`, `widths`, optional `height`, optional
`sizes`) and returns a `dict` of resolved `src`/`srcset`/`sizes`/`width`/`height`
**attribute values** (or `false` for a missing image) that callers drop into an
`<img>` as ordinary, properly-escaped template attributes — not an attribute
string, so Hugo never HTML-escapes the URLs. `width`/`height` give the largest
variant's intrinsic dimensions in px (for `width`/`height` attributes). Each
value is a processed, responsive file (Fill) or pass-through (`Resize`); SVG is
passed through verbatim with empty `srcset`.

#### Raw HTML in Markdown

The theme does **not** enable Hugo's `goldmark.renderer.unsafe`, so raw HTML
written directly inside a `.md` content file is escaped rather than rendered.
This is intentional — the theme's own HTML features (homepage cards, quickstart
comments/footers, logos and icons) are handled in templates and do not need it.
If a site's content intentionally embeds raw HTML in Markdown (e.g. custom
`<figure>`s or tables with classes), enable it in that site's own config:

```yaml
markup:
  goldmark:
    renderer:
      unsafe: true
```

## Publications pipeline

Each project keeps its own `publications.bib`. Generate the data file with:

```sh
python scripts/bib_to_yaml.py publications.bib data/publications.yaml
# or copy the theme's Makefile template into your site and run:
make pubs
```

The theme ships a [`Makefile`](Makefile) template wiring
`publications.bib → scripts/bib_to_yaml.py → data/publications.yaml`, plus
`pubs`, `serve`, `site`, and `clean` targets. The exampleSite has its own
working Makefile. The generated `data/publications.yaml` format is documented
in [AGENTS.md](AGENTS.md).

## Customisation

Override any theme file by placing one with the same path in your site's
`layouts/` or `assets/`. Common hooks:

- `assets/css/variables.scss` — brand colours & dark palette (copy the theme's)
- `layouts/partials/brand-logo.html` — header logo markup
- `layouts/partials/footer-logos.html` — footer sponsor logos (path-based
  light/dark SVGs from `assets/`)
- `layouts/partials/social-icons.html` — footer social icons
- `layouts/partials/inline-svg.html` — shared helper that inlines an SVG from the
  site's `assets/` by path (used by homepage-card icons and footer logos)
- `layouts/partials/terminal.html` — a terminal/quickstart pane (title, prompt,
  code) used by the quickstart component
- `layouts/partials/quickstart.html` — the configurable quickstart block
  (title, step pills, terminal panes, footer); driven by `params.quickstart`
- `layouts/partials/homepage-cards.html` (with `homepage-cards/icon.html`) — the
  configurable homepage cards strip; driven by `params.homepage_cards`
- `layouts/partials/homepage-after.html` — homepage extension hook rendered below
  the quickstart; overridable for further homepage content
- `layouts/partials/pagination.html` — generic prev/page-numbers/next pager for a
  Hugo Paginator (used by the `use-cases` list); renders nothing on one page
- `layouts/use-cases/{list,single}.html` — the `use-cases` section card-grid
  list (category badge, optional summary, paginated) and single-page templates
- `assets/css/extra.scss` — per-project CSS (components, not palette), transpiled
  and concatenated with `variables.scss` + `main.scss` into a single bundle that
  is minified and inlined into one `<style>` tag in the page head