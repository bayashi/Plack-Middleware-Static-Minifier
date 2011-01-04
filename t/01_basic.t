use strict;
use warnings;
use Test::More 0.88;
use Plack::Builder;
use HTTP::Request::Common;
use HTTP::Response;
use Plack::Test;
use Cwd;

use Plack::Middleware::Static::Minifier;

my $base = cwd;

my $handler = builder {
    enable 'Plack::Middleware::Static::Minifier',
        path => sub { s!^/share/!!}, root => 'share';
    sub {
        [200, ['Content-Type' => 'text/plain', 'Content-Length' => 2], ['ok']]
    };
};

my %test = (
    client => sub {
        my $cb  = shift;
        {
            note('not static');
            my $res = $cb->(GET 'http://localhost/');
            is $res->content_type, 'text/plain';
            is $res->content, 'ok';
        }

        {
            note('jpg no minify');
            my $res = $cb->(GET 'http://localhost/share/face.jpg');
            is $res->content_type, 'image/jpeg';
        }

        {
            note('minify CSS');
            my $res = $cb->(GET 'http://localhost/share/try.css');
            is $res->content_type, 'text/css';
            is $res->content, 'html{margin:0px;padding:0px}body{margin:0px;padding:0px}';
        }

        {
            note('minify JavaScript');
            my $res = $cb->(GET 'http://localhost/share/try.js');
            is $res->content_type, 'application/javascript';
            is $res->content, "(function(){var akb=48;var name='Mariko';})();";
        }
    },
    app => $handler,
);

test_psgi %test;

done_testing;
