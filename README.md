# TheToolchain
The cross-compiler toolchain for the [TheTaaJ](https://github.com/TheJaat/TheTaaJ) a lightweight hobby operating system in development.

## Architecture
x86_32 Bit.

## Build
```bash
sudo bash toolchain_i686.sh
```

## Export the Path
1. Open your `.bashrc` file in a text editor:
```bash
nano ~/.bashrc
```
2. Add the following lines at the end of the file to export the toolchain path:
```bash
# Add i686 toolchain to PATH
TOOLCHAIN_PATH="$HOME/path_to_toolchain_repo/i686/bin"
if [[ ":$PATH:" != *":$TOOLCHAIN_PATH:"* ]]; then
    export PATH="$TOOLCHAIN_PATH:$PATH"
fi
```
3. Save and close the file (in `nano`, press `Ctrl+O` to save, then `Ctrl+X` to exit).
4. Apply the changes by reloading your `.bashrc`:
```bash
source ~/.bashrc
```
5. Verify the path was added:
```bash
echo $PATH
```
