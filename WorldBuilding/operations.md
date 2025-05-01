# Project Operations Manual

This document governs session lifecycle, memory behavior, structural validation, and archival procedures for the WorldBuilding project.

---

## 1. Session Control

### [start session]
- Loads `project_structure.yaml` from the root of the project.
- If `project_structure.yaml` is not available:
  - Prompt the user for permission to retrieve it from GitHub
  - Download from:  
    https://raw.githubusercontent.com/DouglasMarsh/project-indigo/refs/heads/main/WorldBuilding/project_structure.yaml
  - Save it to the project root
  - Rerun `[start session]`
- Run `[load project]`
- Automatically load all memory blocks listed under `memory_blocks`.
- Report out discrepencies between project_structure.yaml and archive structure

### [session reset]
- Clears all currently active memory blocks.
- **Compress chat history**: wipes session context and memory, simulating a fresh start.
- Rerun `[start session]` to reinitialize structure and autoload memory.

### [load project]
- Validate that `project_structure.yaml` is present.  
  - If missing, notify the user and stop.
- Locate `WorldBuilding_*.zip` archive.
  - If multiple found, as user which one to use
  - When archive found or resolved, extract and initialize the project structure.
  - If archive not found, ask the user for GitHub restore permission.
    - Use the following URL template to retrieve missing files:
      - https://raw.githubusercontent.com/DouglasMarsh/project-indigo/refs/heads/main/WorldBuilding/<path>
- Run a full structural and memory validation (`[validate]`).

### [load memory <block name>]
- Manually load a specific memory block.
- Block name must match a folder in the project structure or an entry in `core/memory.md`.

### [load all memory]
- Loads all `.md` files in memory-valid directories as defined in `project_structure.yaml`.
- Useful for full-context restoration. May reduce performance in large projects.

### [validate]
- **Perform actions exactly as they are stated.**
- Runs a full structural and memory integrity check.
- Verifies that all required files and folders exist and contain updated content.
  **IF THE FILE CONTAINS PLACEHOLDER CONTENT IT IS NOT VALID**
- Ensures `memory_blocks` in `project_structure.yaml` match known memory.
- **Does not create an archive.**

### [validate and close]
- **Perform actions exactly as they are stated.**
- Performs all actions in `[validate]`.
- **Increments the minor version number in `project_structure.yaml`.**  
  Example: `1.0 → 1.1`
- Creates a validated archive:
  `WorldBuilding_Project_Validated_<YYYYMMDDhhmm>.zip`
- Marks the session as backed up and restorable.

---

## 2. Memory Management

### What Is a Memory Block?
A memory block is a **named unit of session memory**, defined by one of two methods:

- As a **top-level folder in the project structure**, such as `fleet/`, `tech/`, or `factions/`
- As a **named block** listed in `core/memory.md`, with an associated description and optionally linked files

Memory blocks must be explicitly declared in the project in order to be recognized for loading. They are used to modularize world knowledge and ensure selective recall based on project scope.

### How Memory Blocks and File Associations Work
- When a memory block is created (manually or via YAML), it persists.
- Any files discussed or modified during that session are implicitly associated with that block.
- These associations are listed in `core/memory_map.md`.

### Memory Management Rules
To preserve modular memory integrity, the following rule applies:

> When discussions shift between distinct topics (e.g., Cryohelion → narrative → fleet), and no memory block has been saved since the previous topic, the assistant will prompt the user to save the current discussion as a named memory block **before proceeding**.

This ensures session memory is not over-bundled and remains modular and restorable.

---

## 3. Validation & Archival

### Structure Validation
- Confirm required files:
  - `project_structure.yaml`
  - `core/operations.md`
- Ensure all folders and files defined in `project_structure.yaml` exist on disk.
- Validate that each file is not only present but contains current, expected content.
  - This includes verifying that memory-backed files (e.g., those referenced in `core/memory_map.md`) are present and readable.
- Confirm that all memory-related documentation (`memory.md`, `memory_map.md`) has been regenerated and matches the defined structure.

> No assumptions. Validation must verify actual content integrity and alignment with declared structure.

### Memory Sync
- Regenerate `core/memory.md` to summarize current memory blocks.
- Rebuild `core/memory_map.md` to cross-reference blocks with files.
- Update `memory_blocks` list in `project_structure.yaml`.

### Final Archive Creation
- If valid, create `WorldBuilding_Archive_<YYYYMMDDhhmm>.zip` at the project root.
- Confirm archive structure integrity.
- Provide final download for storage or transfer.

---

This document governs the lifecycle of session operations, memory recall, and project validation for worldbuilding continuity.

---

## Soft Rule: Project Structure Auto-Sync

When a file or module is **created, moved, or deleted**, the `project_structure.yaml` file must be updated to reflect the change.

This includes:
- Adding entries for newly created files or folders (especially if memory-linked)
- Removing references to deleted files or modules
- Updating paths for any renamed or relocated elements
- Ensuring memory blocks remain linked to existing, accessible content

> This ensures structural integrity, prevents memory desync, and guarantees accurate validation and archival.
