package Catmandu::PICA;
#ABSTRACT: Catmandu modules for working with PICA+ data.
our $VERSION = '0.07'; #VERSION


1; # End of Catmandu::PICA

__END__

=pod

=encoding UTF-8

=head1 NAME

Catmandu::PICA - Catmandu modules for working with PICA+ data.

=head1 VERSION

version 0.07

=head1 DESCRIPTION

Catmandu::PICA provides methods to work with PICA+ data within the L<Catmandu>
framework.  See L<Catmandu::Introduction> and L<http://librecat.org/> for an
introduction into Catmandu.

=head1 CATMANDU MODULES

=over

=item * L<Catmandu::Importer::PICA>

=item * L<Catmandu::Exporter::PICA>

=item * L<Catmandu::Importer::SRU::Parser::picaxml>

=item * L<Catmandu::Fix::pica_map>

=back

=head1 INTERNAL MODULES

The following modules may be renamed or removed in a future release.

=over

=item * L<PICA::Parser::XML>

=item * L<PICA::Parser::Plus>

=item * L<PICA::Parser::Plain>

=item * L<PICA::Writer::XML>

=item * L<PICA::Writer::Plus>

=item * L<PICA::Writer::Plain>

=back

=head1 CONTRIBUTORS

Johann Rolschewski, <rolschewski@gmail.com>

Jakob Voß <voss@gbv.de>

=head1 AUTHOR

Johann Rolschewski <rolschewski@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Johann Rolschewski.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
