package PICA::Writer::XML;
#ABSTRACT: PICA+ XML format serializer
our $VERSION = '0.09'; #VERSION

use strict;
use Moo;
with 'PICA::Writer::Handle';

sub BUILD {
    my ($self) = @_;
    $self->start;
}

sub start {
    my ($self) = @_;

    print {$self->fh} "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    print {$self->fh} "<collection xlmns=\"info:srw/schema/5/picaXML-v1.0\">\n";
}

sub _write_record {
    my ($self, $record) = @_;
    my $fh = $self->fh;

    print $fh "<record>\n";
    foreach my $field (@$record) {
        # this will break on bad tag/occurrence values
        print $fh "  <datafield tag=\"$field->[0]\"" . ( 
                defined $field->[1] && $field->[1] ne '' ?
                " occurrence=\"$field->[1]\"" : ""
            ) . ">\n";
            for (my $i=2; $i<scalar @$field; $i+=2) {
                my $value = $field->[$i+1];
                $value =~ s/</&lt;/g;
                $value =~ s/&/&amp;/g;
                # TODO: disallowed code points (?)
                print $fh "    <subfield code=\"$field->[$i]\">$value</subfield>\n";
            } 
        print $fh "  </datafield>\n";
    }
    print $fh "</record>\n";
}

sub end {
    my ($self) = @_;
    
    print {$self->fh} "</collection>\n";
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

PICA::Writer::XML - PICA+ XML format serializer

=head1 VERSION

version 0.09

=head1 AUTHOR

Johann Rolschewski <rolschewski@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Johann Rolschewski.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
