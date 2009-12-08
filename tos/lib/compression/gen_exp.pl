$b = 1.001;
$l = log(256)/log($b);
for ( $i = 0; $i < 100; $i++) {
	print "\n" if (!($i % 10));
	printf("%3d", int($b**rand($l)));
	print ", " 
	#print "\n";
}
print "\n";
