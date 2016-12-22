use v6.c;

class EventSource::Server does Callable {
    class Event {
        has Str $.type;
        has Str $.data is required;
        method Str() returns Str {
            my $str = "";

            if $!type.defined {
                $str ~= "event: { $!type }\r\n";
            }
            $str ~= "data: { $!data }\r\n\r\n";

            $str;
        }

        method encode() returns Blob {
            self.Str.encode;
        }
    }

    has Supply   $!out-supply;
    has Supply   $.supply;
    has Supplier $.supplier;

    proto sub map-supply(|c) { * }

    multi sub map-supply(Event $e) returns Event {
        $e;
    }

    multi sub map-supply(Str $data) returns Event {
        Event.new(:$data);
    }

    multi sub map-supply($ (Str $type, Str $data)) returns Event {
        Event.new(:$type, :$data);
    }

    method out-supply() {
        $!out-supply //= Supply.merge(self.supplier.Supply, self.supply).map(&map-supply).map({ $_.encode });
    }

    # If we weren't supplied with a Supply then
    # we just use a no-op one
    method supply() returns Supply {
        $!supply //= supply { };
    }

    method supplier() returns Supplier handles <emit> {
        $!supplier //= Supplier.new;
    }


    method headers() {
        [
            Cache-Control   => 'must-revalidate, no-cache',
            Content-Type    => 'text/event-stream; charset=utf-8'
        ];
    }

    method CALL-ME(%env) {
        return 200, self.headers , self.out-supply;
    }
}

# vim: ft=perl6
