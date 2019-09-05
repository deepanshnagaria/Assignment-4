set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

set nd [open out.tr w]
$ns trace-all $nd

set q [lindex $argv 0]
set bw [lindex $argv 1]

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n2 $bw 10ms DropTail
$ns duplex-link $n1 $n2 25Mb 10ms DropTail
$ns duplex-link $n2 $n3 $bw 10ms DropTail
$ns duplex-link $n3 $n4 20Mb 10ms DropTail
$ns duplex-link $n3 $n5 $bw 10ms DropTail

$ns queue-limit $n0 $n2 $q
$ns queue-limit $n1 $n2 $q
$ns queue-limit $n2 $n3 $q
$ns queue-limit $n3 $n4 $q
$ns queue-limit $n3 $n5 $q

Agent/Ping instproc recv {from rtt} {}

set p0 [new Agent/Ping]
$ns attach-agent $n0 $p0

set p1 [new Agent/Ping]
$ns attach-agent $n1 $p1

set p4 [new Agent/Ping]
$ns attach-agent $n4 $p4

set p5 [new Agent/Ping]
$ns attach-agent $n5 $p5

$p0 set packetSize_ 30000
$p0 set interval_ 0.00001

$p5 set packetSize_ 30000
$p5 set interval_ 0.00001

$ns connect $p0 $p4
$ns connect $p5 $p1

proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam &
    exec awk -f 1.awk out.tr > final.tr &
    exit
}

$ns at 0.1 "$p0 send"
$ns at 0.2 "$p0 send"
$ns at 0.3 "$p0 send"
$ns at 0.4 "$p0 send"
$ns at 0.5 "$p0 send"
$ns at 0.6 "$p0 send"
$ns at 0.7 "$p0 send"
$ns at 0.8 "$p0 send"
$ns at 0.9 "$p0 send"
$ns at 1.0 "$p0 send"
$ns at 1.1 "$p0 send"
$ns at 1.2 "$p0 send"
$ns at 1.3 "$p0 send"
$ns at 1.4 "$p0 send"
$ns at 1.5 "$p0 send"
$ns at 1.6 "$p0 send"
$ns at 1.7 "$p0 send"
$ns at 1.8 "$p0 send"
$ns at 1.9 "$p0 send"
$ns at 2.0 "$p0 send"
$ns at 2.1 "$p0 send"
$ns at 2.2 "$p0 send"
$ns at 2.3 "$p0 send"
$ns at 2.4 "$p0 send"
$ns at 2.5 "$p0 send"
$ns at 2.6 "$p0 send"
$ns at 2.7 "$p0 send"
$ns at 2.8 "$p0 send"
$ns at 2.9 "$p0 send"

$ns at 0.1 "$p5 send"
$ns at 0.2 "$p5 send"
$ns at 0.3 "$p5 send"
$ns at 0.4 "$p5 send"
$ns at 0.5 "$p5 send"
$ns at 0.6 "$p5 send"
$ns at 0.7 "$p5 send"
$ns at 0.8 "$p5 send"
$ns at 0.9 "$p5 send"
$ns at 1.0 "$p5 send"
$ns at 1.1 "$p5 send"
$ns at 1.2 "$p5 send"
$ns at 1.3 "$p5 send"
$ns at 1.4 "$p5 send"
$ns at 1.5 "$p5 send"
$ns at 1.6 "$p5 send"
$ns at 1.7 "$p5 send"
$ns at 1.8 "$p5 send"
$ns at 1.9 "$p5 send"
$ns at 2.0 "$p5 send"
$ns at 2.1 "$p5 send"
$ns at 2.2 "$p5 send"
$ns at 2.3 "$p5 send"
$ns at 2.4 "$p5 send"
$ns at 2.5 "$p5 send"
$ns at 2.6 "$p5 send"
$ns at 2.7 "$p5 send"
$ns at 2.8 "$p5 send"
$ns at 2.9 "$p5 send"

$ns at 3.0 "finish"

$ns run
