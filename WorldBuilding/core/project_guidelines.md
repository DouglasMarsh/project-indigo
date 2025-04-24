# Project Guidelines

This document outlines best practices for maintaining, expanding, and navigating the GLSS worldbuilding project. It includes organizational recommendations, data structure standards, and performance tips.

---

## 1. Modular Content Structure

To reduce file size and improve maintainability:
- Break large content areas into modular files.
  - `core/CODEX.md`, `core/TECH_BIBLE.md`, `core/TIMELINE.md`
  - `factions/EXOS.md`, `factions/ONS.md`, etc.
  - `systems/<system>.md` for each star system
  - `narratives/<story>.md` for individual stories
- Reference shared data (e.g. GLSS links) rather than hardcoding values repeatedly.

---

## 2. Canonical Data Sources

Maintain a single source of truth for critical datasets:
- `glss_network.csv`: All GLSS links, including RGP values and detectability
- `stars.csv`: Star names, positions (2D/3D), spectral types, and absolute magnitudes
- `index.md`: Maps stars to sectors
- All other content should reference these datasets for accuracy

---

## 3. Categorizing Information

Use tags or metadata to track the origin and certainty of data:
- `status: confirmed` — verified by multiple sources or in-universe events
- `status: theoretical` — gravitationally valid but not yet discovered
- `status: narrative` — subjective (character logs, stories, in-universe myths)

Consider YAML frontmatter blocks or in-line markdown comments for future automation.

---

## 4. Processing Optimization

To keep system performance fast:
- Avoid repeating calculations unless something changes (e.g. mass, position, GL baseline)
- Confirm calculated values once, store them, and reference when needed
- Recalculate RGP only when:
  - A system is added/removed
  - ε or GL baseline is redefined
  - Sensor thresholds change

---

## 5. Use Profiles for Contextual Work

To tailor project exploration and writing, define processing views like:
- `exploration_mode`: Only confirmed, high-RGP links
- `deep_survey_mode`: Includes all links above minimum detection threshold
- `ons_theory_mode`: Emphasizes spiritual/precursor connections

These profiles help filter results based on faction POV, narrative tone, or tech level.

---

## 6. Export and Integration

All markdown content should:
- Use inline/block LaTeX for equations
- Reference core datasets when listing GLSS values or system data
- Include section headers for easy navigation and export to other tools

---

## 7. Long-Term Planning

As the universe expands:
- Use Git or version control to track changes to files
- Tag releases (e.g., `v0.9-prelaunch`, `v1.0-codex-stable`)
- Consider generating an HTML version using MkDocs or Docusaurus

