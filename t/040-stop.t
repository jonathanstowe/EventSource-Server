#!/usr/bin/env raku

use Test;
use EventSource::Server;

my $e = EventSource::Server.new(supply => Supply.interval(1));

my $p = Promise.new;

$e.out-supply.tap( -> $ { }, quit => { $p.keep });

lives-ok { $e.stop }, "stop";
ok do { await $p }, "quit got called on out-supply";

done-testing;
# vim ft=raku
