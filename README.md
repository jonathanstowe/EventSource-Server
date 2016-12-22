# EventSource-Server

A simple handler to provide Server Sent Events from HTTP::Server::Tiny / Crust applications

## Synopsis

This sends out an event with the DateTime string every second

```perl6
use EventSource::Server;
use HTTP::Server::Tiny;

my $supply = Supply.interval(1).map( { EventSource::Server::Event.new(type => 'tick', data => DateTime.now.Str) } );

my &es = EventSource::Server.new(:$supply);



HTTP::Server::Tiny.new(port => 7798).run(&es)
```

And in some Javascript program somewhere else:

```javascript
var EventSource = require('eventsource');

var v = new EventSource(' http://127.0.0.1:7798');

v.addEventListener("tick", function(e) {
    console.info(e);

}, false);
```

## Description

This provides a simple mechanism for creating a source of [Server Sent Events](https://www.w3.org/TR/eventsource/) in a [HTTP::Server::Tiny](https://github.com/tokuhirom/p6-HTTP-Server-Tiny) server.






