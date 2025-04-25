<!-- run: validate_project_and_close -->
<!-- requires: in-memory project_structure.yaml -->

# Validation and Close Command — Worldbuilding Project

## Purpose
Validate project structure and memory. Optionally archive and finalize session if successful.

---

## Commands

### [validate]

1. **Load current in-memory `project_structure.yaml`**
2. **Validate Structure**
   - Confirm all required folders and files exist
3. **Validate Memory**
   - GLSS rules, Precursor ruins, Tesla-LeSaut theory, Climate collapse, UOWC, Cults, Timeline Eras
4. **Report**
   - If valid: Confirmation report
   - If errors: Detailed list of missing files or memory issues

---

### [validate and close]

1. Run `[validate]`
2. If validation passes:
   - **Build Archive ZIP** (e.g., Worldbuilding_Project_Clean.zip)
   - **Validate ZIP Contents**
     - Structure matches `project_structure.yaml`
     - All files have non-placeholder content
   - **Provide Archive Download**
   - **Create New "Validation Complete" Checkpoint**
3. Report final session status
