# NAME

Catalyst::Controller::LeakTracker - Inspect leaks found by [Catalyst::Plugin::LeakTracker](https://metacpan.org/pod/Catalyst::Plugin::LeakTracker)

# SYNOPSIS

    # in MyApp.pm

        package MyApp;

        use Catalyst qw(
                LeakTracker
        );

        #### in SomeController.pm

        package MyApp::Controller::Leaks;
    use Moose;

    use parent qw(Catalyst::Controller::LeakTracker);

    sub index :Path :Args(0) {
        my ( $self, $c ) = @_;
        $c->forward("list_requests"); # redirect to request listing view
    }

# DESCRIPTION

This controller uses [Catalyst::Controller::LeakTracker](https://metacpan.org/pod/Catalyst::Controller::LeakTracker) to display leak info
on a per request basis.

# ACTIONS

- list\_requests

    List the leaking requests this process has handled so far.

    If the `all` parameter is set to a true value, then all requests (even non
    leaking ones) are listed.

- request $request\_id

    Detail the leaks for a given request, and also dump the event log for that request.

- object $request\_id $event\_id

    Detail the object created in $event\_id.

    Displays a stack dump, a [Devel::Cycle](https://metacpan.org/pod/Devel::Cycle) report, and a [Data::Dumper](https://metacpan.org/pod/Data::Dumper) output.

    If the `maxdepth` param is set, `$Data::Dumper::Maxdepth` is set to that value.

- make\_leak \[ $how\_many \]

    Artificially leak some objects, to make sure everything is working properly

# CAVEATS

In forking environments each child will have its own leak tracking. To avoid
confusion run your apps under the development server or temporarily configure
fastcgi or whatever to only use one child process.

# TODO

This is yucky example code. But it's useful. Patches welcome.

- [Template::Declare](https://metacpan.org/pod/Template::Declare)

    Instead of yucky HTML strings

- CSS

    I can't do that well, I didn't bother trying

- Nicer displays

        <pre> ... </pre>

    Only goes so far...

    The event log is in most dire need for this.

- Filtering, etc

    Of objects, requests, etc. Javascript or serverside, it doesn't matter.

- JSON/YAML/XML feeds

    Maybe it's useful for someone.

# MINI-TUTORIAL

## Why use LeakTracker?

You have a Catalyst application that is consuming more and more
memory over time.  You would like to find out what classes are
involved and where you may have cyclic references.

## How to use LeakTracker?

Once you've plugged LeakTracker into your Catalyst application 
(see ["SYNOPSIS"](#synopsis)), then you can easily get statistics via 
Catalyst::Controller::LeakTracker. Just create a new controller exclusively
for reporting on the objects that are not being garbage collected.  
Here is how:

        package MyAss::Controller::Leaks;
        
        sub BEGIN {
                use Moose;
                extends 'Catalyst::Controller::LeakTracker';
        }
        
        # redirect leaks/ to the report about memory consumed by each request
        sub index : Path : Args(0) {
                my ( $self, $c ) = @_;
                $c->forward("list_requests");  
        }
        
        1
        

In effect, the controller above turns the URI `$c.request.base/leaks` 
into a report on the objects that still have references to them, and 
thus consuming memory.

## How to Interpret the Results?

The results found at **leaks/** are _per request_.  The results include 
the Catalyst actions requested and how much memory each consumed.  One can 
"drill-down" on the request ID and get a report of all objects that the request
has left lingering about.  It's tits, try it out for yourself.

## When to Not Use LeakTracker?

In Production, because it adds a significant amount of overhead 
to your application.

# SEE ALSO

[Devel::Events](https://metacpan.org/pod/Devel::Events), [Catalyst::Plugin::LeakTracker](https://metacpan.org/pod/Catalyst::Plugin::LeakTracker),
[http://blog.jrock.us/articles/Plugging%20a%20leaky%20whale.pod](http://blog.jrock.us/articles/Plugging%20a%20leaky%20whale.pod),
[Devel::Size](https://metacpan.org/pod/Devel::Size), [Devel::Cycle](https://metacpan.org/pod/Devel::Cycle)

# AUTHOR

Yuval Kogman <nothingmuch@woobling.org>

# CONTRIBUTORS

Mateu X. Hunter <hunter@missoula.org>

Wallace Reis <wreis@cpan.org>

# COPYRIGHT & LICENSE

        Copyright (c) Yuval Kogman. All rights reserved
        This program is free software; you can redistribute it and/or modify it
        under the terms of the MIT license or the same terms as Perl itself.
