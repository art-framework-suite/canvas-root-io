#ifndef canvas_root_io_test_Utilities_RootClassMapping_t_h
#define canvas_root_io_test_Utilities_RootClassMapping_t_h

#include "TBuffer.h"
#include "TClass.h"
#include "TClassRef.h"
#include "TClassStreamer.h"

#include <ostream>
#include <vector>

template <typename A, typename B>
class TestProd {
public:
  TestProd() : data() {}
  std::vector<size_t> data;
};

template <typename A, typename B>
class TestProdStreamer : public TClassStreamer {
public:
  TestProdStreamer(std::ostream& os) : os_(os) {}

  void
  operator()(TBuffer& R_b, void* objp)
  {
    static TClassRef cl(TClass::GetClass(typeid(TestProd<A, B>)));
    TestProd<A, B>* obj = reinterpret_cast<TestProd<A, B>*>(objp);
    if (R_b.IsReading()) {
      os_ << "Attempting to read stored object as a " << cl->GetName() << ".\n";
      cl->ReadBuffer(R_b, obj);
    } else {
      os_ << "Attempting to write a " << cl->GetName() << ".\n";
      cl->WriteBuffer(R_b, obj);
    }
  }

private:
  std::ostream& os_;
};

#endif /* canvas_root_io_test_Utilities_RootClassMapping_t_h */

// Local Variables:
// mode: c++
// End:
