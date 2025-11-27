# PyScript Vendor Directory

This directory contains the PyScript runtime files for local/offline use.

## Files

The PyScript distribution files are vendored here from the `@pyscript/core` npm package.
Key files include:

- **core.js** - ES module entry point (must be loaded with `type="module"`)
- **core.css** - Stylesheet for PyScript components
- **core-*.js** - Main runtime code
- Additional chunk files for features like xterm, codemirror, etc.

## How to Install/Update

Run the vendor script from the repository root:

```bash
./vendor_pyscript.sh
```

Or specify a version:

```bash
./vendor_pyscript.sh 0.4.21
```

The script will download the PyScript package from npm and extract the `dist/` folder here.

## Usage in HTML

Load PyScript as an ES module (to avoid "Unexpected token 'export'" errors):

```html
<link rel="stylesheet" href="./assets/pyscript/core.css" />
<script type="module" src="./assets/pyscript/core.js"></script>
```

**Important**: The `type="module"` attribute is required because PyScript uses ES modules.

## Why Use Local Files?

- **Reliability**: CDN outages or blocks won't affect your site
- **Performance**: Faster loading from same-origin resources  
- **No 404 errors**: Avoids issues with missing CDN files
- **Proper module loading**: Files are correctly served as ES modules

## Version

Current vendored version: **0.4.21** (from @pyscript/core npm package)
