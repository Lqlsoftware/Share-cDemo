## DEMO of golang shared-c lib

### Dependency
- golang >= 1.10 (which support generate dll in windows)
- gcc/g++
- dotNET >= 3.0

### Quick start
```shell script
make all
```

### Build
Build lib for all arch of host (Windows, Linux, OSX), and C/C#-program. 
```shell script
make build
```

### Run
Run C-program and dotNET-program
```shell script
make run-demo-c run-demo-dotNET
```

### For windows
Win32 platform need some operate:

- Install msys2
```shell script
https://www.msys2.org/
```
- Install `mingw64/mingw-w64-x86_64-gcc` in `msys2-mingw64`
```shell script
pacman -S mingw64/mingw-w64-x86_64-gcc
```
- Export `go` and `dotnet` in `$PATH`
```shell script
export PATH=/c/go/bin:/c/Program\ Files/dotnet:$PATH
```
