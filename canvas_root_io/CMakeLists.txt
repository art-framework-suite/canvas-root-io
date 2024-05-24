find_package(Boost COMPONENTS thread REQUIRED)
find_package(CLHEP COMPONENTS Matrix Vector REQUIRED)
find_package(ROOT COMPONENTS Core REQUIRED EXPORT)
find_package(canvas REQUIRED EXPORT)
find_package(cetlib REQUIRED EXPORT)
find_package(cetlib_except REQUIRED)
find_package(fhiclcpp REQUIRED)
find_package(messagefacility REQUIRED)

include(CetMake)

add_subdirectory(Dictionaries)
add_subdirectory(Streamers)
add_subdirectory(Utilities)

cet_make_library(HEADERS_TARGET
  SOURCE
    Streamers/setPtrVectorBaseStreamer.cc
    Streamers/TransientStreamer.cc
    Streamers/ProductIDStreamer.cc
    Streamers/BranchDescriptionStreamer.cc
    Streamers/CacheStreamers.cc
    Streamers/RefCoreStreamer.cc
    Utilities/DictionaryChecker.cc
    Utilities/getWrapperTIDs.cc
    Utilities/TypeWithDict.cc
    Utilities/TypeTools.cc
  LIBRARIES PUBLIC
    canvas::canvas
    cetlib::cetlib
    ROOT::Core
  PRIVATE
    messagefacility::MF_MessageLogger
    cetlib::container_algorithms
    cetlib_except::cetlib_except
    Boost::thread
)

# Testing
if (BUILD_TESTING)
  add_subdirectory(test)
endif()
