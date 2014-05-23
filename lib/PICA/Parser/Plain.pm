package PICA::Parser::Plain;
#ABSTRACT: Plain PICA+ format parser
our $VERSION = '0.09'; #VERSION

use strict;
use charnames qw(:full);
use constant SUBFIELD_INDICATOR => '$';
use constant END_OF_FIELD       => "\N{LINE FEED}";
use constant END_OF_RECORD      => "\N{LINE FEED}";

use Carp qw(croak);

use parent 'PICA::Parser::Plus';

# copied from PICA::Parser::Plus (TODO: refactor)
sub next {
    my $self = shift;

    my $record;
    while ( my $line = $self->{reader}->getline() ) {
        last if $line =~ /^\s*$/;

        $record .= $line;
    }

    if ($record) {
        $self->{rec_number}++;

        $record = _decode($record);

        # get last subfield from 003@ as id
        my ($id) = map { $_->[-1] } grep { $_->[0] =~ '003@' } @{$record};
        return { _id => $id, record => $record };
    }

    return;
}

sub _decode {
    my $line = shift;
    chomp $line;
    my @fields = split( END_OF_FIELD, $line );
    my @record;
    
    for my $field (@fields) {

        my ( $tag, $occurence, $data );
        if ( $field =~ m/^(\d{3}[A-Z@])(\/(\d{2}))?\s(.*)/ ) {
            $tag       = $1;
            $occurence = $3 // '';
            $data      = $4;
        }
        else {
            croak 'ERROR: no valid PICA field structure';
        }

        my @subfields = split /\$([^\$])/, $data; #substr( $data, 1 ) );
        shift @subfields;

        push( @record, [ $tag, $occurence, @subfields ] );
    }
    return \@record;
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

PICA::Parser::Plain - Plain PICA+ format parser

=head1 VERSION

version 0.09

=head1 SEEALSO

L<PICA::PlainParser>, included in the release of L<PICA::Record> implements
another PICA+ format parser, not aligned with the L<Catmandu> framework.

=head1 AUTHOR

Johann Rolschewski <rolschewski@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Johann Rolschewski.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
