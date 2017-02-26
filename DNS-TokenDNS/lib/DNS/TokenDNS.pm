package DNS::TokenDNS;

use 5.018002;
use strict;
use warnings;
use JSON;
use LWP::UserAgent;

require Exporter;

our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( 'all' => [ qw()]);
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();
our $VERSION = '0.01';

my $BASE_URL = "https://api.tokendns.co/v1/";

sub new {
	my ($class, @args) = @_;
	my $self = {};
	bless $self, $class || $class;
	$self->{'apikey'} = $args[0]->{'apikey'} || die "No apikey provided";

	return $self;
}


##########################################################
#                        Records                         #
##########################################################

sub record_reserve {
	my ($self,$domain,$name,$type,$content,$ttl,$priority,$tag) = @_;
	die "You must provide a record name" if !$name;
	die "You must provide the record content" if !$content;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'name' => $name,
		'type' => $type || 'A',
		'content' => $content,
		'ttl' => $ttl || '300',
		'priority' => $priority || '0',
		'tag' => $tag
	);

	my $response = $self->_get_it( 'reserve', \%args );
	return $response;
}

sub record_delete {
	my ($self,$domain,$name,$type,$content) = @_;
	die "You must provide a record name" if !$name;
	die "You must provide the record type" if !$type;
	die "You must provide the content" if !$content;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'name' => $name,
		'content' => $content,
		'type' => $type || 'A'
	);

	my $response = $self->_get_it( 'delete', \%args );
	return $response;
}

sub record_update {
	my ($self,$domain,$name,$type,$content,$ttl,$priority,$tag) = @_;
	die "You must provide a record name" if !$name;
	die "You must provide the record content" if !$content;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'name' => $name,
		'type' => $type || 'A',
		'content' => $content,
		'ttl' => $ttl || '300',
		'priority' => $priority || '0',
		'tag' => $tag
	);

	my $response = $self->_get_it( 'update', \%args );
	return $response;
}

sub record_status {
	my ($self,$domain,$name) = @_;
	die "You must provide a domain name" if !$domain;
	die "You must provide the name" if !$name;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'name' => $name
	);

	my $response = $self->_get_it( 'status', \%args );
	return $response;
}

##########################################################
#                        Domains                         #
##########################################################

sub domain_add {
	my ($self,$domain,$method,$billing,$voucher,$email) = @_;
	die "You must provide a domain name" if !$domain;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'action' => 'add',
		'method' => $method || 'email',
		'billing' => $billing || 'monthly',
		'voucher' => $voucher,
		'email' => $email
	);

	my $response = $self->_get_it( 'domains', \%args );
	return $response;
}

sub domain_delete {
	my ($self,$domain) = @_;
	die "You must provide a domain name" if !$domain;

	my %args = (
		'domain' => $domain,
		'action' => 'delete'
	);

	my $response = $self->_get_it( 'domains', \%args );
	return $response;
}

sub domain_list {
	my ($self) = @_;

	my %args = (
		'action' => 'list'
	);

	my $response = $self->_get_it( 'domains', \%args );
	return $response;
}

##########################################################
#                         Tags                           #
##########################################################

sub tags {
	my ($self,$domain,$name) = @_;
	die "You must provide the name tag" if !$name;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'name' => $name
	);

	my $response = $self->_get_it( 'tags', \%args );
	return $response;
}

##########################################################
#                    FailoverDNS                         #
##########################################################

sub failoverdns_add {
	my ($self,$domain,$status,$url,$record_type,$record_name,$record_content,$record_original,$response_type,$response_content,$retry) = @_;
	die "You must provide a domain name" if !$domain;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'action' => 'add',
		'status' => $status || 'enable',
		'url' => $url,
		'record_type' => $record_type || 'A',
		'record_name' => $record_name || 'www',
		'record_content' => $record_content,
		'record_original' => $record_original,
		'response_type' => $response_type || 'code',
		'response_content' => $response_content || '200',
		'retry' => $retry
	);

	my $response = $self->_get_it( 'failoverdns', \%args );
	return $response;
}

sub failoverdns_list {
	my ($self,$domain,$name) = @_;
	die "You must provide a record name" if !$name;
	die "You must provide the domain name" if !$domain;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'action' => 'list',
		'name' => $name
	);

	my $response = $self->_get_it( 'failoverdns', \%args );
	return $response;
}

sub failoverdns_status {
	my ($self,$domain,$name,$status,$id) = @_;
	die "You must provide a record name" if !$name;
	die "You must provide the id name" if !$id;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'action' => 'status',
		'name' => $name,
		'status' => $status || 'enable',
		'id' => $id
	);

	my $response = $self->_get_it( 'failoverdns', \%args );
	return $response;
}

sub failoverdns_delete {
	my ($self,$domain,$name,$id) = @_;
	die "You must provide a record name" if !$name;
	die "You must provide the id name" if !$id;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'action' => 'delete',
		'name' => $name,
		'id' => $id
	);

	my $response = $self->_get_it( 'failoverdns', \%args );
	return $response;
}

##########################################################
#                      Notifications                     #
##########################################################

sub notifications_add_email {
	my ($self,$domain,$recipient) = @_;
	die "You must provide a recipient email address" if !$recipient;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'action' => 'add',
		'provider' => 'email',
		'recipient' => $recipient
	);

	my $response = $self->_get_it( 'notifications', \%args );
	return $response;
}

sub notifications_add_slack {
	my ($self,$domain,$channel,$webhook) = @_;
	die "You must provide a channel name" if !$channel;
	die "You must provide the webhook url" if !$webhook;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'action' => 'add',
		'provider' => 'slack',
		'channel' => $channel,
		'webhook' => $webhook
	);

	my $response = $self->_get_it( 'notifications', \%args );
	return $response;
}

sub notifications_add_pushover {
	my ($self,$domain,$user,$token) = @_;
	die "You must provide a user" if !$user;
	die "You must provide the token" if !$token;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'action' => 'add',
		'provider' => 'pushover',
		'user' => $user,
		'token' => $token
	);

	my $response = $self->_get_it( 'notifications', \%args );
	return $response;
}

sub notifications_add_pagerduty {
	my ($self,$domain,$token,$description) = @_;
	die "You must provide the token" if !$token;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'action' => 'add',
		'provider' => 'pagerduty',
		'description' => $description || 'None',
		'token' => $token
	);

	my $response = $self->_get_it( 'notifications', \%args );
	return $response;
}

sub notifications_add_webhook {
	my ($self,$domain,$webhook) = @_;
	die "You must provide the webhook url" if !$webhook;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'action' => 'add',
		'provider' => 'webhook',
		'webhook' => $webhook
	);

	my $response = $self->_get_it( 'notifications', \%args );
	return $response;
}

sub notifications_status {
	my ($self,$domain,$status,$id) = @_;
	die "You must provide the notification id" if !$id;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'action' => 'status',
		'status' => $status || 'enable',
		'id' => $id
	);

	my $response = $self->_get_it( 'notifications', \%args );
	return $response;
}

sub notifications_list {
	my ($self,$domain,$provider) = @_;
	die "You must provide the provider" if !$provider;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'action' => 'list',
		'provider' => $provider
	);

	my $response = $self->_get_it( 'notifications', \%args );
	return $response;
}

##########################################################
#                         Settings                       #
##########################################################

sub change_email {
	my ($self,$value) = @_;
	die "You must provide a new email address" if !$value;

	my %args = (
		'action' => 'email',
		'value' => $value
	);

	my $response = $self->_get_it( 'settings', \%args );
	return $response;
}

sub change_username {
	my ($self,$value) = @_;
	die "You must provide a new username" if !$value;

	my %args = (
		'action' => 'username',
		'value' => $value
	);

	my $response = $self->_get_it( 'settings', \%args );
	return $response;
}

sub reset_apikey {
	my ($self) = @_;

	my %args = (
		'action' => 'apikey'
	);

	my $response = $self->_get_it( 'settings', \%args );
	return $response;
}

sub update_address {
	my ($self,$billing_name,$billing_address1,$billing_address2,$billing_city,$billing_zip,$billing_country) = @_;

	my %args = (
		'action' => 'address',
		'billing_name' => $billing_name,
		'billing_address1' => $billing_address1,
		'billing_address2' => $billing_address2,
		'billing_city' => $billing_city,
		'billing_zip' => $billing_zip,
		'billing_country' => $billing_country
	);

	my $response = $self->_get_it( 'settings', \%args );
	return $response;
}

##########################################################
#                         Export                         #
##########################################################

sub export_records {
	my ($self,$domain) = @_;
	die "You must provide a domain name" if !$domain;

	my %args = (
		'domain' => $domain || 'blabladns.xyz',
		'action' => 'records'
	);

	my $response = $self->_get_it( 'export', \%args );
	return $response;
}

##########################################################
#                           End                          #
##########################################################

sub _get_it {
	my ($self,$endpoint,$args ) = @_;
	my $url = $self->_build_request( $endpoint, $args );

	my $ua = new LWP::UserAgent;
	my $response = $ua->get($url);

	if ($response->is_success) {
		my $content = $response->content;
		my $json = decode_json($content);

		return($json);

	} else {
		print "There was a problem with the request: " . $response->content . "\n";
	}
}

sub _build_request {
	my ($self,$endpoint,$args) = @_;
	$args->{'apikey'} = $self->{'apikey'};
	my @keys = keys %{$args};

	my $url = $BASE_URL . $endpoint . '?' . join( '&', map { $_ . '=' . $args->{$_} } @keys );

	return $url;
}


1;
__END__
=head1 NAME

DNS::TokenDNS - Perl extension for www.tokendns.co API

=head1 SYNOPSIS

  use DNS::TokenDNS;
  Manage your DNS records and domains

=head1 DESCRIPTION

Manage your DNS records and domains from www.tokendns.co

=head1 METHODS

=head2 new

Creates a new DNS::TokenDNS object.

  my $dns = DNS::TokenDNS->new({'apikey' => 'APIKEY'});

Your TokenDNS apikey must be provided.

=head2 record_reserve

	my $rs = $dns->record_reserve($domain,$name,$type,$content,$ttl,$priority,$tag);

=head2 record_update

	my $rs = $dns->record_update($domain,$name,$type,$content,$ttl,$priority,$tag);

=head2 record_status

	my $rs = $dns->record_status($domain,$name);

=head2 record_delete

	my $rs = $dns->record_delete($domain,$name,$type,$content);

=head2 Tags

	my $rs = $dns->tags($domain,$tag);

=head2 domain_add

	my $rs = $dns->domain_add($domain,$method,$billing,$voucher,$email);

=head2 domain_list

	my $rs = $dns->domain_list();

=head2 domain_delete

	my $rs = $dns->domain_delete($domain);

=head2 failoverdns_add

	my $rs = $dns->failoverdns_add($domain,$status,$url,$record_type,$record_name,$record_content,$record_original,$response_type,$response_content,$retry);

=head2 failoverdns_list

	my $rs = $dns->failoverdns_list($domain,$name);

=head2 failoverdns_status

	my $rs = $dns->failoverdns_status($domain,$name,$status,$id);

=head2 failoverdns_delete

	my $rs = $dns->failoverdns_delete($domain,$name,$id);

=head2 notifications_add_email

	my $rs = $dns->notifications_add_email($domain,$recipient);

=head2 notifications_add_slack

	my $rs = $dns->notifications_add_slack($domain,$channel,$webhook);

=head2 notifications_add_pushover

	my $rs = $dns->notifications_add_pushover($domain,$user,$token);

=head2 notifications_add_pagerduty

	my $rs = $dns->notifications_add_pagerduty($domain,$token,$description);

=head2 notifications_add_webhook

	my $rs = $dns->notifications_add_webhook($domain,$webhook);

=head2 notifications_status

	my $rs = $dns->notifications_status($domain,$status,$id);

=head2 notifications_list

	my $rs = $dns->notifications_list($domain,$provider);

=head2 change_email

	my $rs = $dns->change_email($email);

=head2 change_username

	my $rs = $dns->change_username($username);

=head2 reset_apikey

	my $rs = $dns->reset_apikey();

=head2 update_address

	my $rs = $dns->update_address($billing_name,$billing_address1,$billing_address2,$billing_city,$billing_zip,$billing_country);

=head2 export_records

	my $rs = $dns->export_records($domain);

=head1 AUTHOR

Steffen Wirth<lt>steffen.wirth@tokendns.co<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2017 by Steffen Wirth

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
