package Plack::Middleware::Static::Minifier;
use strict;
use warnings;
use Carp qw/croak/;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args  = shift || +{};

    bless $args, $class;
}


1;

__END__

=head1 NAME

Plack::Middleware::Static::Minifier - one line description


=head1 SYNOPSIS

    use Plack::Middleware::Static::Minifier;


=head1 DESCRIPTION

Plack::Middleware::Static::Minifier is


=head1 REPOSITORY

Plack::Middleware::Static::Minifier is hosted on github
at http://github.com/bayashi/Plack-Middleware-Static-Minifier


=head1 AUTHOR

Dai Okabayashi E<lt>bayashi@cpan.orgE<gt>


=head1 SEE ALSO

L<Other::Module>


=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
