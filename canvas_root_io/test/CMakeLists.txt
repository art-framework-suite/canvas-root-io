cet_enable_asserts()

# Make sure tests have correct environment settings.
include(CetTest)
# If you explicitly include CetTest in a subdirectory, you will need to
# re-initialize the test environment.
cet_test_env("FHICL_FILE_PATH=.")

# Put everything in a different export set.
cet_register_export_set(SET_NAME Testing NAMESPACE canvas_root_io_test SET_DEFAULT)

add_subdirectory(Aggregate)
add_subdirectory(Utilities)
add_subdirectory(io-rules-regression)
