cmake_minimum_required(VERSION 3.16...3.22)
project(ydlidar_sdk_vendor)

# Default to C++17
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# Find dependencies
find_package(ament_cmake REQUIRED)

# Check if YDLIDAR SDK is already installed on the system
find_path(YDLIDAR_SDK_INCLUDE_DIR ydlidar_sdk/YDLidarDriver.h
  PATHS
  /usr/include
  /usr/local/include
  ${CMAKE_INSTALL_PREFIX}/include
)

find_library(YDLIDAR_SDK_LIBRARY 
  NAMES ydlidar_sdk libydlidar_sdk
  PATHS
  /usr/lib
  /usr/local/lib
  ${CMAKE_INSTALL_PREFIX}/lib
)

if(YDLIDAR_SDK_INCLUDE_DIR AND YDLIDAR_SDK_LIBRARY)
  message(STATUS "Found YDLIDAR SDK: ${YDLIDAR_SDK_LIBRARY}")
  
  # Create imported target for system-installed YDLIDAR SDK
  add_library(ydlidar_sdk::ydlidar_sdk UNKNOWN IMPORTED)
  set_target_properties(ydlidar_sdk::ydlidar_sdk PROPERTIES
    IMPORTED_LOCATION "${YDLIDAR_SDK_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${YDLIDAR_SDK_INCLUDE_DIR}"
  )
  
  # Install found library info
  set(YDLIDAR_SDK_FOUND TRUE)
  
else()
  message(STATUS "YDLIDAR SDK not found on system, attempting to build from source")
  
  include(ExternalProject)
  
  # Set installation prefix
  set(YDLIDAR_SDK_INSTALL_PREFIX ${CMAKE_CURRENT_BINARY_DIR}/ydlidar_sdk_install)
  
  # Try to download and build YDLIDAR SDK with error handling
  ExternalProject_Add(ydlidar_sdk_external
    GIT_REPOSITORY https://github.com/YDLIDAR/YDLidar-SDK.git
    GIT_TAG master
    GIT_SHALLOW TRUE
    TIMEOUT 60
    
    # Configure step
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX=${YDLIDAR_SDK_INSTALL_PREFIX}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_CXX_STANDARD=17
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_EXAMPLES=OFF
      -DBUILD_TESTING=OFF
      -Wno-dev
      -DCMAKE_WARN_DEPRECATED=OFF
    
    # Build step
    BUILD_COMMAND ${CMAKE_COMMAND} --build . --parallel
    
    # Install step
    INSTALL_COMMAND ${CMAKE_COMMAND} --build . --target install
    
    # Logging - only log errors to avoid noise
    LOG_DOWNLOAD OFF
    LOG_CONFIGURE OFF
    LOG_BUILD OFF
    LOG_INSTALL OFF
    LOG_MERGED_STDOUTERR ON
    LOG_OUTPUT_ON_FAILURE ON
  )
  
  # Create imported target for built YDLIDAR SDK
  add_library(ydlidar_sdk::ydlidar_sdk SHARED IMPORTED)
  set_target_properties(ydlidar_sdk::ydlidar_sdk PROPERTIES
    IMPORTED_LOCATION "${YDLIDAR_SDK_INSTALL_PREFIX}/lib/libydlidar_sdk${CMAKE_SHARED_LIBRARY_SUFFIX}"
    INTERFACE_INCLUDE_DIRECTORIES "${YDLIDAR_SDK_INSTALL_PREFIX}/include"
  )
  
  # Ensure the external project is built before the imported target is used
  add_dependencies(ydlidar_sdk::ydlidar_sdk ydlidar_sdk_external)
  
  # Install the built library
  install(DIRECTORY ${YDLIDAR_SDK_INSTALL_PREFIX}/
    DESTINATION .
    USE_SOURCE_PERMISSIONS
    PATTERN "*.cmake" EXCLUDE
  )
  
  set(YDLIDAR_SDK_FOUND TRUE)
endif()

# Set exported variables in CMake scope
set(YDLIDAR_SDK_INCLUDE_DIRS "${CMAKE_INSTALL_PREFIX}/include")
set(YDLIDAR_SDK_LIBRARIES "${CMAKE_INSTALL_PREFIX}/lib/libydlidar_sdk.so")

# Generate config files
include(CMakePackageConfigHelpers)
configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/ydlidar_sdk_vendor-config.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/ydlidar_sdk_vendor-config.cmake"
  INSTALL_DESTINATION share/${PROJECT_NAME}/cmake
)

write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/ydlidar_sdk_vendor-config-version.cmake"
  VERSION 1.0.0
  COMPATIBILITY SameMajorVersion
)

install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/ydlidar_sdk_vendor-config.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/ydlidar_sdk_vendor-config-version.cmake"
  DESTINATION share/${PROJECT_NAME}/cmake
)

# Environment hooks
ament_environment_hooks("${CMAKE_CURRENT_SOURCE_DIR}/env_hook/ydlidar_sdk_vendor.sh.in")

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  set(ament_cmake_copyright_FOUND TRUE)
  set(ament_cmake_cpplint_FOUND TRUE)
  ament_lint_auto_find_test_dependencies()
endif()

# Export dependencies
ament_export_dependencies()

ament_package(
  CONFIG_EXTRAS cmake/ydlidar_sdk_vendor-extras.cmake
)
