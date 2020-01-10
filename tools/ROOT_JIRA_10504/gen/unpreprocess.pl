use strict;
our ($swallow, $current_inc, $wanted_inc, $gcctop);

BEGIN {
  $swallow = 0;
  $wanted_inc = '';
  $gcctop = `gcc --print-search-dirs | grep -e '^install' | cut -d' ' -f 2 | sed -e 's&/bin/\\.\\..*\$&&'`;
  chomp $gcctop;
  print STDERR "gcctop = $gcctop\n";
}

my ($inc, $flags) = m&^#[\s\d]+"(.*?)"\s*([\d\s]*)$&;
if ($inc) {
  $current_inc = $inc if $. == 1;
  die "INTERNAL ERROR: unable to ascertain current file"
    unless $current_inc;
  my @flags=split(' ',${2});
  if ($swallow and $inc eq $wanted_inc) { # File we intend to return to.
    if (returning(@flags)) {
      print STDERR "< Leaving $current_inc for $wanted_inc\n";
      $swallow = 0;
      $current_inc = $wanted_inc;
      $wanted_inc = '';
      next; # Skip this line to avoid confusing preprocessor.
    } elsif (entering(@flags)) {
      die "INTERNAL ERROR: don't know how to deal with recursive entry while skipping!";
    }
  } elsif ($swallow == 0) {
    my ($skip_inc) = ($inc =~ m&^(?:/include|/usr/include/|\Q${gcctop}/include/c++/\E.*?/)(.*)$&);
    if ($skip_inc and entering(@flags)) { # Entering file to skip
      ++$swallow;
      $wanted_inc = $current_inc; # File to return to;
      print STDERR "> Entering $inc from $current_inc\n";
      if (extern_c(@flags)) {
        print "extern \"C\" {\n";
      }
      printf '#include <%s>%s', ${skip_inc}, "\n";
      if (extern_c(@flags)) {
        print "}\n";
      }
    }
  }
  $current_inc = $inc;
}
$swallow > 0 or print;
1;

sub entering {
  return grep {$_ == 1} @_;
}

sub returning {
  return grep {$_ == 2} @_;
}

sub system_inc {
  return grep {$_ == 3} @_;
}

sub extern_c {
  return grep {$_ == 4} @_;
}
