#!/usr/bin/env perl
$stat=-1;
while(<>){
    chomp;
    $line=$_;
    if(/^[^:]+:[0-9]+:[0-9]+:[a-zA-Z ]+:.*/){
	if($stat == -1){
	    $stat=0;
	}else{
	    print "\n";
	}
	print $line," ";
    }else{
	print $line," ";
    }
}
if($stat == -1){
    ;
}else{
    print "\n";
}
