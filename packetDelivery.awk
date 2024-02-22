BEGIN{
    rec=0
    drop=0
    total=0
    ratio=0
}
{
    if($1=="r"&&$4==2)
    {
        rec++;
    }
    if($1=="d"&&$4=2)
    {
        drop++;
    }
}
END{
    total=rec+drop
    ratio=(rec/total)*100
    
    printf("Total Packet Sent: %d", total)
    printf("Packet Delivery Ratio: %f", ratio)
    printf("Total Packet Dropped: %d", drop)
}