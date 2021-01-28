include(CetMake)

# cmake will automatically order the library builds according to declared dependencies
add_subdirectory(Dictionaries)
add_subdirectory(Streamers)
add_subdirectory(Utilities)

cet_make_library(
  LIBRARY_NAME canvas_root_io
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
    ROOT::Core
    canvas::canvas
  PRIVATE
    CLHEP::CLHEP
    messagefacility::MF_MessageLogger
  )

# Testing
add_subdirectory(test)
