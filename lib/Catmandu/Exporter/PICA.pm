package Catmandu::Exporter::PICA;
#ABSTRACT: Package that exports PICA data
our $VERSION = '0.08'; #VERSION

use Catmandu::Sane;
use PICA::Writer::Plus;
use PICA::Writer::Plain;
use PICA::Writer::XML;
use Moo;

with 'Catmandu::Exporter';

has type   => ( is => 'rw', default => sub { 'xml' } );
has writer => ( is => 'lazy' );

sub _build_writer {
    my ($self) = @_;

    my $type = lc $self->type;

    if ( $type =~ /^(pica)?plus$/ ) {
        PICA::Writer::Plus->new( fh => $self->fh );
    } elsif ( $type eq 'plain') {
        PICA::Writer::Plain->new( fh => $self->fh );
    } elsif ( $type eq 'xml') {
        PICA::Writer::XML->new( fh => $self->fh );
    } else {
        die "unknown type: $type";
    }
}
 
sub add {
    my ($self, $data) = @_;
    # utf8::decode ???
    $self->writer->write($data);
}

sub commit { # TODO: why is this not called automatically?
    my ($self) = @_;
    $self->writer->end if $self->can('end');
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Catmandu::Exporter::PICA - Package that exports PICA data

=head1 VERSION

version 0.08

=head1 CONFIGURATION

In addition to the configuration provided by L<Catmandu::Exporter> the exporter
can be configured with a C<type> parameter as described at
L<Catmandu::Importer>.

=head1 AUTHOR

Johann Rolschewski <rolschewski@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Johann Rolschewski.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
