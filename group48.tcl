# generating an NS simulator object instance, and assigns it to variable ns
set ns [new Simulator] 

$ns rtproto DV
$ns color 1 Blue
$ns color 2 Red

set nf [open output.nam w]
$ns namtrace-all $nf 

set nt [open tra.tr w]
$ns trace-all $nt

# In this function, post-simulation processes are specified
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam output.nam &
    exec awk -f throughput.awk tra.tr &
    exec awk -f packetDelivery.awk tra.tr &
    exec awk -f delay.awk tra.tr &
    exit 0
}

# Creating 10 nodes
set node0 [$ns node]
set node1 [$ns node]
set node2 [$ns node]
set node3 [$ns node]
set node4 [$ns node]
set node5 [$ns node]
set node6 [$ns node]
set node7 [$ns node]
set node8 [$ns node]
set node9 [$ns node]
set node10 [$ns node]

# creating 11 simplex links of specified bandwidth and delay, and connects the two specified nodes
$ns duplex-link $node0 $node1 2Mb 10ms DropTail
$ns duplex-link $node1 $node2 2Mb 10ms DropTail
$ns duplex-link $node2 $node3 1.7Mb 4.9ms DropTail
$ns duplex-link $node3 $node4 2Mb 9ms DropTail
$ns duplex-link $node4 $node5 1.5Mb 7ms DropTail
$ns duplex-link $node5 $node6 2Mb 10ms DropTail
$ns duplex-link $node6 $node7 1.9Mb 8.7ms DropTail
$ns duplex-link $node7 $node8 2Mb 10ms DropTail
$ns duplex-link $node8 $node9 1Mb 9.8ms DropTail
$ns duplex-link $node9 $node10 2Mb 10ms DropTail
$ns duplex-link $node10 $node0 2Mb 8ms DropTail

# Setting up a TCP connection
set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $node0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $node5 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

# Setting up a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

$ftp set packet_size_ 500
$ftp set rate_ 2mb


$ns at 1 "$ftp start"
$ns rtmodel-at 2.0 down $node3 $node4
$ns rtmodel-at 4.0 up $node3 $node4

$ns at 6.0 "finish"
$ns run