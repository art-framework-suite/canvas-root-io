find_package(ROOT PRIVATE COMPONENTS Core Hist REQUIRED)
find_package(canvas PRIVATE REQUIRED)

cet_test(aggregate_th1_t USE_BOOST_UNIT
  LIBRARIES
  canvas::canvas
  ROOT::Core
  ROOT::Hist)
