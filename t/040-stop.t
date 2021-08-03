#!/usr/bin/env raku

use Test;
use EventSource::Server;

my $*SCHEDULER = CurrentThreadScheduler.new;

my $e = EventSource::Server.new( supply => (^10).Supply);

my $p = Promise.new;

$e.out-supply.act( -> $ { }, quit => { $p.keep });

lives-ok { $e.stop }, "stop";

ok do { await $p }, "quit got called on out-supply";

done-testing;
# vim ft=raku
