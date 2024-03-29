set(WANT_XML_READRULES FALSE)

vertex_tests(11)

foreach(WRAPPED IN ITEMS "" "wrapped_")
  cet_test(${WRAPPED}vertex_v11_r_v10_a HANDBUILT
    TEST_EXEC ${CMAKE_CURRENT_BINARY_DIR}/../v11/${WRAPPED}vertex_v11_reader
    TEST_ARGS ../../v10/${WRAPPED}vertex_v10_w.d/${WRAPPED}vertex_v10.root
    REQUIRED_FILES ../../v10/${WRAPPED}vertex_v10_w.d/${WRAPPED}vertex_v10.root
    REF ${CMAKE_CURRENT_SOURCE_DIR}/../vertex-ref.txt
    )

  set_property(TEST ${WRAPPED}vertex_v11_r_v10_a PROPERTY
    ENVIRONMENT ${varname_prefix}LD_LIBRARY_PATH=$ENV{${varname_prefix}LD_LIBRARY_PATH}:${CMAKE_CURRENT_BINARY_DIR}
    )

  set_property(TEST ${WRAPPED}vertex_v11_r_v10_a APPEND PROPERTY
    ENVIRONMENT ROOT_INCLUDE_PATH=${v11_ROOT_INCLUDE_PATH})

  set_property(TEST ${WRAPPED}vertex_v11_r_v10_a PROPERTY
    DEPENDS ${WRAPPED}vertex_v10_w)

  if (NOT ROOT_FIXED_DOUBLE32T)
    set_property(TEST ${WRAPPED}vertex_v11_r_v10_a
      PROPERTY WILL_FAIL TRUE)
  endif()
endforeach()
