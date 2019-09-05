#Event Scheduler Object creation.

 set netSimInstance [new Simulator]

 #Creating trace objects and nam objects.

 
set namFile [open namOutput.nam w]
$netSimInstance namtrace-all $namFile

set traceFile [open traceOutput.tr w]
$netSimInstance trace-all $traceFile

 #Finish procedure
proc finish {}   {
    global netSimInstance traceFile namFile
    $netSimInstance flush-trace
    close $traceFile
    close $namFile
    exec nam namOutput.nam &
    exec awk -f 2.awk traceOutput.tr &
    exit 0
}

 #Create the network
set node0 [$netSimInstance node]
set node1 [$netSimInstance node]
set node2 [$netSimInstance node]
set node3 [$netSimInstance node]
set node4 [$netSimInstance node]
set node5 [$netSimInstance node]

 #Creating Duplex-Link
$netSimInstance duplex-link $node0 $node2 1Mb 10ms DropTail
$netSimInstance duplex-link $node2 $node1 10Mb 10ms DropTail
$netSimInstance duplex-link $node2 $node3 .1Mb 10ms DropTail
$netSimInstance duplex-link $node3 $node4 .1Mb 10ms DropTail
$netSimInstance duplex-link $node3 $node5 .05Mb 10ms DropTail

 Agent/Ping instproc recv {from rtt} {
        $self instvar node_
        puts "node [$node_ id] received ping answer from \
              $from with round-trip-time $rtt ms."
}

set pingAgent0 [new Agent/Ping]
set pingAgent1 [new Agent/Ping]
set pingAgent2 [new Agent/Ping]
set pingAgent3 [new Agent/Ping]
set pingAgent4 [new Agent/Ping]
set pingAgent5 [new Agent/Ping]


$netSimInstance attach-agent $node0 $pingAgent0
$netSimInstance attach-agent $node1 $pingAgent1
$netSimInstance attach-agent $node2 $pingAgent2
$netSimInstance attach-agent $node3 $pingAgent3
$netSimInstance attach-agent $node4 $pingAgent4
$netSimInstance attach-agent $node5 $pingAgent5


$netSimInstance queue-limit $node2 $node1 3
$netSimInstance queue-limit $node0 $node2 4
$netSimInstance queue-limit $node2 $node3 1
$netSimInstance queue-limit $node3 $node4 1
$netSimInstance queue-limit $node3 $node5 2

$netSimInstance connect $pingAgent0 $pingAgent4
$netSimInstance connect $pingAgent5 $pingAgent1

for {set i 1} {$i < 30} {incr i} {
	$netSimInstance at [expr ($i) * 0.1] "$pingAgent0 send"
}

for {set i 1} {$i < 30} {incr i} {
	$netSimInstance at [expr ($i) * 0.1] "$pingAgent5 send"
}
$netSimInstance at 2.0 "finish"

 $netSimInstance run

#Command to know the number of packets dropped : gawk -f 2.awk traceOutput.tr 
