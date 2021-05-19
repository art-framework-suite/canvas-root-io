#include <vector>

#include "TClass.h"

int
main()
{
  auto const result [[maybe_unused]] = TClass::GetClass("std::vector<int>");
}
