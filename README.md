# YDLIDAR SDK Vendor Package

A vendor package for using YDLIDAR SDK in ROS2 projects.

## Overview

This package manages YDLIDAR SDK as an external dependency and simplifies its usage in ROS2 workspaces.

## Features

- **Automatic dependency management**: Uses system-installed YDLIDAR SDK if available, otherwise builds from source
- **CMake integration**: YDLIDAR SDK can be used through CMake's find_package() mechanism
- **Environment setup**: Automatically configures necessary environment variables

## Usage

### 1. Building the Package

```bash
cd /path/to/your/workspace
colcon build --packages-select ydlidar_sdk_vendor
```

### 2. Using in Other Packages

Add dependency to `package.xml`:

```xml
<depend>ydlidar_sdk_vendor</depend>
```

Find the package in `CMakeLists.txt`:

```cmake
find_package(ydlidar_sdk_vendor REQUIRED)

# Link to target
target_link_libraries(your_target ydlidar_sdk::ydlidar_sdk)
```

### 3. Using in C++ Code

```cpp
#include <ydlidar_sdk/YDLidarDriver.h>

// Use YDLIDAR SDK features
```

## Operation Modes

### Automatic Mode (Default)

- Automatically detects if YDLIDAR SDK is installed on the system
- If not found, checks network connectivity to GitHub
- **Online**: Downloads and builds from GitHub source automatically
- **Offline**: Creates dummy target to prevent build failures

## Offline Building

No special options required! The package automatically detects network availability.

### Method 1: Pre-install YDLIDAR SDK (Recommended)

Install YDLIDAR SDK system-wide (requires internet for initial setup):

```bash
# Download YDLIDAR SDK source (when online)
git clone https://github.com/YDLIDAR/YDLidar-SDK.git
cd YDLidar-SDK

# Build and install
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON
make -j$(nproc)
sudo make install
```

### Method 2: Manual File Placement

Place YDLIDAR SDK files in expected locations:

- Headers: `/usr/local/include/ydlidar_sdk/`
- Library: `/usr/local/lib/libydlidar_sdk.so`

## Building

Simple build command works in both online and offline environments:

```bash
colcon build --packages-select ydlidar_sdk_vendor
```

## Troubleshooting

### Network Resolution Errors

Network errors are automatically handled. No manual intervention required.
The package will:

1. First check for system-installed YDLIDAR SDK
2. If not found, test network connectivity
3. Build from source if online, create dummy target if offline

### Limited Functionality Warning

When building offline without pre-installed SDK, a dummy target is created with limited functionality. To restore full functionality, install YDLIDAR SDK manually using the methods above.

## Dependencies

- CMake 3.16+
- Git (for source build, when online)
- C++17 compatible compiler

## License

This vendor package is provided under the Apache 2.0 License.
For the YDLIDAR SDK license, please refer to the [official repository](https://github.com/YDLIDAR/YDLidar-SDK).
