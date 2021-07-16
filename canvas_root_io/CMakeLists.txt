find_package(Boost PRIVATE COMPONENTS headers thread REQUIRED)
find_package(CLHEP PRIVATE COMPONENTS Matrix Vector REQUIRED)
find_package(ROOT COMPONENTS Core REQUIRED PUBLIC)
find_package(canvas REQUIRED PUBLIC)
find_package(cetlib REQUIRED PUBLIC)
find_package(cetlib_except PRIVATE REQUIRED)
find_package(fhiclcpp PRIVATE REQUIRED)
find_package(hep_concurrency REQUIRED PUBLIC)
find_package(messagefacility PRIVATE REQUIRED)

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
  LIBRARIES
    canvas::canvas
    cetlib::cetlib
    hep_concurrency::hep_concurrency
    ROOT::Core
  PRIVATE
    messagefacility::MF_MessageLogger
    cetlib::container_algorithms
    cetlib_except::cetlib_except
    Boost::thread
)

# Testing
add_subdirectory(test)
