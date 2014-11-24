package WebService::Mackerel;
use 5.008001;
use strict;
use warnings;
use Carp qw/croak/;
use JSON;
use HTTP::Tiny;

our $VERSION = "0.01_2";

sub new {
    my ($class, %args) = @_;
    $args{api_key} or croak "api key is required";
    $args{service_name} or croak "service name is required";
    my $self = {
        api_key         => $args{api_key},
        service_name    => $args{service_name},
        mackerel_origin => $args{mackerel_origin} || 'https://mackerel.io',
        agent           => HTTP::Tiny->new( agent => "WebService::Mackerel agent $VERSION" ),
    };
    bless $self, $class;
}

sub post_service_metrics {
    my ($self, $args) = @_;
    my $path = '/api/v0/services/' . $self->{service_name} . '/tsdb';
    my $res  = $self->{agent}->request('POST', $self->{mackerel_origin} . $path, {
            content => encode_json $args,
            headers => {
                'content-type' => 'application/json',
                'X-Api-Key'    => $self->{api_key},
            },
        });
    return $res->{content};
}

sub create_host {
    my ($self, $args) = @_;
    my $path = '/api/v0/hosts';
    my $res  = $self->{agent}->request('POST', $self->{mackerel_origin} . $path, {
            content => encode_json $args,
            headers => {
                'content-type' => 'application/json',
                'X-Api-Key'    => $self->{api_key},
            },
        });
    return $res->{content};
}

sub get_host {
    my ($self, $host_id) = @_;
    my $path = '/api/v0/hosts/' . $host_id;
    my $res  = $self->{agent}->request('GET', $self->{mackerel_origin} . $path, {
            headers => {
                'X-Api-Key'    => $self->{api_key},
            },
        });
    return $res->{content};
}

sub update_host {
    my ($self, $args) = @_;
    my $path = '/api/v0/hosts/' . $args->{host_id};
    my $res  = $self->{agent}->request('PUT', $self->{mackerel_origin} . $path, {
            content => encode_json $args->{data},
            headers => {
                'content-type' => 'application/json',
                'X-Api-Key'    => $self->{api_key},
            },
        });
    return $res->{content};
}

sub update_host_status {
    my ($self, $args) = @_;
    my $path = '/api/v0/hosts/' . $args->{host_id} . '/status';
    my $res  = $self->{agent}->request('POST', $self->{mackerel_origin} . $path, {
            content => encode_json $args->{data},
            headers => {
                'content-type' => 'application/json',
                'X-Api-Key'    => $self->{api_key},
            },
        });
    return $res->{content};
}

sub host_retire {
    my ($self, $args) = @_;
    my $path = '/api/v0/hosts/' . $args->{host_id} . '/retire';
    my $res  = $self->{agent}->request('POST', $self->{mackerel_origin} . $path, {
            content => encode_json +{},
            headers => {
                'content-type' => 'application/json',
                'X-Api-Key'    => $self->{api_key},
            },
        });
    return $res->{content};
}

1;
__END__

=encoding utf-8

=head1 NAME

WebService::Mackerel - API Client for mackerel.io

=head1 SYNOPSIS

    use WebService::Mackerel;
    my $mackerel = WebService::Mackerel->new(api_key => 'key', service_name => 'service');

=head1 DESCRIPTION

WebService::Mackerel is API Client for mackerel.io

=head1 LICENSE

Copyright (C) Tatsuro Hisamori.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Tatsuro Hisamori E<lt>myfinder@cpan.orgE<gt>

=cut
