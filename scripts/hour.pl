

$first=-1;
open(IN, "hourly");
while (<IN>) {
	($date, $time, $count) = split;
	$h = split(":", $time);
	if ($first == -1) {
		$first = $h;
	} elsif (($h - $first) % 24 > 1) {
	   	for ($i = $first + 1; abs($h - $i) % 24 > 1; $i++) {
			if ($i == 24) {
				($d, $m, $y) = split('/', $date);
				$i = 0;
				$d += 1;
				if ($d > 31) {
					$d = 1;				
					$m += 1;
					if ($m > 12) {
						$m = 1;
						$y += 1;
					}
				}
				$date = "$d/$m/$y";
			}
			print "$date $i:00;0\n" ;	
		}
	}
	print "$date $time;$count\n"; 
}
close(IN);
