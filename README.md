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

### Running `minisub` and `minisubcc` on phenix

The field devices run [OT-sim](https://github.com/patsec/ot-sim) inside the
`fielddev` image. Their configs live in each topology's `injects/` folder.

1. Build the image, then add the minimega agent (phenix's `vmdb2` builds don't
   include it):

   ```sh
   phenix config create images/fielddev.yml
   phenix image build fielddev
   phenix image inject-miniexe /opt/minimega/bin/miniccc /phenix/images/fielddev.qc2
   ```

2. Copy the topology folder (with its `injects/`) somewhere phenix can read,
   for example `/phenix/topologies/minisubcc/`. Then create the experiment
   **with that folder as its base directory**, because injection `src` paths
   are relative to it:

   ```sh
   phenix config create /phenix/topologies/minisubcc/topology.yaml
   phenix experiment create minisubcc --topology minisubcc -d /phenix/topologies/minisubcc
   phenix experiment start minisubcc
   ```

   Without `-d`, phenix looks in `/phenix/experiments/<name>/` and the start
   fails with `cp: cannot stat ... injects/...`.

What to expect once the VMs boot (about a minute):

| Device | Address | What it does |
|---|---|---|
| `ied1`–`ied4` | 10.10.10.11–.14 | Feeder relays. Modbus TCP 502: coil 0 = breaker (write 0 to trip, 1 to close); input registers 30001 kV (x100), 30002 A (x10), 30003 kW |
| `rtu` | 10.10.10.10, 192.168.10.2 | Polls the IEDs over Modbus every 2 s; DNP3 outstation on TCP 20000 (outstation 1024, master 1). Binary inputs 0–3 = breakers, binary outputs 10–13 operate them, analog inputs 0–11 = kV, A, kW |
| `cc` (minisubcc) | 192.168.10.1 | DNP3 master polling the RTU every 5 s, plus a local Modbus view of the same points: coils 0–3 = breakers, inputs 30001–30012 = kV, A, kW |

Try it from `cc`: `mbpoll -0 -1 -t 0 -r 1 127.0.0.1 0` trips feeder 2 through
DNP3 (the RTU writes the IED's breaker coil); `... 1` closes it again.

OT-sim note: put any XML comment *inside* the `<ot-sim>` root. The DNP3 module
rejects a comment placed before the root element ("missing root 'ot-sim'
element"), although the other modules accept it.

## License

MIT — see `LICENSE`.

## Disclaimer

Provided for research/training use only. No warranty - use at your own risk.