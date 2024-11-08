set(WANT_XML_READRULES FALSE)
set(WANT_TCLASS_READRULES TRUE)

vertex_tests(11 b)

foreach(WRAPPED IN ITEMS "" "wrapped_")
  cet_test(${WRAPPED}vertex_v11_r_v10_b HANDBUILT
    TEST_EXEC ${CMAKE_CURRENT_BINARY_DIR}/${WRAPPED}vertex_v11b_reader
    TEST_ARGS ../../v10/${WRAPPED}vertex_v10_w.d/${WRAPPED}vertex_v10.root
    REQUIRED_FILES ../../v10/${WRAPPED}vertex_v10_w.d/${WRAPPED}vertex_v10.root
    REF ${CMAKE_CURRENT_SOURCE_DIR}/../vertex-ref.txt
    OUTPUT_FILTERS cetlib::filter-output
  )

  set_property(TEST ${WRAPPED}vertex_v11_r_v10_b PROPERTY
    ENVIRONMENT_MODIFICATION ROOT_LIBRARY_PATH=path_list_append:${CMAKE_CURRENT_BINARY_DIR}
    )

  set_property(TEST ${WRAPPED}vertex_v11_r_v10_b APPEND PROPERTY
    ENVIRONMENT ROOT_INCLUDE_PATH=${v11_ROOT_INCLUDE_PATH})

  set_property(TEST ${WRAPPED}vertex_v11_r_v10_b PROPERTY
    DEPENDS ${WRAPPED}vertex_v10_w)
endforeach()
