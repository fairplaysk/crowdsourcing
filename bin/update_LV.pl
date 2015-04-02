use Dancer ':script';
use Dancer::Plugin::Database;
#use Fairplay::Pozfond;
no warnings;

my $tagy = database->selectall_arrayref('select tags.*,zmluva2tag.* from tags left join zmluva2tag on zmluva2tag.tag_id=tags.tag_id where tag_name like "%LV%" and zmluva_id is not null', { Slice => {} });
foreach my $tag (@$tagy) {
	$tag->{'tag_name'}=~s/(\d),(\d)/\1.\2/;
	if ($tag->{'tag_name'}=~/LV ?=? ?(\d+)/i) {
		#print "$1 $2 $tag->{'tag_name'} $tag->{'tag_id'} $tag->{'zmluva_id'} \n";
		#my $vymera=$1;
		#$vymera*=10000 if ($2=~/ha/);
		my $q="update zmluvy set LV=$1 where zmluva_id=$tag->{'zmluva_id'} and LV is null";
		print "$q\n";	
		database->do($q);
	}
	
}
print scalar(@$tagy);

