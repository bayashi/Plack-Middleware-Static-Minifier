package Plack::Middleware::Static::Minifier;
use strict;
use warnings;
use Carp qw/croak/;
use Plack::Util;
use parent 'Plack::Middleware::Static';
use CSS::Minifier::XS qw//;
use JavaScript::Minifier::XS qw//;

use Plack::Util::Accessor qw( path root encoding pass_through );

our $VERSION = '0.01';

sub call {
    my $self = shift;
    my $env  = shift;

    my $res = $self->_handle_static($env);

    if ($res->[0] == 200) {
        my $h = Plack::Util::headers($res->[1]);
        if ( $h->get('Content-Type') ) {
            _minifier($res, $h);
        }
    }

    if ($res && not ($self->pass_through and $res->[0] == 404)) {
        return $res;
    }

    return $self->app->($env);
}

sub _minifier {
    my ($res, $h) = @_;

    my $minified;
    if ($h->get('Content-Type') =~ m!/css!) {
        _get_body($res);
        $minified = CSS::Minifier::XS::minify($res->[2][0]);
    }
    elsif ( $h->get('Content-Type') =~ m!/javascript! ) {
        _get_body($res);
        $minified = JavaScript::Minifier::XS::minify($res->[2][0]);
    }
    if ($minified) {
        $res->[2] = [$minified];
        $h->set('Content-Length', length $minified);
    }
}

sub _get_body {
    my $res = shift;

    my $body;
    Plack::Util::foreach($res->[2], sub { $body .= $_[0] });
    $res->[2] = [$body];
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
