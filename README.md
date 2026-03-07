# JupyterLite: Macaroons Tutorial

This repository contains an interactive tutorial for learning about **Macaroons** from first principles, built on JupyterLite.

## The Multi-Stage Learning Roadmap

The tutorial is structured as a multi-stage progression: starting with the raw bitwise logic of HMAC, moving to the Chaining of signatures, and ending with the Hierarchical Delegation and verification.

### Stage 1: The "Manual" HMAC Primitive
**Goal:** Understand why `Hash(Key+Message)` is insecure and implement the actual HMAC algorithm ($K \oplus opad$ and $K \oplus ipad$).
**Task:** Code a function that takes a secret key and a message, applies the two rounds of XOR padding, and returns a SHA-256 hash.

### Stage 2: The Macaroon "Mint"
**Goal:** Create the "Root Macaroon."
**Task:** Using your manual HMAC, sign a `token_id` (e.g., "Manager-Key-001") using a `master_secret`. This becomes `Signature0`.

### Stage 3: Recursive Attenuation (The Floor Manager)
**Goal:** Learn how to "shave down" the key without the original master secret.
**Task:** Pass `Signature0` to a new function that treats it as the key for a new HMAC, with the message `floor=1`. This produces `Signature1`.

### Stage 4: The Friend's Guest Pass
**Goal:** Deepen the chain.
**Task:** Use `Signature1` as the key for a third HMAC with the message `room=breakroom`. This creates `Signature2`.

### Stage 5: The "Door Lock" Verifier
**Goal:** Prove the integrity of the chain.
**Task:** Write a function that takes the `master_secret` and the list of caveats, re-calculates every HMAC in order, and asserts that the final result equals the Friend's `Signature2`.

### Stage 6: The "Attacker" Suite (Tests)
**Goal:** Attempt to break the system.
**Task:** Write tests for:
- **Deletion:** Does the signature fail if the user removes `floor=1`?
- **Reordering:** Does it fail if the user swaps the order of caveats?
- **Forging:** Can a user add `admin=true` without knowing the previous signature?

## Getting Started

This project is set up to deploy as a [JupyterLite](https://jupyterlite.readthedocs.io/) static site via GitHub Pages. Once deployed, anyone can open and run the notebook directly in their browser — no installation required.

### Try it online

> **`https://<your-username>.github.io/jupyterlite-macaroon/`**

Opening that URL will directly open the notebook and kick off the JupyterLite instance.

### Enable GitHub Pages

1. Push this repository to GitHub.
2. Go to **Settings → Pages**.
3. Set the source to **GitHub Actions**.
4. The included workflow (`.github/workflows/deploy.yml`) will automatically build and deploy on every push to `main`.

### Local development

```bash
pip install -r requirements.txt
jupyter lite build --contents content --output-dir dist
cp index.html dist/index.html
# Serve dist/ with any static file server, e.g.:
python -m http.server -d dist
```
