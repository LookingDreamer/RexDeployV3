package FastNotes;

use strict;
use warnings;
use Mojo::Base 'Mojolicious';
use FastNotes::Model;



# This method will run once at server start
sub startup {
    my $self = shift;
    

    $self->secrets(['SomethingVerySecret']);
    $self->mode('development');
    $self->sessions->default_expiration(3600*24*7);

    my $config = $self->plugin( 'JSONConfig' => { file=>'fastnotes.json' } );

    my $r = $self->routes;
    $r->namespaces(['FastNotes::Controller']);

    $r->route('/')                   ->to('auths#create_form')->name('auths_create_form');
    $r->route('/login')              ->to('auths#login')     ->name('auth_login');
    $r->route('/token')              ->to('auths#token')     ->name('get_token');
    # $r->route('/logout')             ->to('auths#delete')     ->name('auths_delete');
    # $r->route('/signup')->via('get') ->to('users#create_form')->name('users_create_form');
    # $r->route('/signup')->via('post')->to('users#create')     ->name('users_create');
    # $r->route('/main')  ->via('get') ->to('users#show')       ->name('users_show');

    # my $rn = $r->under('/notes')->to('auths#check');
    # $rn->route                       ->via('get')   ->to('notes#index') ->name('notes_show');
    # $rn->route                       ->via('post')  ->to('notes#create')->name('notes_create');
    # $rn->route('/:id', id => qr/\d+/)->via('put')   ->to('notes#update')->name('notes_update');
    # $rn->route('/:id', id => qr/\d+/)->via('delete')->to('notes#delete')->name('notes_delete');

    # $r->route('/help')   ->to( cb => sub{ shift->render( template=>'help', format=>'html' ) } );

    my $ren = $r->under('/rex')->to('auths#checkapi');
    $ren->route                       ->via('get')   ->to('rex#index') ->name('rex_show');
    $ren->route                       ->via('post')  ->to('rex#runcmd')->name('rex_run');
    my $up = $r->under('/upload')->to('auths#checkapi');
    $up->route                       ->via('post')  ->to('rex#upload')->name('rex_upload');

    my $configure = $r->under('/rex/config')->to('auths#checkapi');
    $configure->route                       ->via('post')   ->to('config#index') ->name('config_get');

    my $configureadd = $r->under('/rex/config/add')->to('auths#checkapi');
    $configureadd->route                       ->via('post')   ->to('config#add') ->name('config_add');

    my $configuredelete = $r->under('/rex/config/delete')->to('auths#checkapi');
    $configuredelete->route                       ->via('post')   ->to('config#delete') ->name('config_delete');

    my $groupconfigure = $r->under('/rex/groupconfig')->to('auths#checkapi');
    $groupconfigure->route                       ->via('post')   ->to('groupconfig#index') ->name('groupconfig_get');


    $r->route('/help')   ->to( cb => sub{ shift->render( template=>'help', format=>'html' ) } );



    # Init Model
    FastNotes::Model->init( $config->{db} || {
        dsn      => 'dbi:SQLite:dbname=' . $self->home->rel_dir('storage') . '/fastnotes.db',
        user     => '',
        password =>''
    });

}

1;
