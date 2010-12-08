use strict;

use vars qw(%inc_translations);
BEGIN { %inc_translations = (
                             "MessageFacility/MessageLogger.h" => "messagefacility/MessageLogger/MessageLogger.h",
#                             "" => "",
                            );

      }
foreach my $inc (sort keys %inc_translations) {
  s&^(\s*#include\s+["<])\Q$inc\E([">].*)$&${1}$inc_translations{$inc}${2}& and last;
}

while (s/MessageFacility/messagefacility/g) {};

### Local Variables:
### mode: cperl
### End:
