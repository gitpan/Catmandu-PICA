package PICA::Parser::Plus;
# ABSTRACT: PICA+ format parser
our $VERSION = '0.14'; # VERSION

use strict;
use charnames qw< :full >;
use Carp qw(croak);

use constant SUBFIELD_INDICATOR => "\N{INFORMATION SEPARATOR ONE}";
use constant END_OF_FIELD       => "\N{INFORMATION SEPARATOR TWO}";
use constant END_OF_RECORD      => "\N{LINE FEED}"; # TODO


sub new {
    my $class = shift;
    my $file  = shift;

    my $self = {
        filename   => undef,
        rec_number => 0,
        reader => undef,
    };

    # check for file or filehandle
    my $ishandle = eval { fileno($file); };
    if ( !$@ && defined $ishandle ) {
        $self->{filename} = scalar $file;
        $self->{reader}   = $file;
    }
    elsif ( -e $file ) {
        open $self->{reader}, '<:encoding(UTF-8)', $file
            or croak "cannot read from file $file\n";
        $self->{filename} = $file;
    }
    else {
        croak "file or filehande $file does not exists";
    }
    return ( bless $self, $class );
}


sub next {
    my $self = shift;
    if ( my $line = $self->{reader}->getline() ) {
        $self->{rec_number}++;
        my $record = _decode($line);

        # get last subfield from 003@ as id
        my ($id) = map { $_->[-1] } grep { $_->[0] =~ '003@' } @{$record};
        return { _id => $id, record => $record };
    }
    return;
}


sub _decode {
    my $reader = shift;
    chomp($reader);
    my @fields = split( END_OF_FIELD, $reader );
    my @record;

    if ($fields[0] !~ m/.*SUBFIELD_INDICATOR/){
        # drop leader because usage is unclear
        shift(@fields);
    }
    
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
        my @subfields = map { substr( $_, 0, 1 ), substr( $_, 1 ) }
            split( SUBFIELD_INDICATOR, substr( $data, 1 ) );
        push( @record, [ $tag, $occurence, @subfields ] );
    }
    return \@record;
}


1;    # End of PICA::Parser::Plus

__END__

=pod

=encoding UTF-8

=head1 NAME

PICA::Parser::Plus - PICA+ format parser

=head1 VERSION

version 0.14

=head1 SYNOPSIS

L<PICA::Parser::Plus> is a parser for PICA+ records. 

    use PICA::Parser::Plus;

    my $parser = PICA::Parser::Plus->new( $filename );

    while ( my $record_hash = $parser->next() ) {
        # do something        
    }

=head1 SUBROUTINES/METHODS

=head2 new

=head2 next()

Reads the next record from PICA+ XML input stream. Returns a Perl hash.

=head2 _decode()

Deserialize a PICA+ record to an array of field arrays.

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
