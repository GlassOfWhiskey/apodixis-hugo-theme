.PHONY: serve site clean pubs

BIB = publications.bib
# Set SCRIPT to point at your checkout of the apodixis theme. If you installed
# the theme as a submodule at themes/apodixis, the default is correct. Adjust
# it otherwise, e.g. for the local exampleSite:
#   SCRIPT = ../scripts/bib_to_yaml.py
# Requires: python + PyYAML + pandoc on PATH (see theme README).
SCRIPT = themes/apodixis/scripts/bib_to_yaml.py
YAML = data/publications.yaml

# ── Generate publications data ─────────────────────────────────────────────────
$(YAML): $(BIB) $(SCRIPT)
	uv run --with pyyaml python $(SCRIPT) $(BIB) $(YAML)

pubs: $(YAML)

# ── Hugo commands ──────────────────────────────────────────────────────────────

serve: $(YAML)
	hugo server

site: $(YAML)
	hugo

# ── Clean ─────────────────────────────────────────────────────────────────────

clean:
	rm -f $(YAML)
	rm -rf public resources