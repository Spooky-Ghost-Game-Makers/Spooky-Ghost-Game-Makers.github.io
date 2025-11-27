# PyScript Vendor Directory

This directory should contain the PyScript runtime files for local/offline use.

## Required Files

To use the local PyScript bundle, download and place these files here:

1. **pyscript.js** - The UMD bundle (can be loaded without `type="module"`)
2. **pyscript.css** - The stylesheet

## How to Download

Download from the PyScript releases page:
- https://pyscript.net/releases/2024.1.1/pyscript.js
- https://pyscript.net/releases/2024.1.1/pyscript.css

Or use curl:
```bash
curl -L "https://pyscript.net/releases/2024.1.1/pyscript.js" -o pyscript.js
curl -L "https://pyscript.net/releases/2024.1.1/pyscript.css" -o pyscript.css
```

## Why Use Local Files?

- **Reliability**: CDN outages or blocks won't affect your site
- **Performance**: Faster loading from same-origin resources
- **Compatibility**: The UMD bundle avoids ES module loading issues

## Fallback Behavior

If the local files are not present, the `ghost_game_script.html` loader will automatically
fall back to loading PyScript from CDN sources with proper ES module handling.
