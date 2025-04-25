# Project Validation Template — Worldbuilding

## Purpose
Use this template to validate the current project against the canonical `project_structure.yaml` and create a new "Validation Complete" checkpoint if successful.

---

## Validation Steps

1. **Load Structure**
   - Import and parse `project_structure.yaml`
   - Confirm presence of all listed folders and files:
     - `core/`
     - `factions/`
     - `tech/`
     - `timeline/`
     - `narratives/`
     - `real_data/`
     - `scripts/`
   - Ensure all key `.md`, `.csv`, `.tsv`, and `.py` files are accounted for.

2. **Validate Memory Blocks**
   Confirm the following concepts are loaded into active memory:

   - GLSS theoretical rules and classifications
   - Precursor ruins discovery at Hygiea
   - Gravitics derived from Tesla-LeSaut hybrid theory
   - Climate collapse as orbital economic catalyst
   - UOWC labor movement and Pallas Thermo incident
   - Cults and PMFs rise after industrial and ideological crisis
   - Canonical timeline split into: Orbital Era, Precursor Era, GLSS Era

3. **Check Backup Strategy**
   - Confirm `Worldbuilding_Project_Clean.zip` or equivalent exists
   - Confirm that archive includes `.md` files, `real_data/`, and `scripts/`

4. **Checkpoint Creation**
   - If structure and memory validation succeed:
     - Set a new "Validation Complete" checkpoint
     - Record timestamp and state description

---

## Post-Validation Commands

- "Validate project" → Run validation steps
- "Summarize memory" → Confirm memory alignment
- "Backup project" → Export updated archive

---

## Notes
- Always upload `project_structure.yaml` first when starting a new session.
- Manual corrections should follow validation failures before checkpointing.

