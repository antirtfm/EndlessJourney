# Endless Journey

Game built with [Felgo](https://felgo.com) (Qt 6), created for the Felgo one-week challenge.

## Build

Install the Felgo SDK first: https://felgo.com/download

Then either open `CMakeLists.txt` in Qt Creator and pick the `felgo` preset when asked,
or build from the command line:

```
cmake --preset felgo
cmake --build --preset felgo
```

The preset assumes the default Felgo install location (`C:\Felgo`) — adjust
`CMakePresets.json` if you installed elsewhere.


