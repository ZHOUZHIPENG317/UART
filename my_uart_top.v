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
// ��ӭ����EDN��FPGA/CPLD��ѧС��һ�����ۣ�http://group.ednchina.com/1375/
////////////////////////////////////////////////////////////////////////////////
module my_uart_top(
				clk,rst_n,
				rs232_rx,rs232_tx,
				//add by cong
				r_tx_en,r_rx_en,r_pari_mode,
				int_tx_finish,int_rx_finish,pari_err,rx_data
);

input clk;			// 50MHz��ʱ��
input rst_n;		//�͵�ƽ��λ�ź�

input rs232_rx;		// RS232���������ź�
output rs232_tx;	//	RS232���������ź�

input	r_tx_en;	//register tx enable
input	r_rx_en;	//register rx enable
input[1:0]	r_pari_mode;	//pariy mode. 00:non,01:old,10even
output	int_tx_finish;	//interrupt tx finish
output	int_rx_finish;	//interrupt rx finish
output	pari_err;	//parity check error
output	[7:0] rx_data;	//received parallel data�������ݼĴ���������ֱ����һ����������

wire bps_start1,bps_start2;	//���յ����ݺ󣬲�����ʱ�������ź���λ
wire clk_bps1,clk_bps2;		// clk_bps_r�ߵ�ƽΪ��������λ���м������,ͬʱҲ��Ϊ�������ݵ����ݸı�� 
wire[7:0] rx_data;	//�������ݼĴ���������ֱ����һ����������
wire[7:0] tx_data;	//�������ݼĴ���������ֱ����һ����������
wire rx_int;		//���������ж��ź�,���յ������ڼ�ʼ��Ϊ�ߵ�ƽ
//----------------------------------------------------
//������ĸ�ģ���У�speed_rx��speed_tx��������ȫ������Ӳ��ģ�飬�ɳ�֮Ϊ�߼�����
//��������Դ����������е�ͬһ���ӳ�����ò��ܻ�Ϊһ̸��
////////////////////////////////////////////
speed_select		speed_rx(	
							.clk(clk),	//������ѡ��ģ��
							.rst_n(rst_n),
							.bps_start(bps_start1),
							.clk_bps(clk_bps1)
						);

my_uart_rx			my_uart_rx(		
							.clk(clk),	//��������ģ��
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
							.clk(clk),	//������ѡ��ģ��
							.rst_n(rst_n),
							.bps_start(bps_start2),
							.clk_bps(clk_bps2)
						);

my_uart_tx			my_uart_tx(		
							.clk(clk),	//��������ģ��
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
