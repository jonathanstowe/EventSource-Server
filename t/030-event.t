#!/usr/bin/env raku

use v6;

use Test;

use EventSource::Server;

my $event = EventSource::Server::Event.new(type => 'foo', data => "a\nb\nc");

is $event.Str, "event: foo\r\ndata: a\r\ndata: b\r\ndata: c\r\n\r\n", "got the expected data";

done-testing();
