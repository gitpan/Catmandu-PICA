package Catmandu::Importer::SRU::Parser::picaxml;
#ABSTRACT: Parse SRU response with PICA+ data into Catmandu PICA
our $VERSION = '0.08'; #VERSION

use Moo;
use PICA::Parser::XML;

sub parse {
    my ( $self, $record ) = @_;

    my $xml = $record->{recordData};
    my $parser = PICA::Parser::XML->new( $xml ); 

    return $parser->next;
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Catmandu::Importer::SRU::Parser::picaxml - Parse SRU response with PICA+ data into Catmandu PICA

=head1 VERSION

version 0.08

=head1 SYNOPSIS

    my %attrs = (
        base => 'http://sru.gbv.de/gvk',
        query => '1940-5758',
        recordSchema => 'picaxml' ,
        parser => 'picaxml' ,
    );

    my $importer = Catmandu::Importer::SRU->new(%attrs);

To give an example for use of the L<catmandu> command line client:

    catmandu convert SRU --base http://sru.gbv.de/gvk 
                         --query "pica.isb=0-937175-64-1" 
                         --recordSchema picaxml 
                         --parser picaxml 
                     to PICA --type plain

=head1 DESCRIPTION

Each picaxml response will be transformed into the format defined by
L<Catmandu::Importer::PICA>

=head1 AUTHOR

Johann Rolschewski <rolschewski@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Johann Rolschewski.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
