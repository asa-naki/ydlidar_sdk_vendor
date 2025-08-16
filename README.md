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

### System Installation Detection Mode

If YDLIDAR SDK is already installed on the system, it will be used.

### Source Build Mode

If YDLIDAR SDK is not found on the system, it automatically downloads source code from GitHub and builds it.

## Dependencies

- CMake 3.16+
- Git (for source build)
- C++17 compatible compiler

## License

This vendor package is provided under the Apache 2.0 License.
For the YDLIDAR SDK license, please refer to the [official repository](https://github.com/YDLIDAR/YDLidar-SDK).

## Troubleshooting

### Build Errors

1. **Git not found**: Ensure Git is installed
2. **Network issues**: Check your internet connection. If network errors occur, ExternalProject will automatically detect failures and display appropriate error messages
3. **Compiler errors**: Ensure you are using a C++17 compatible compiler

### Runtime Errors

1. **Library not found**: Ensure the environment is sourced:

   ```bash
   source install/setup.bash
   ```

2. **Network timeout**: If the network is slow, timeouts may occur. Try building again or manually install the SDK on your system

## Related Packages

- `ydlidar_ros2_driver`: ROS2 driver for YDLIDAR (can use this vendor package)
