# rename-photos

Batch-rename photos in Mac OS.

## How to run

Make it executable

```bash
chmod +x ./rp.sh
```

Run in dry mode to check whether the new filenames are coming out correct:

```bash
./rp.sh -d path/to/photos/*.psd
```

Then go for it:

```bash
./rp.sh path/to/photos/*.psd
```

## Paths

### Rename all HEIC (\*.heic)files in the current folder

```bash
./rp.sh
```

The glob \*.heic is hardcoded, feel free to edit the script if your target format is different.

### Rename all HEIC (\*.heic) files in a folder

```bash
./rp.sh path/to/folder
```

### Rename files on path

```bash
./rp.sh path/to/folder/*.{psd,heic}
```

This is the option I go to most often. Allows hand-picking files and mixes well with Cmd+Option+C hotkey (copy path to file/folder) in Finder in Mac OS.

