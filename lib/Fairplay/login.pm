package login;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Digest::MD5 qw(md5_hex);

post '/login' => sub {
	## Get the <FORM> CGI parameters
	my $login = param 'login' ;
	my $password = param 'password' ;
	my %sessiondata;

	my $worker_id = database->quick_lookup('workerz', { login => $login, password=>md5_hex($password) }, 'worker_id');        
        if (!$worker_id) {
                return template 'login.tt' => {
                        show_warning => "Wrong login or password",
                };
        }
	else {
		session  worker_id=>$worker_id;
		session login=>$login;
		debug "$worker_id LOGGED IN";		
		if ($worker_id==1) {
			redirect '/admin/stats';
		} else {
			redirect '/';	
		}
	};
};

true;
