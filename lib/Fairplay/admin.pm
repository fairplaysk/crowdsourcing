
package admin;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use strict;
no warnings;

our $VERSION = '0.1';
;

get '/admin/exportcsv/' => sub {

	my $d="'AFP id'\$'Brigadnik'\$'Type'\$'File'\$'PozfondID'\$'Partner'\$'ICO1'\$'ICO2'\$'ICO3'\$'Podpis_date'\$'Podpisal'\$'Znalec'\$'Kataster'\$'Vymera'\$'LV'\$'Intravilan'\$'IncorrectType'\$'Cena'\$'TypPody'\$'ZnalecSubstitute'\$'KatasterSubstitute'\$'VymeraSubstitute'\$'LVSubstitute'\$'IntravilanSubstitute'\$'CenaSubstitute'\$'TypPodySubstitute'\$'Dorovnanie'\$'Poznamka'\$'Tags'\n";
	my $zmluvy = database->selectall_arrayref('select year as rok,date(last_update),zmluvy.*,workerz.login from  zmluvy left join workerz on zmluvy.worker_id=workerz.worker_id where complete="yes" order by zmluva_id desc', { Slice => {} });
	for my $z (@$zmluvy) {
                $d.="'".$z->{zmluva_id}."'\$";
                $d.="'".$z->{login}."'\$";
                $d.="'".$z->{type}."'\$";
                $d.="'http://46.231.96.103:3000/zmluvy/".$z->{type}."/".$z->{rok}."/".$z->{filename}.".pdf'\$";
                $d.="'".$z->{pozfond_id}."'\$";
                $d.="'".$z->{partner}."'\$";

		#no, this is not a reference to Ico Blatnik's croatia vacation shooting skills
		my @icoz=split(/[,;]/,$z->{ICO});
                $d.="'".$icoz[0]."'\$";
                $d.="'".$icoz[1]."'\$";
                $d.="'".$icoz[2]."'\$";

                $d.="'".$z->{podpis}."'\$";
                $d.="'".$z->{podpisal}."'\$";
                 $d.="'".$z->{znalec}."'\$";
                $d.="'".$z->{kataster_ref}."'\$";
                $d.="'".$z->{vymera}."'\$";
                $d.="'".$z->{LV}."'\$";
                $d.="'".$z->{intravilan}."'\$";
                $d.="'".$z->{incorrect_type}."'\$";
                $d.="'".$z->{cena}."'\$";
                $d.="'".$z->{typ_pody}."'\$";
                $d.="'".$z->{znalec_substitute}."'\$";
                $d.="'".$z->{kataster_ref_substitute}."'\$";
                $d.="'".$z->{vymera_substitute}."'\$";
                $d.="'".$z->{LV_substitute}."'\$";
                $d.="'".$z->{intravilan_substitute}."'\$";
                $d.="'".$z->{cena_substitute}."'\$";
                $d.="'".$z->{typ_pody_substitute}."'\$";
                $d.="'".$z->{dorovnanie}."'\$";
                $d.="'".$z->{poznamka}."'\$'";
		my $tagz=database->selectall_arrayref('select tag_name from  zmluva2tag left join tags on zmluva2tag.tag_id=tags.tag_id where zmluva_id=?', { Slice => {} },$z->{zmluva_id});	
		foreach my $tag (@$tagz) {
			$d.="'".$tag->{'tag_name'}.";";
		}
		$d.="'\n";
	}
	header('Content-Type' => 'text/csv');
	header('Content-Disposition'=> ' attachment; filename=pozfond.csv');
	return $d;
};


get '/admin/exportcsv_all/' => sub {

	my $d="'AFP id'\$'Brigadnik'\$'Type'\$'File'\$'PozfondID'\$'Partner'\$'ICO1'\$'ICO2'\$'ICO3'\$'Podpis_date'\$'Podpisal'\$'Znalec'\$'Kataster'\$'Vymera'\$'LV'\$'Intravilan'\$'IncorrectType'\$'Cena'\$'TypPody'\$'ZnalecSubstitute'\$'KatasterSubstitute'\$'VymeraSubstitute'\$'LVSubstitute'\$'IntravilanSubstitute'\$'CenaSubstitute'\$'TypPodySubstitute'\$'Dorovnanie'\$'Poznamka'\$'Tags'\n";
	my $zmluvy = database->selectall_arrayref('select year as rok,date(last_update),zmluvy.*,workerz.login from  zmluvy left join workerz on zmluvy.worker_id=workerz.worker_id order by zmluva_id desc', { Slice => {} });
	for my $z (@$zmluvy) {
                $d.="'".$z->{zmluva_id}."'\$";
                $d.="'".$z->{login}."'\$";
                $d.="'".$z->{type}."'\$";
                $d.="'http://46.231.96.103:3000/zmluvy/".$z->{type}."/".$z->{rok}."/".$z->{filename}.".pdf'\$";
                $d.="'".$z->{pozfond_id}."'\$";
                $d.="'".$z->{partner}."'\$";

		#no, this is not a reference to Ico Blatnik's croatia vacation shooting skills
		my @icoz=split(/[,;]/,$z->{ICO});
                $d.="'".$icoz[0]."'\$";
                $d.="'".$icoz[1]."'\$";
                $d.="'".$icoz[2]."'\$";

                $d.="'".$z->{podpis}."'\$";
                $d.="'".$z->{podpisal}."'\$";
                 $d.="'".$z->{znalec}."'\$";
                $d.="'".$z->{kataster_ref}."'\$";
                $d.="'".$z->{vymera}."'\$";
                $d.="'".$z->{LV}."'\$";
                $d.="'".$z->{intravilan}."'\$";
                $d.="'".$z->{incorrect_type}."'\$";
                $d.="'".$z->{cena}."'\$";
                $d.="'".$z->{typ_pody}."'\$";
                $d.="'".$z->{znalec_substitute}."'\$";
                $d.="'".$z->{kataster_ref_substitute}."'\$";
                $d.="'".$z->{vymera_substitute}."'\$";
                $d.="'".$z->{LV_substitute}."'\$";
                $d.="'".$z->{intravilan_substitute}."'\$";
                $d.="'".$z->{cena_substitute}."'\$";
                $d.="'".$z->{typ_pody_substitute}."'\$";
                $d.="'".$z->{dorovnanie}."'\$";
                $d.="'".$z->{poznamka}."'\$'";
		my $tagz=database->selectall_arrayref('select tag_name from  zmluva2tag left join tags on zmluva2tag.tag_id=tags.tag_id where zmluva_id=?', { Slice => {} },$z->{zmluva_id});	
		foreach my $tag (@$tagz) {
			$d.="'".$tag->{'tag_name'}.";";
		}
		$d.="'\n";
	}
	header('Content-Type' => 'text/csv');
	header('Content-Disposition'=> ' attachment; filename=pozfond_all.csv');
	return $d;
};



get '/admin/zmluvy/' => sub {
	my @zmluvy = database->selectall_arrayref('select date(last_update),zmluvy.*,workerz.login from  zmluvy left join workerz on zmluvy.worker_id=workerz.worker_id where complete="yes" order by zmluva_id desc', { Slice => {} });
	template 'admin_zmluvy.tt' => {'zmluvy'=>@zmluvy};	
};

post '/admin/stats' => sub {
	my $from=param  'from';
	my $to=param 'to';
	my @stats = database->selectall_arrayref('select login, count(*) as pocet,count(distinct partner) as distpar  from zmluvy left join workerz on workerz.worker_id=zmluvy.worker_id where complete="yes" and date(last_update)>=? and date(last_update)<=? group by zmluvy.worker_id ', {Slice=>{}},$from,$to);
	debug "select login, distinct partner as pocet from zmluvy left join workerz on workerz.worker_id=zmluvy.worker_id  where complete='yes' and date(last_update)>=$from and date(last_update)<=$to group by zmluvy.worker_id";
	template 'admin_stats.tt' => {'stats'=>@stats,'from'=>$from,'to'=>$to};
};



get '/admin/stats' => sub {
	my @stats = database->selectall_arrayref('select login, count(*) as pocet,count(distinct partner) as distpar   from zmluvy left join workerz on workerz.worker_id=zmluvy.worker_id where complete="yes" group by zmluvy.worker_id ', {Slice=>{}});
	template 'admin_stats.tt' => {'stats'=>@stats};
};

get '/admin/addworker' => sub {
	template 'register.tt';	
};
get '/worker/:worker_id/?' => sub {
	my @zmluvy = database->selectall_arrayref('select * from zmluvy where worker_id=? order by last_update desc', { Slice => {} },param 'worker_id');
	template 'admin_workerinfo.tt',{zmluvy=>@zmluvy,
		workerinfo=>database->quick_select('workerz',{worker_id=>param 'worker_id'})
	};
};
