# RV32I DSP SoC: RTL-to-GDSII ASIC Implementation

An end-to-end open-source ASIC physical design implementation of a custom **RISC-V (RV32I) Digital Signal Processing (DSP) System-on-Chip**. This repository features modular hardware description language (HDL) design, verification testbenches, automation scripts, and a fully completed, timing-closed, and DRC/LVS-verified physical design database utilizing the **SkyWater 130nm Open Source PDK** via **OpenLane**.

---

## 🏗️ Architecture & Directory Structure

The project follows a standard enterprise-grade semiconductor design layout:

```text
├── docs/               # Documentation and specifications
├── dv/                 # Design Verification
│   ├── assembly/       # Assembly test programs (boot.s, dsp_fir_test.s, mac_test.s)
│   ├── ref_model/      # Reference models for verification
│   └── tb/             # Testbenches (top_tb.v)
├── hw/                 # Hardware Source Code
│   ├── constraints/    # Synthesis and implementation constraints
│   └── rtl/            # RTL Implementation
│       ├── core/       # RV32I Core (decode, execute, fetch, hazard, regfile, top)
│       ├── dsp/        # DSP Coprocessor and Multiply-Accumulate (MAC) unit
│       └── soc/        # SoC Interconnect, instruction memory, and soc_top
├── openlane/           # OpenLane configurations, macro models, and run outputs
│   └── runs/           # Complete physical flow runs (including final signoff database)
└── scripts/            # Automation utilities (hex generators, log parsers, test runners)

```

---

## 📊 Physical Design Signoff Metrics

The ASIC flow targets the `sky130_fd_sc_hd` standard cell library, executing all 78 automated stages of the OpenLane flow—including floorplanning, pin placement, power distribution network (PDN) generation, global/detailed placement, clock tree synthesis (CTS), global/detailed routing, parasitic extraction (RCX), static timing analysis (STA), and physical verification (DRC/LVS via Magic and Netgen).

The final signoff results and layout assets are permanently stored under:
`openlane/runs/RUN_2026-07-27_08-21-11/final/`

* **Top-Level Entity:** `soc_top`
* **GDSII Stream:** `openlane/runs/RUN_2026-07-27_08-21-11/final/gds/soc_top.gds`
* **Extracted Netlists & SPEF:** Available across multi-corner PVT libraries (`max`, `min`, `nom`) in the `final/spef/`, `final/lib/`, and `final/nl/` directories.
* **Metrics Report:** Persistent summary metrics are logged in `openlane/runs/RUN_2026-07-27_08-21-11/final/metrics.csv` and `metrics.json`.

---

## 🛠️ Getting Started & Replication

### Prerequisites

Ensure your environment has access to:

* Linux Ubuntu (via WSL2 or native)
* OpenLane and OpenROAD toolchain
* Yosys, Magic, Netgen, and KLayout

### 1. Clone the Repository

```bash
git clone https://github.com/Srijit6/rv32i_dsp_soc.git
cd rv32i_dsp_soc

```

### 2. Inspect the Final Layout via KLayout

To view the completed physical layout database (`soc_top.gds`):

```bash
klayout openlane/runs/RUN_2026-07-27_08-21-11/final/gds/soc_top.gds

```

---

## 📝 License

This project is made available under open-source hardware guidelines.
