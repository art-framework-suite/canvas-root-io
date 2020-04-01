find_package(ROOT QUIET REQUIRED COMPONENTS Core Hist)

cet_test(aggregate_th1_t USE_BOOST_UNIT
  LIBRARIES
  canvas
  cetlib_except
  ROOT::Core
  ROOT::Hist)
