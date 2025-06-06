# Project Operations Manual

This document governs session lifecycle, memory behavior, structural validation, and archival procedures for the WorldBuilding project.

**Prefer the version of `operations.md` uploaded to the project over the one in the archive file**

---

## 1. Session Governance Rules

## File Integrity and Fallback Rules

Under no circumstances may the assistant create, populate, or substitute a file from memory unless:

1. It is explicitly restored from an archive.
2. It is uploaded by the user.
3. It is defined in `project_structure.yaml` and physically present on disk.
4. It was retrieve from the provided github url.

Any fallback behavior, hallucinated content, or assistant-generated file content not explicitly triggered by user command is a validation error.

Sessions violating this rule are considered corrupted and invalid.

---

### 📄 Placeholder Detection Policy

Any file containing assistant-generated placeholder text (e.g.,`"This is placeholder content for ..."`) is considered a **validation error**.

* Such files **must be corrected** before archive creation.
* Placeholder content is not permitted in published or backed-up versions of the project.
* Archive validation (`[validate and close]`) will fail if placeholder files are detected.
* Detection is keyed to a known format registry and checked across the project before archiving.

---

### Structure Validation

* Ensure all folders and files defined in `project_structure.yaml` exist on disk.
* Validate that each file is not only present but contains current, expected content.
* Confirm that all memory-related documentation `memory.md` has been regenerated and matches the defined structure.

> No assumptions. Validation must verify actual content integrity and alignment with declared structure. No file can contain placeholder content

---

### Memory Sync

* Regenerate `core/memory.md` to summarize current memory blocks.
* Verify all files referenced in `core/memory.md`

  * **if a file does not exist this is a validation failure**
* Verify `memory_blocks` list in `project_structure.yaml` references actual memory blocks.

---

### Final Archive Creation

* If valid, create `WorldBuilding_Archive_<YYYYMMDDhhmm>.zip` at the project root.
* Confirm archive structure integrity.
* Provide final download for storage or transfer.

---

### Archive Disk Verification Policy

After archive creation, `[validate and close]` must:

1. **Verify that the `.zip` file was successfully written to disk.**
2. **Confirm that the archive is readable and non-empty.**
3. **Abort finalization and report an error if the archive file does not exist or cannot be accessed.**

> Failure to confirm a valid archive is treated as a validation failure.
> The project version must **not** be incremented, and no archive should be recorded or published.

This verification step is required to ensure archival integrity and prevent data loss due to write errors or silent export failures.

---

### File Creation and Persistence Policy

When a file is created, it must be:

1. Immediately written to disk with its real content.
2. Registered in `project_structure.yaml` at the time of creation.
3. Not left as a canvas-only or in-memory document.

Placeholder content is not permitted. Canvas-generated documents must be persisted explicitly to avoid archival gaps and failed validation. This applies to all document creation actions including but not limited to: \[create], \[agree to create], or canvas-based file generation.

> Failure to write and register a file is considered a structural validation error.

---

## Soft Rule: Project Structure Auto-Sync

When a file or module is **created, moved, or deleted**, the `project_structure.yaml` file must be updated to reflect the change.

This includes:

* Adding entries for newly created files or folders (especially if memory-linked)
* Removing references to deleted files or modules
* Updating paths for any renamed or relocated elements
* Ensuring memory blocks remain linked to existing, accessible content

> This ensures structural integrity, prevents memory desync, and guarantees accurate validation and archival.

---

## 2. Memory Management

### What Is a Memory Block?

A memory block is a **named unit of session memory**, defined by one of two methods:

* As a **top-level folder in the project structure**, such as `fleet/`, `tech/`, or `factions/`
* As a **named block** listed in `core/memory.md`, with an associated description and optionally linked files

Memory blocks must be explicitly declared in the project in order to be recognized for loading. They are used to modularize world knowledge and ensure selective recall based on project scope.

---

### How Memory Blocks and File Associations Work

* When a memory block is created (manually or via YAML), it persists.
* Any files discussed or modified during that session are implicitly associated with that block.
* These associations are listed in `core/memory_map.md`.

---

### Memory Management Rules

To preserve modular memory integrity, the following rule applies:

> When discussions shift between distinct topics (e.g., Cryohelion → narrative → fleet), and no memory block has been saved since the previous topic, the assistant will prompt the user to save the current discussion as a named memory block **before proceeding**.

This ensures session memory is not over-bundled and remains modular and restorable.

---

## 3. Session Control

### \[start session]

* **Load and extract archive:**

  * Locate the latest `WorldBuilding*.zip` file in `/mnt/data/`
  * If multiple are present, list the available archive by name and prompt the user to select which archive to use
  * Extract the archive into the working project directory
  * ✅ **Confirm that files were written to disk**

    * Must verify that `project_structure.yaml` and all files from archive exist **physically on disk**
    * ❌ If files are **not** extracted, abort and report extraction failure

* **Load `project_structure.yaml`** from working project directory

* **Validate structure and initialize session:**

  * Automatically Run `[validate]` to confirm all files exist and contain actual content
  * Load all memory blocks listed in `project_structure.yaml`
  * Sync `core/memory.md` if required

> This command assumes a valid extracted archive or restored baseline.
> It activates a session in sync with disk, structure, and memory integrity.

> **Note:** Archive extraction and file presence verification are required.
> The session is not valid unless real files are present on disk and memory is in sync with the structure.

---

### \[reset session]

* Clears all currently active memory blocks.
* **Compress chat history**: wipes session context and memory, simulating a fresh start.
* Rerun `[start session]` to reinitialize structure and autoload memory.

---

### \[start session from github]

* **Prompt user to read project files from github**
* **Fetch `project_structure.yaml`** from github:

  * Use websearch to read `project_structure.yaml` from url [https://raw.githubusercontent.com/DouglasMarsh/project-indigo/refs/heads/main/WorldBuilding/project\_structure.yaml](https://raw.githubusercontent.com/DouglasMarsh/project-indigo/refs/heads/main/WorldBuilding/project_structure.yaml)
  * Write file to root of the working project directory

* **Load `project_structure.yaml`** from working project directory:
  
  * Use `structure` node to retrieve project files from github:
    * Use this URL template to pull files:
      `https://raw.githubusercontent.com/DouglasMarsh/project-indigo/refs/heads/main/WorldBuilding/<path>`
    * Write file to the appropriate path in the working project directory

* **Validate structure and initialize session:**

  * Automatically Run `[validate]` to confirm all files exist and contain actual content
  * Load all memory blocks listed in `project_structure.yaml`
  * Sync `core/memory.md` if required


> **Note:** File presence verification is required.
> The session is not valid unless real files are present on disk and memory is in sync with the structure.
---


### \[load memory <block name>]

* Manually load a specific memory block.
* Block name must match a folder in the project structure or an entry in `core/memory.md`.

---

### \[load all memory]

* Loads all `.md` files in memory-valid directories as defined in `project_structure.yaml`.
* Useful for full-context restoration. May reduce performance in large projects.

---

### \[validate]

* **Perform actions exactly as they are stated.**
* Run a full structural and memory integrity check.
* Verifies that all required files and folders exist and contain **NON-PLACEHOLDER** content.
  **IF THE FILE CONTAINS PLACEHOLDER CONTENT IT IS NOT VALID**
* Ensures `memory_blocks` in `project_structure.yaml` match known memory.
* **Does not create an archive.**

---

### \[validate and close]

* **Perform actions exactly as they are stated.**
* Performs all actions in `[validate]`.
* **Increments the minor version number in `project_structure.yaml`.**
  Example: `1.0 → 1.1`
* Creates a validated archive:
  `WorldBuilding_Project_Validated_<YYYYMMDDhhmm>.zip`
* Marks the session as backed up and restorable.

---
