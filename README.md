NAME
=============

DNS::TokenDNS - Perl extension for www.tokendns.co API

SYNOPSIS
-------

  use DNS::TokenDNS;
  Manage your DNS records and domains

DESCRIPTION
-------

Manage your DNS records and domains with www.tokendns.co. Get a full API Documentation on https://my.tokendns.co/api/docs/.

Installation
-------

```
git clone https://github.com/tokendns/perl-modules-dns-tokendns
cd perl-modules-dns-tokendns/DNS-TokenDNS
perl Makefile.PL
make
sudo make install
```

METHODS
-------

new
-------

Creates a new DNS::TokenDNS object.

```
my $dns = DNS::TokenDNS->new({'apikey' => 'APIKEY'});
```

Your TokenDNS apikey must be provided.

record_reserve
-------

```
my $rs = $dns->record_reserve($domain,$name,$type,$content,$ttl,$priority,$tag);
```

record_update
-------

```
my $rs = $dns->record_update($domain,$name,$type,$content,$ttl,$priority,$tag);
```

record_status
-------

```
my $rs = $dns->record_status($domain,$name);
```

record_delete
-------

```
my $rs = $dns->record_delete($domain,$name,$type,$content);
```

tags
-------

```
my $rs = $dns->tags($domain,$tag);
```

domain_add
-------

```
my $rs = $dns->domain_add($domain,$method,$billing,$voucher,$email);
```

domain_list
-------

```
my $rs = $dns->domain_list();
```

domain_delete
-------

```
my $rs = $dns->domain_delete($domain);
```

failoverdns_add
-------

```
my $rs = $dns->failoverdns_add($domain,$status,$url,$record_type,$record_name,$record_content,$record_original,$response_type,$response_content,$retry);
```

failoverdns_list
-------

```
my $rs = $dns->failoverdns_list($domain,$name);
```

failoverdns_status
-------

```
my $rs = $dns->failoverdns_status($domain,$name,$status,$id);
```

failoverdns_delete
-------

```
my $rs = $dns->failoverdns_delete($domain,$name,$id);
```

notifications_add_email
-------

```
my $rs = $dns->notifications_add_email($domain,$recipient);
```

notifications_add_slack
-------

```
my $rs = $dns->notifications_add_slack($domain,$channel,$webhook);
```

notifications_add_pushover
-------

```
my $rs = $dns->notifications_add_pushover($domain,$user,$token);
```

notifications_add_pagerduty
-------

```
my $rs = $dns->notifications_add_pagerduty($domain,$token,$description);
```

notifications_add_webhook
-------

```
my $rs = $dns->notifications_add_webhook($domain,$webhook);
```

notifications_status
-------

```
my $rs = $dns->notifications_status($domain,$status,$id);
```

notifications_list
-------

```
my $rs = $dns->notifications_list($domain,$provider);
```

change_email
-------

```
my $rs = $dns->change_email($email);
```

change_username
-------

```
my $rs = $dns->change_username($username);
```

reset_apikey
-------

```
my $rs = $dns->reset_apikey();
```

update_address
-------

```
my $rs = $dns->update_address($billing_name,$billing_address1,$billing_address2,$billing_city,$billing_zip,$billing_country);
```

AUTHOR
-------

Steffen Wirth <hello@tokendns.co>

COPYRIGHT AND LICENSE
-------

Copyright (C) 2017 by Steffen Wirth

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

