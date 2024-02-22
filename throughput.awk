BEGIN{
    ss-time=0
    ff_time=0
    flag=0
    f_size=0
    throughput=0
    latency=0
}
{
    if($1=="r"&&$4==4)
    {
        f_size+=$6
        if(flag==0)
        {
            ss-time=$2
            flag=1
        }
        ff_time=$2
    }
}
END{
    latency=ff_time-ss-time
    throughput=(f_size*8)/latency
    printf("\n Latnecy : %f" , latency)
    printf("\n Throughput : %f", throughput)
}