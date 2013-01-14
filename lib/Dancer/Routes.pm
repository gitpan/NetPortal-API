package Dancer::Routes;
use strict;
use warnings;
use base "Class::Accessor::Fast";
require Dancer;

sub AUTOLOAD {
    my $self = shift;
    our $AUTOLOAD;
    my ($method) = $AUTOLOAD =~/\:\:([^\:]+)$/;
    $method = lc $method if $method =~/(?:GET|POST|PUT|DEL|OPTIONS|ANY|HOOK)/;
    if (my $code = UNIVERSAL::can(Dancer => $method)) {
        my $subroutine = $_;
        if ($subroutine && UNIVERSAL::isa($subroutine, "CODE")) {
            $code->(@_, sub {$self->new->$subroutine(@_)});
        }
        elsif ($#_ != -1) {
            $code->(@_);
        }
        else {
            $code->();
        }
    }
    else {
        die Carp::longmess("Unknown Dancer Method $method \@ $self.");
    }
}

sub MODIFY_CODE_ATTRIBUTES {
    my $class = shift;
    my $code = shift;
    my @bad = ();
    foreach my $method(@_) {
        local $_ = $code;
        eval "package $class; $class->$method";
        push @bad, "$method: $@" if $@;
    }
    return @bad;
}

sub DESTROY {}

1;

__END__

=head1 NAME

Dancer::Routes - Object base class for any Dancer Routes

=head 1 SYNOPSIS

package MyApp::Dashboard;

use base "Dancer::Routes";

sub main_page :GET("/") :GET(qr/^\/index/) {
    my $self = shift;
    $self->template("dashboard");
}

1;

=head1 DESCRIPTION

We can write our dancer route module in Object-oriented programming style.

=head1 AUTHOR

Michael Vu

=head1 LICENSE AND COPYRIGHT

Copyright 2009-2010 Michael Vu

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
