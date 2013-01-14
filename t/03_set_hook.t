use strict;
use warnings;
use Test::More tests => 1;                      # last test to print
use Dancer::Test;

response_content_is [GET => "/"], "Michael Vu";

package test;
use base "Dancer::Routes";
sub login :HOOK("before") {
    my $self = shift;
    $self->var(login => "Michael Vu");
}

sub info :GET("/") {
    my $self = shift;
    return $self->var("login");
}
