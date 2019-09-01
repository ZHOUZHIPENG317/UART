`timescale 1ns/1ns
module tb;
parameter cycle=20;
parameter zhen=52000*cycle;
//parameter 104000=5200*cycle;

reg clk,rst_n,rs232_rx,r_rx_en,r_tx_en;
reg [1:0] r_pari_mode;
wire rs232_tx,int_rx_finish,int_tx_finish,pari_err;
wire [7:0] rx_data;
reg [7:0] a;
reg [7:0] b;
//reg  my_tx_finish;
//reg  my_rx_finish;



my_uart_top u_my_uart_top(
	.clk(clk),
	.rst_n(rst_n),
	.rs232_rx(rs232_rx),
	.r_rx_en(r_rx_en),
	.r_tx_en(r_tx_en),
	.r_pari_mode(r_pari_mode),
	.rs232_tx(rs232_tx),
	.int_rx_finish(int_rx_finish),
	.int_tx_finish(int_tx_finish),
	.pari_err(pari_err),
	.rx_data(rx_data)	

);

task bzc;
begin
rs232_rx=0;
#(104000);
rs232_rx=a[7];
#(104000);
rs232_rx=a[6];
#(104000);
rs232_rx=a[5];
#(104000);
rs232_rx=a[4];
#(104000);
rs232_rx=a[3];
#(104000);
rs232_rx=a[2];
#(104000);
rs232_rx=a[1];
#(104000);
rs232_rx=a[0];
#(104000);
rs232_rx=1;
#(104000);
end
endtask

task bzc1;
begin
rs232_rx=0;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);
end
endtask

task bzc2;
begin
rs232_rx=0;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);
rs232_rx=1;
#(104000);

end
endtask


task czb;
      //output [7:0] b;
begin
	wait(rs232_tx==0);
	#(2600*cycle);
	#(5200*cycle);    
         b[0] = rs232_tx;
             #(5200*cycle);
             b[1] = rs232_tx;
             #(5200*cycle);
             b[2] = rs232_tx;
             #(5200*cycle);
             b[3] = rs232_tx;
             #(5200*cycle);
             b[4] = rs232_tx;
             #(5200*cycle);
             b[5] = rs232_tx;
             #(5200*cycle);
             b[6] = rs232_tx;
             #(5200*cycle);
             b[7] = rs232_tx;
             #(5200*cycle);
end
endtask

task db;
begin
                if (a != b)
                 begin
                $fdisplay(txt,"NG: a=%d,b=%d\n",a,b);
       		 end
        else begin
                $fdisplay(txt, " OK    : a=%d, b=%d\n", a,b);
        end
end    
endtask



initial begin
	clk = 0;
	 forever begin
	   #(cycle/2);
	   clk=~clk;
	 end
end

//integer o,cnt;

initial begin
	/*for(o=1;o<20;o=o+1)
	begin
	rst_n=0;
	cnt=({$random}%3)+1;
	#(cnt*cycle);
	rst_n=1;
	cnt=({$random}%4)+5;
	#(cnt*zhen);
	end*/


        rst_n=0;
	#cycle;
	rst_n=1;
end

task sjs;
begin a [7:0] = {$random} %(8'hff);
end
endtask

integer i;

integer txt;

initial begin
i=0;
b=0;
txt=$fopen("db_log.txt");
//my_rx_finish = 1'b0;
//my_tx_finish = 1'b0;
a=8'h00;
rs232_rx=1;
r_pari_mode=0;
r_rx_en=1;
r_tx_en=0;
//r_tx_en=0;
#(104000);
#(30*zhen);


#(104000);
r_rx_en=1;
a=8'h00;
bzc;
r_rx_en=0;
r_tx_en=1;
#(zhen);
#(2*104000);

#(104000);
r_rx_en=1;
a=8'hff;
bzc;
r_rx_en=0;
r_tx_en=1;
#(zhen);
#(2*104000);

#(104000);
r_rx_en=1;
a=8'h55;
bzc;
r_rx_en=0;
r_tx_en=1;
#(zhen);
#(2*104000);

#(104000);
r_rx_en=1;
a=8'haa;
bzc;
r_rx_en=0;
r_tx_en=1;
#(zhen);
#(2*104000);

#(104000);
r_rx_en=1;
a=8'h12;
bzc;
r_rx_en=0;
r_tx_en=1;
#(zhen);
#(2*104000);

#(104000);
r_rx_en=1;
a=8'h34;
bzc;
r_rx_en=0;
r_tx_en=1;
#(zhen);
#(2*104000);

#(104000);
r_rx_en=1;
bzc1;
r_rx_en=0;
r_tx_en=1;
#(zhen);
#(2*104000);

#(104000);
r_rx_en=1;
bzc2;
r_rx_en=0;
r_tx_en=1;
#(zhen);
#(2*104000);


#(30*zhen);
for(i=1;i<50;i=i+1)begin
        r_rx_en=1;
        sjs;
        bzc;
        r_rx_en=0;
        r_tx_en=1;
        czb;
        db;
end



#(20*zhen);
$finish;
$fclose(txt);
end



//property tx_finish;
//@(posedge clk) $rose(int_tx_finish) |-> ##1 $fell(int_tx_finish);
//endproperty
//assert_int_tx_finish: assert property(tx_finish);

//property rx_finish;
//@(posedge clk) $rose(int_rx_finish) |-> ##1 $fell(int_rx_finish);
//endproperty
//assert_int_rx_finish: assert property(rx_finish);

endmodule
