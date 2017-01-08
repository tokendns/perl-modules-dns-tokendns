use 5.018002;
use strict;
use ExtUtils::MakeMaker;
WriteMakefile(
    NAME              => 'DNS::TokenDNS',
    VERSION_FROM      => 'lib/DNS/TokenDNS.pm',
    PREREQ_PM         => {
			'Test::More' => 0,
			'LWP::UserAgent' => 0,
			'JSON' => 0
		},
		dist => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/DNS/TokenDNS.pm', 
       AUTHOR         => 'Steffen Wirth <steffen.wirth@tokendns.co>') : ()),
);
