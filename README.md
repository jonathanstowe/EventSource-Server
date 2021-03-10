# EventSource::Server

A simple handler to provide Server Sent Events from Raku applications

![Build Status](https://github.com/jonathanstowe/EventSource-Server/workflows/CI/badge.svg)

## Synopsis

This sends out an event with the DateTime string every second

```raku
use EventSource::Server;
use HTTP::Server::Tiny;

my $supply = Supply.interval(1).map( { EventSource::Server::Event.new(type => 'tick', data => DateTime.now.Str) } );

my &es = EventSource::Server.new(:$supply);



HTTP::Server::Tiny.new(port => 7798).run(&es)
```

Or using Cro:

```raku
use EventSource::Server;

use Cro::HTTP::Router;
use Cro::HTTP::Server;

my $supply = Supply.interval(1).map( { EventSource::Server::Event.new(type => 'tick', data => DateTime.now.Str) } );

my $es = EventSource::Server.new(:$supply);

my $app = route {
    get -> {
        content 'text/event-stream', $es.out-supply;
    }
};

my Cro::Service $tick = Cro::HTTP::Server.new(:host<localhost>, :port<7798>, application => $app);

$tick.start;

react whenever signal(SIGINT) { $tick.stop; exit; }
```

And in some Javascript program somewhere else:

```javascript
var EventSource = require('eventsource');

var v = new EventSource(' http://127.0.0.1:7798');

v.addEventListener("tick", function(e) {
    console.info(e);

}, false);
```

See also the [examples directory](examples) in this distribution.

## Description

This provides a simple mechanism for creating a source of [Server Sent Events](https://www.w3.org/TR/eventsource/) in a
web server application.

The EventSource interface is implemented by  most modern web browsers and
provides a lightweight alternative to Websockets for those applications
where only a uni-directional message is required (for example for
notifications,)

## Installation

<<<<<<< HEAD
Assuming you have a working installation of Rakudo with ```zef```
installed then you should be able to install this with:
=======
Assuming you have a working installation of Rakudo with `zef` installed then you should be able to install this with:
>>>>>>> 32c9fda... Add support for multi-line data

    zef install EventSource::Server

If you want to install this from a local copy substitute the distribution
name for the path to the local copy.

## Support

This is quite a simple module but is fairly difficult to test well without
bringing in a vast array of large and otherwise un-needed modules, so
I won't be surprised there are bugs, similarly whilst I have tested for
interoperability with the Javascript hosts that I have available to me
I haven't tested against every known host that provides the EventSource
interface.

So please feel free to report any problems (or make suggestions,) to
https://github.com/jonathanstowe/EventSource-Server/issues

## Copyright and Licence

This is free software, please see the [LICENCE](LICENCE) file in the
distribution.

© Jonathan Stowe 2017 - 2021
