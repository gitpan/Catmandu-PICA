package PICA::Writer::Handle;
# ABSTRACT: Utility class that implements a filehandle attribute to write to
our $VERSION = '0.09'; # VERSION

use strict;
use Moo::Role;
use Scalar::Util qw(blessed openhandle);
use Carp qw(croak);

has fh => (
    is => 'rw', 
    isa => sub {
        local $Carp::CarpLevel = $Carp::CarpLevel+1;
        croak 'expect filehandle or object with method print!'
            unless defined $_[0] and openhandle($_[0])
            or (blessed $_[0] && $_[0]->can('print'));
    },
    default => sub { \*STDOUT }
);

sub write {
    my $self = shift;
    my $fh   = $self->fh;

    foreach my $record (@_) {
        $record = $record->{record} if ref $record eq 'HASH';
        $self->_write_record($record);
    }
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

PICA::Writer::Handle - Utility class that implements a filehandle attribute to write to

=head1 VERSION

version 0.09

=head1 AUTHOR

Johann Rolschewski <rolschewski@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Johann Rolschewski.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
