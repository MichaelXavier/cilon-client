cilon-client
============
cilon-client is a CLI utility for monitoring and interacting with 

Installation
------------
Just run `bundle install`.

Usage
-----
    bin/cilon-client http://yourcilonserver:1234

Known Issues
------------
1. Because color strings use escape characters, the last column in the text
table that shows statuses always looks a bit wonky. I don't really care enough
to fix it.

TODO
----
1. Set up a refresh interval.
2. Make a gem.
3. Fix the documentation. Commander can be kind of inflexible sometimes...
