# ShaclForm-library

This repository is the **shared data library** for the DASH-GUI applications.
It contains all bricks, schemas, and ontologies that the apps read from and write to.
You do not need to install Python or any other programming tools — just Docker.

---

## Prerequisites: Install Docker

Docker must be installed and running before you can start the apps.
Installation scripts are provided in the `docker-setup/` folder:

| Platform | Script |
|----------|--------|
| Linux / Ubuntu | `docker-setup/install-docker-on-unix.sh` |
| macOS | `docker-setup/install-docker-mac.sh` |
| Windows | `docker-setup\install-docker-on-windows.ps1` |

Run the script for your platform once, then restart your computer if prompted.

---

## Running the Apps

The apps are pulled automatically from Docker Hub — no build step needed.
Each script starts the app, waits until it is ready, then opens your browser automatically.
Press **Ctrl+C** in the terminal to stop the app.

### Brick App (port 5001)

**Linux / macOS:**
```bash
./run-brick-from-hub.sh
```

**Windows (PowerShell):**
```powershell
.\run-brick-from-hub.ps1
```

Opens at: http://localhost:5001

---

### Schema App (port 5000)

**Linux / macOS:**
```bash
./run-schema-from-hub.sh
```

**Windows (PowerShell):**
```powershell
.\run-schema-from-hub.ps1
```

Opens at: http://localhost:5000

---

### Custom port (optional)

```bash
./run-brick-from-hub.sh 5010     # Linux/macOS
.\run-brick-from-hub.ps1 -Port 5010   # Windows
```

---

## Directory Structure

```
ShaclForm-library/
├── docker-setup/          # One-time Docker installation scripts
├── bricks/                # Brick definitions (reusable SHACL property shapes)
│   ├── default/           # General-purpose bricks
│   ├── battery_dpp/       # EV Battery Digital Product Passport bricks
│   ├── address_samples/   # sh:node composition examples
│   ├── company_example_v2/
│   ├── digipass_all/      # Full DigiPass brick collection
│   ├── physical_properties/
│   ├── templates/         # Example/template bricks
│   └── toy_dpp/           # Toy Digital Product Passport
├── schemas/               # Assembled schemas (JSON + Turtle + HTML form)
│   ├── default/
│   ├── battery_dpp/
│   ├── company_example/
│   └── toy_dpp/
├── ontologies/
│   └── cache/             # Ontology files used by the ontology browser
├── library_registry.json  # Library configuration
└── pattern_presets.json   # Regex pattern presets
```

Bricks and schemas are stored as both `.json` (app format) and `.ttl` (SHACL Turtle).
The apps read from and write to this directory via a Docker volume mount.

---

## Keeping the Library Up to Date

To pull the latest bricks, schemas, and scripts from GitHub:

```bash
git pull origin
```
