`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:
// Design Name:    
// Module Name:    my_uart_top
// Project Name:   
// Target Device:  
// Tool versions:  
// Description:
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 欢迎加入EDN的FPGA/CPLD助学小组一起讨论：http://group.ednchina.com/1375/
////////////////////////////////////////////////////////////////////////////////
module my_uart_top(
				clk,rst_n,
				rs232_rx,rs232_tx,
				//add by cong
				r_tx_en,r_rx_en,r_pari_mode,
				int_tx_finish,int_rx_finish,pari_err,rx_data
);

input clk;			// 50MHz主时钟
input rst_n;		//低电平复位信号

input rs232_rx;		// RS232接收数据信号
output rs232_tx;	//	RS232发送数据信号

input	r_tx_en;	//register tx enable
input	r_rx_en;	//register rx enable
input[1:0]	r_pari_mode;	//pariy mode. 00:non,01:old,10even
output	int_tx_finish;	//interrupt tx finish
output	int_rx_finish;	//interrupt rx finish
output	pari_err;	//parity check error
output	[7:0] rx_data;	//received parallel data接收数据寄存器，保存直至下一个数据来到

wire bps_start1,bps_start2;	//接收到数据后，波特率时钟启动信号置位
wire clk_bps1,clk_bps2;		// clk_bps_r高电平为接收数据位的中间采样点,同时也作为发送数据的数据改变点 
wire[7:0] rx_data;	//接收数据寄存器，保存直至下一个数据来到
wire[7:0] tx_data;	//接收数据寄存器，保存直至下一个数据来到
wire rx_int;		//接收数据中断信号,接收到数据期间始终为高电平
//----------------------------------------------------
//下面的四个模块中，speed_rx和speed_tx是两个完全独立的硬件模块，可称之为逻辑复制
//（不是资源共享，和软件中的同一个子程序调用不能混为一谈）
////////////////////////////////////////////
speed_select		speed_rx(	
							.clk(clk),	//波特率选择模块
							.rst_n(rst_n),
							.bps_start(bps_start1),
							.clk_bps(clk_bps1)
						);

my_uart_rx			my_uart_rx(		
							.clk(clk),	//接收数据模块
							.rst_n(rst_n),
							.rs232_rx(rs232_rx),
							.rx_data(rx_data),
							.rx_int(rx_int),
							.clk_bps(clk_bps1),
							.bps_start(bps_start1),
							//add by cong
							.r_rx_en(r_rx_en),
							.r_pari_mode(r_pari_mode),
							.int_rx_finish(int_rx_finish),
							.pari_err(pari_err)
						);
assign tx_data = {rx_data[0],rx_data[1],rx_data[2],rx_data[3],rx_data[4],rx_data[5],rx_data[6],rx_data[7]};
///////////////////////////////////////////						
speed_select		speed_tx(	
							.clk(clk),	//波特率选择模块
							.rst_n(rst_n),
							.bps_start(bps_start2),
							.clk_bps(clk_bps2)
						);

my_uart_tx			my_uart_tx(		
							.clk(clk),	//发送数据模块
							.rst_n(rst_n),
							.rx_data(tx_data),
							.rx_int(rx_int),
							.rs232_tx(rs232_tx),
							.clk_bps(clk_bps2),
							.bps_start(bps_start2),
							//add by cong
							.r_tx_en(r_tx_en),
							.r_pari_mode(r_pari_mode),
							.int_tx_finish(int_tx_finish)
						);

endmodule
