# paleta-cart
General OT/ICS Topologies

Paleta-Cart is a collection of **small, general purpose OT/ICS lab topologies** meant for learning and hands-on exploration of:

- Common OT protocol communications
- Purdue Model concepts (Levels 0–4)
- Basic substation + control center architectures
- Gradually increasing complexity for experimentation and training

Each topology is designed to be simple enough to understand quickly, but realistic enough to be useful for demos, labs, and early-stage testing.

## Deployment options

These labs are designed to support two levels of deployment:

- **Phenix/Minimega (recommended):** full-fidelity OT network + VM-based environments that better match real segmentation and host behavior.
- **Docker Compose (lightweight):** a smaller, lightweight option for quick local use when you don’t want VMs. Best for protocol familiarity, service interaction, and basic traffic generation—less ideal for realistic routing, host boundaries, and certain network effects.

When both are provided, a topology folder may include:
- `topology.yaml` for Phenix/Minimega
- `docker-compose.yml` for the lightweight local version

## Topologies

### `minisub/`
A minimal **single-substation** topology focusing on Purdue Levels **0–2**.

Typical components:
- IEDs / relays
- RTU / PLC-style device
- Basic OT network segmentation

### `minisubcc/`
Builds on `minisub` by adding a simple **control center / aggregation layer** (Purdue Levels **2–3/4**).

Adds:
- Control center services (e.g., SCADA/HMI-like nodes, historian/sink, jump host, etc.)
- Clearer north/south traffic patterns and monitoring opportunities

### `subscc/`
A larger multi-substation environment feeding into a control center.

Useful for:
- Scaling traffic generation
- Visibility / monitoring exercises
- “How does this break at scale?” experiments

### `subsccder/`
Extends `subscc` with **DER-related components** (inverter / aggregator style patterns).

Useful for:
- Grid-edge visibility/control narratives
- DER protocol experiments and threat modeling
- Studying impacts across OT + IT boundaries

## Conventions

Most topologies follow a similar structure:

- `topology.yaml` (Phenix/Minimega topology definition)
- `docker-compose.yml` (Optional lightweight/local version of the lab)
- `injects/` (Files staged into VMs/containers, if applicable)
- `scripts/` (Helpers, bootstrap, traffic generation, test utilities)

## Getting started

Open a topology directory and follow any notes in its README (or the comments in `topology.yaml`) to deploy and run it.

## License

MIT — see `LICENSE`.

## Disclaimer

Provided for research/training use only. No warranty - use at your own risk.