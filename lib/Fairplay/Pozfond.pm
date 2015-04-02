package Fairplay::Pozfond;
use Dancer ':syntax';
use Fairplay::login;
use Fairplay::admin;
use Fairplay::register;
use Dancer::Plugin::Database;
use Fairplay::work;

our $VERSION = '0.1';

hook 'before_template_render' => sub {
        my $tokens=shift;
        $tokens->{'login'}=session 'login';
        $tokens->{'worker_id'}=session 'worker_id';
};

get '/logout' => sub {
        session->destroy;
        redirect '/';
};

post '/attributenew' => sub {
	my $worker_id=session 'worker_id';
	if (!$worker_id) {
		redirect '/';
	}
	my $amount=param  'amount';
	my $type=param 'type';
	my $rok=param 'rok';
	my $sql="update zmluvy set work_attributed=now(),worker_id=? where complete='no' and work_attributed<date_sub(NOW(),interval 1 month) and type=? and rok<2012 order by rok desc limit $amount";
	#debug $sql;
        database->do($sql,undef,$worker_id,$type,$amount);
	my $zmluva_id = database->quick_lookup('zmluvy', { worker_id => (session 'worker_id'), complete=>'no' }, 'zmluva_id');        
        if (!$zmluva_id) {
                return template 'attributenew.tt' => {
                        show_warning => "Nedala sa priradit ziadna zmluva splnajuca kriteria [$type].Zvol prosim ine kriteria.",
                };
        }
	else {
		redirect '/work';
	}
};

get '/attributenew' => sub {
	my $worker_id=session 'worker_id';
	if (!$worker_id) {
		redirect '/';
	}
	
	return template 'attributenew.tt';
};

get '/' => sub {
	if (!session 'worker_id') {
		return template 'login.tt';
	} else {
		my $zmluva_id = database->quick_lookup('zmluvy', { worker_id => (session 'worker_id'), complete=>'no' }, 'zmluva_id');        
		if ($zmluva_id) {
			redirect '/work';
		} else {
			redirect '/attributenew';
		}
	};
};

true;
