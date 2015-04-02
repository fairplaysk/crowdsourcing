package register;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Digest::MD5 qw(md5_hex);

get '/register' => sub { template 'register.tt' };

post '/register' => sub {
	my $username = param 'login' ;
	my $password = param 'password' ;
	my $password2 = param 'password2' ;

	if (length($username)==0 or length($password)==0 or length($password2)==0) {
		return template 'register.tt' => {
			show_warning => "Missing username or password",
		};
	}
	elsif ($password ne $password2) {
		return template 'register.tt' => {
			show_warning => "Passwords do not match",
		};
	}
	
	my $giver_id=database->quick_lookup("workerz",{login=>$username},"worker_id");
        if ($giver_id) {
                return template 'register.tt' => {
                        show_warning => "User already exists. Try another username.",
                };
        }

        my $sql="INSERT INTO workerz SET login=?, password=?";
        database->do($sql,undef,$username,md5_hex($password));
        my $new_id = database->{ q{mysql_insertid}};

	return template 'login.tt' => {
		show_message => "$username sa moze prihlasit do systemu",
	};
};
true;
