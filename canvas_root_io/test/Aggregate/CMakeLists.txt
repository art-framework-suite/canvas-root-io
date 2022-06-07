find_package(ROOT COMPONENTS Core Hist REQUIRED)
find_package(canvas REQUIRED)

cet_test(aggregate_th1_t USE_BOOST_UNIT
  LIBRARIES
  canvas::canvas
  ROOT::Core
  ROOT::Hist)
