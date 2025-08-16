# Additional CMake configuration for ydlidar_sdk_vendor

# Set paths for YDLIDAR SDK using find_package_dir
get_filename_component(_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_FILE}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)

# Set YDLIDAR SDK variables
set(YDLIDAR_SDK_INCLUDE_DIRS "${_IMPORT_PREFIX}/include")
set(YDLIDAR_SDK_LIBRARIES "${_IMPORT_PREFIX}/lib/libydlidar_sdk.so")

# Create imported target if it doesn't exist
if(NOT TARGET ydlidar_sdk::ydlidar_sdk)
  add_library(ydlidar_sdk::ydlidar_sdk SHARED IMPORTED)
  set_target_properties(ydlidar_sdk::ydlidar_sdk PROPERTIES
    IMPORTED_LOCATION "${YDLIDAR_SDK_LIBRARIES}"
    INTERFACE_INCLUDE_DIRECTORIES "${YDLIDAR_SDK_INCLUDE_DIRS}"
  )
endif()

# Set vendor package as found
set(ydlidar_sdk_vendor_FOUND TRUE)
set(YDLIDAR_SDK_FOUND TRUE)
