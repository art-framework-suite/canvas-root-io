# Set ROOT_FIXED_10271 to TRUE when the ROOT bug we're verifying is
# fixed. See
# https://sft.its.cern.ch/jira/projects/ROOT/issues/ROOT-10271 for
# details.
set(ROOT_FIXED_10271 FALSE CACHE BOOL "Whether we should expect all tests to succeed")

if (CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  # Using in (almost) standalone mode
  cmake_minimum_required(VERSION 3.11..3.14 FATAL_ERROR)
  project(io_rules_regression_tests VERSION 1.00.00 LANGUAGES CXX)

  # Find and use cetmodules.
  find_package(cetmodules
    1.03.00 REQUIRED # For build_dictionary supporting CLASSES_* opts.
    )
  include(CetCMakeEnv)
  cet_cmake_env()
  cet_set_compiler_flags(DIAGS VIGILANT
    WERROR NO_UNDEFINED
    EXTRA_CXX_FLAGS -Wnon-virtual-dtor -Wdelete-non-virtual-dtor)
  cet_report_compiler_flags()

  # Find and use ROOT.
  find_package(ROOT REQUIRED COMPONENTS)
  include_directories(${ROOT_INCLUDE_DIRS} ${ROOT_INCLUDE_DIRS}/ROOT)
  # Learn how to make dictionaries, executables, tests.
  include (BuildDictionary)
  include (CetMake)
  include (CetTest)
endif()

find_package(ROOT REQUIRED COMPONENTS Core GenVector Hist MathCore RIO Smatrix Tree)

set(VERTEX_SOURCE_IN_DIR ${CMAKE_CURRENT_SOURCE_DIR} CACHE STRING "Location of configurable Vertex source.")
set(VERTEX_SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR} CACHE STRING "Location of configured Vertex source.")

foreach(stem reader writer)
  set(WANT_WRAPPER)
  configure_file(${VERTEX_SOURCE_IN_DIR}/vertex_${stem}.cc.in ${VERTEX_SOURCE_DIR}/vertex_${stem}.cc @ONLY)
  set(WANT_WRAPPER TRUE)
  configure_file(${VERTEX_SOURCE_IN_DIR}/vertex_${stem}.cc.in ${VERTEX_SOURCE_DIR}/wrapped_vertex_${stem}.cc @ONLY)
endforeach()

function(configure_vertex VERTEX_VERSION)
  configure_file(${VERTEX_SOURCE_IN_DIR}/Vertex.h.in ${CMAKE_CURRENT_BINARY_DIR}/Vertex.h @ONLY)
  if (VERTEX_VERSION GREATER 10)
    set(VERTEX_IO_RULES
      "<ioread\n\
   version=\"[10]\"\n\
   sourceClass=\"arttest::Vertex\"\n\
   source=\"ROOT::Math::PositionVector3D<ROOT::Math::Cartesian3D<double>,ROOT::Math::GlobalCoordinateSystemTag> pos;\"\n\
   targetClass=\"arttest::Vertex\"\n\
   target=\"pos\"\n\
   include=\"Vertex.h\"\n\
   >\n\
  <![CDATA[\n\
       pos = arttest::Vertex::Point_t(onfile.pos.X(), onfile.pos.Y(), onfile.pos.Z());\n\
   ]]>\n\
  </ioread>\n\
  <ioread\n\
   version=\"[10]\"\n\
   sourceClass=\"arttest::Vertex\"\n\
   source=\"ROOT::Math::SMatrix<Coord_t,3,3,ROOT::Math::MatRepSym<Coord_t,3> > cov;\"\n\
   targetClass=\"arttest::Vertex\"\n\
   target=\"cov\"\n\
   include=\"Vertex.h\"\n\
   >\n\
  <![CDATA[\n\
       for (size_t i=0; i<3; ++i)
         for (size_t j=0; j<3; ++j)
           cov(i,j) = onfile.cov(i,j);
   ]]>\n\
  </ioread>\n")
    unset(VERTEX_POINT_T)
  else()
    set(VERTEX_POINT_T "<class name=\"arttest::Vertex::Point_t\"/>")
  endif()
  configure_file(${VERTEX_SOURCE_IN_DIR}/classes_def.xml.in ${CMAKE_CURRENT_BINARY_DIR}/classes_def.xml @ONLY)
endfunction()


set(WANTED_ROOT_LIBRARIES
  ${ROOT_Tree_LIBRARY}
  ${ROOT_Hist_LIBRARY}
  ${ROOT_RIO_LIBRARY}
  ${ROOT_Smatrix_LIBRARY}
  ${ROOT_GenVector_LIBRARY}
  ${ROOT_MathCore_LIBRARY}
  ${ROOT_Core_LIBRARY}
)

set(VERTEX_LIBRARIES
  art_root_io_test_io_rules_regression
  ${WANTED_ROOT_LIBRARIES})

function(vertex_tests VERTEX_VERSION)
  configure_vertex(${VERTEX_VERSION})
  include_directories(${VERTEX_SOURCE_IN_DIR} ${VERTEX_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})

  build_dictionary(DICT_NAME_VAR dictname NO_INSTALL
    CLASSES_DEF_XML ${CMAKE_CURRENT_BINARY_DIR}/classes_def.xml
    CLASSES_H ${CMAKE_CURRENT_SOURCE_DIR}/../classes.h)

  set_property(TARGET
    ${dictname}_dict
    PROPERTY LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

  set_property(TARGET
    checkClassVersion_${dictname}
    PROPERTY ENVIRONMENT
    LD_LIBRARY_PATH=$ENV{LD_LIBRARY_PATH}:${CMAKE_CURRENT_BINARY_DIR})

  foreach(WRAPPED "" "wrapped_")
    cet_make_exec(${WRAPPED}vertex_v${VERTEX_VERSION}_w
      SOURCE ${VERTEX_SOURCE_DIR}/${WRAPPED}vertex_writer.cc
      LIBRARIES ${VERTEX_LIBRARIES})

    cet_make_exec(${WRAPPED}vertex_v${VERTEX_VERSION}_r
      SOURCE ${VERTEX_SOURCE_DIR}/${WRAPPED}vertex_reader.cc
      LIBRARIES ${VERTEX_LIBRARIES})

    set_property(TARGET
      ${WRAPPED}vertex_v${VERTEX_VERSION}_w
      ${WRAPPED}vertex_v${VERTEX_VERSION}_r
      PROPERTY RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

    cet_test(${WRAPPED}vertex_v${VERTEX_VERSION}_w HANDBUILT
      TEST_EXEC ${CMAKE_CURRENT_BINARY_DIR}/${WRAPPED}vertex_v${VERTEX_VERSION}_w
      TEST_ARGS ${WRAPPED}vertex_v${VERTEX_VERSION}.root
      REMOVE_ON_FAILURE ${WRAPPED}vertex_v${VERTEX_VERSION}.root
      )

    cet_test(${WRAPPED}vertex_v${VERTEX_VERSION}_r HANDBUILT
      TEST_EXEC ${CMAKE_CURRENT_BINARY_DIR}/${WRAPPED}vertex_v${VERTEX_VERSION}_r
      TEST_ARGS ../${WRAPPED}vertex_v${VERTEX_VERSION}_w.d/${WRAPPED}vertex_v${VERTEX_VERSION}.root
      REQUIRED_FILES ../${WRAPPED}vertex_v${VERTEX_VERSION}_w.d/${WRAPPED}vertex_v${VERTEX_VERSION}.root
      REF ${CMAKE_CURRENT_SOURCE_DIR}/../vertex-ref.txt)

    set_property(TEST
      ${WRAPPED}vertex_v${VERTEX_VERSION}_w
      ${WRAPPED}vertex_v${VERTEX_VERSION}_r
      PROPERTY ENVIRONMENT
      LD_LIBRARY_PATH=$ENV{LD_LIBRARY_PATH}:${CMAKE_CURRENT_BINARY_DIR})

    set_property(TEST
      ${WRAPPED}vertex_v${VERTEX_VERSION}_r
      PROPERTY DEPENDS ${WRAPPED}vertex_v${VERTEX_VERSION}_w)
  endforeach()
endfunction()

cet_make_library(LIBRARY_NAME art_root_io_test_io_rules_regression
  SOURCE setupRoot.cc
  LIBRARIES ${WANTED_ROOT_LIBRARIES}
  NO_INSTALL)

# Schema evolution
add_subdirectory(v10)
add_subdirectory(v11)
