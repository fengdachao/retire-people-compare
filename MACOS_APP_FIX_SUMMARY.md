# macOS App Fix Summary

## Problem
The macOS bundled application (`CsvComparator.app`) was failing to launch with the following error:
```
java.lang.UnsatisfiedLinkError: Library not loaded: /opt/homebrew/opt/harfbuzz/lib/libharfbuzz.0.dylib
```

## Root Cause
The application was built with `jpackage` expecting harfbuzz to be installed in the standard Homebrew location (`/opt/homebrew`), but the user's Homebrew installation was in a custom location (`/Users/c-Dachao.Feng/homebrew`).

## Solution
Created a symbolic link to bridge the path mismatch:

1. **Created the expected directory structure:**
   ```bash
   sudo mkdir -p /opt/homebrew/opt/harfbuzz/lib
   ```

2. **Created a symbolic link from the actual location to the expected location:**
   ```bash
   sudo ln -sf /Users/c-Dachao.Feng/homebrew/lib/libharfbuzz.0.dylib /opt/homebrew/opt/harfbuzz/lib/libharfbuzz.0.dylib
   ```

## Verification
- ✅ App launches successfully via command line: `/Volumes/CsvComparator/CsvComparator.app/Contents/MacOS/CsvComparator`
- ✅ App opens properly via GUI: `open /Volumes/CsvComparator/CsvComparator.app`

## Technical Details
- **Library Path**: `/Users/c-Dachao.Feng/homebrew/lib/libharfbuzz.0.dylib` (actual)
- **Expected Path**: `/opt/homebrew/opt/harfbuzz/lib/libharfbuzz.0.dylib` (by jpackage)
- **Solution**: Symbolic link bridges the gap without requiring app rebuild

## Alternative Solutions (for future reference)
1. **Rebuild with correct Homebrew path**: Modify `jpackage` configuration to use the correct Homebrew prefix
2. **Use system-wide installation**: Install harfbuzz in the standard `/opt/homebrew` location
3. **Bundle dependencies**: Include harfbuzz library directly in the app bundle

## Status
✅ **RESOLVED** - The macOS bundled application now works correctly. 