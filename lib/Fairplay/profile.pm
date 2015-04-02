package profile;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Digest::MD5 qw(md5_base64);

get '/profile/?' => sub {
	#my $giver_id = database->quick_lookup('givers', { login => $login, password=>md5_base64($password) }, 'giver_id');        
	return template 'profile.tt', {};
};

true;
