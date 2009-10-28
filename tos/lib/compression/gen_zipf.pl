#from http://www.nrbook.com/devroye/Devroye_files/chapter_ten.pdf
use POSIX qw(ceil floor);

$a = 1.5;

$b = 2**($a-1);

sub gen {
	do {
		$U = rand();
		$V = rand();
		$X = floor ( $U ** (-1/($a-1)) );
		$T = (1 + 1/$X)**($a-1);
	} while ( $V*$X*($T-1)/($b-1) > $T/$b);
	return $X;
}

sub shuffle {
	my $a = shift;
	my $i = @$a;
	while(--$i) {
		my $j = int rand($i+1);
		@$a[$i,$j] = @$a[$j,$i];
	}
}

@imap = (0..255);
shuffle(\@imap);

for ( $i = 0; $i < 100; $i++) {
	print "\n" if (!($i % 10));
	do { $g = gen() } while ($g > 255);
	printf("%3d", $imap[$g]);
	print ", " 
	#print "\n";
}
print "\n";
