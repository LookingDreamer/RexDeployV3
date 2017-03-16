use Mojolicious::Lite;
use lib/rex;

# /hello (Accept: application/json)
# /hello (Accept: application/xml)
# /hello.json
# /hello.xml
# /hello?format=json
# /hello?format=xml
get '/hello' => sub {
  my $c = shift;
  $c->respond_to(
    json => {json => {hello => 'world'}},
    xml  => {text => '<hello>world</hello>'},
    any  => {data => '', status => 204}
  );
};

# Not found (404)
get '/missing' => sub { shift->render('does_not_exist') };

# Exception (500)
get '/dies' => sub { die 'Intentional error' };

app->start;