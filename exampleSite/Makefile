.PHONY: serve site clean pubs

# ── Example site ───────────────────────────────────────────────────────────────
# This Makefile is for the exampleSite only: the publication script lives in the
# theme root, two levels up. Sites that consume apodixis as a submodule would
# instead use SCRIPT = themes/apodixis/scripts/bib_to_yaml.py (see the theme's
# own Makefile template).
# Requires: python + PyYAML + pandoc on PATH (see theme README).

BIB = publications.bib
SCRIPT = ../scripts/bib_to_yaml.py
YAML = data/publications.yaml

# ── Generate publications data ─────────────────────────────────────────────────
$(YAML): $(BIB) $(SCRIPT)
	uv run --with pyyaml python $(SCRIPT) $(BIB) $(YAML)

pubs: $(YAML)

# ── Hugo commands ──────────────────────────────────────────────────────────────

serve: $(YAML)
	hugo server --themesDir themes

site: $(YAML)
	hugo --themesDir themes --destination public

# ── Clean ─────────────────────────────────────────────────────────────────────

clean:
	rm -f $(YAML)
	rm -rf public resources