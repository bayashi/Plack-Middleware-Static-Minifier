package Plack::Middleware::Static::Minifier;
use strict;
use warnings;
use Carp qw/croak/;
use Plack::Util;
use parent 'Plack::Middleware::Static';
use CSS::Minifier::XS qw//;
use JavaScript::Minifier::XS qw//;

our $VERSION = '0.01';

sub call {
    my $self = shift;
    my $env  = shift;

    my $res = $self->_handle_static($env);

    if ($res && $res->[0] == 200) {
        my $h = Plack::Util::headers($res->[1]);
        if ( $h->get('Content-Type')
                && $h->get('Content-Type') =~ m!/(css|javascript)! ) {
            my $m = $1;
            my $body; Plack::Util::foreach($res->[2], sub { $body .= $_[0] });
            $res->[2] = ($m =~ m!^css!)
                      ? [ CSS::Minifier::XS::minify($body) ]
                      : [ JavaScript::Minifier::XS::minify($body) ];
            $h->set('Content-Length', length $res->[2][0]);
        }
    }

    if ($res && not ($self->pass_through and $res->[0] == 404)) {
        return $res;
    }

    return $self->app->($env);
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
