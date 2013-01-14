package main;
use strict;
use warnings;
use Dancer::Test;

use Test::More tests => 1;                      # last test to print

route_exists [GET => "/index.html"], "GET index.html is handled";

package test;

use base "Dancer::Routes";

sub main_page :GET("/index.html") {}
