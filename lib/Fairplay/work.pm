package work;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use strict;
use warnings;

our $VERSION = '0.1';

get '/work' => sub {
	my %tags;
	my $zmluvy = database->selectall_arrayref('select * from zmluvy where worker_id=? and complete="no" order by last_update desc', { Slice => {} },session 'worker_id');
	my @zmluvy_final;

	if (scalar(@$zmluvy)<1) {
		redirect '/attributenew';
	}

	for my $z (@$zmluvy) {
		my $tagz=database->selectall_arrayref('select tag_name from  zmluva2tag left join tags on zmluva2tag.tag_id=tags.tag_id where zmluva_id=?', { Slice => {} },$z->{zmluva_id});	
		foreach my $tag (@$tagz) {
			$z->{'tags'}.=$tag->{'tag_name'}.";";
		}
		#debug $z->{'tags'};
		push @zmluvy_final, $z;
	}
	template 'work.tt',{zmluvy=>\@zmluvy_final};
};

post '/work/updatezmluva' => sub {
	my $worker_id=session('worker_id');
	my $paramref=params;
	my $update_q;
	my $id=params->{'id'};
	for my $k (keys %{$paramref}) {
		if ($k eq "tags") {
			#debug "TAGY".params->{$k};
			my @tags=split(/;/,params->{$k});
			database->do("delete from zmluva2tag where zmluva_id=?",undef,$id);
		        foreach my $t (@tags) {
                		database->do("insert into tags set tag_name=?  ON DUPLICATE KEY UPDATE tag_counter = tag_counter + 1",undef, $t);
				my $tag_id=database->quick_lookup('tags',{tag_name=>$t},"tag_id");
		                #my $tag_id = database->{ q{mysql_insertid}};
                		database->do("insert into zmluva2tag set zmluva_id=?,tag_id=?",undef, $id,$tag_id);
        		}
		} 
		elsif ($k eq "vymera") {
			params->{$k}*=10000 if params->{"metric"} eq "ha";
			$update_q.="$k='".params->{$k}."',";
		}
		elsif ($k eq "vymera_substitute") {
			debug "LOL";
			params->{$k}*=10000 if params->{"metric_substitute"} eq "ha";
			$update_q.="$k='".params->{$k}."',";
		}
		elsif ($k =~ "cena") {
			debug "TRALALA";
			params->{$k}=~s/,/./;
			$update_q.="$k='".params->{$k}."',";
		}
		elsif ($k eq 'podpis') {
			if (params->{"podpis"}=~/(\d{1,2})[\.\-](\d{1,2})[\.\-](\d{4})/) {
				$update_q.="podpis='$3-$2-$1',";	
			}
			else {
				$update_q.="$k='".params->{$k}."',";
			}
		} 
		elsif ($k ne 'id' && $k !~ /metric/ ){
			my $value=params->{$k};
			$update_q.="$k='".params->{$k}."',";
		}
	}
	$update_q.=" intravilan='no'," if !params->{'intravilan'};
	$update_q.=" incorrect_type='no'," if !params->{'incorrect_type'};

	$update_q.=" last_update=NOW(),";
	$update_q.=" worker_id='$worker_id'";
	my $sql="update zmluvy set $update_q where zmluva_id='$id'"; 
	debug $sql;
	database->do($sql);
	redirect '/work';
};

