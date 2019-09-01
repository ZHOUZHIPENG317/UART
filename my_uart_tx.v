`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    17:11:32 08/28/08
// Design Name:    
// Module Name:    my_uart_rx
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
// 
////////////////////////////////////////////////////////////////////////////////
module my_uart_tx(
				clk,rst_n,
				rx_data,rx_int,rs232_tx,
				clk_bps,bps_start,
				//add by cong
				r_tx_en,r_pari_mode,
				int_tx_finish
			);

input clk;			// 50MHz��ʱ��
input rst_n;		//�͵�ƽ��λ�ź�
input clk_bps;		// clk_bps_r�ߵ�ƽΪ��������λ���м������,ͬʱҲ��Ϊ�������ݵ����ݸı��
input[7:0] rx_data;	//�������ݼĴ���
input rx_int;		//���������ж��ź�,���յ������ڼ�ʼ��Ϊ�ߵ�ƽ,�ڸ�ģ�������������½������������ڷ�������
output rs232_tx;	// RS232���������ź�
output bps_start;	//���ջ���Ҫ�������ݣ�������ʱ�������ź���λ
//add by cong
input	r_tx_en;        //register Tx enable
input[1:0]	r_pari_mode;	//pariy mode. 00:non,01:old,10even
output	int_tx_finish;	//interrupt tx finish


//---------------------------------------------------------
reg rx_int0,rx_int1,rx_int2;	//rx_int�źżĴ�������׽�½����˲���
wire neg_rx_int;	// rx_int�½��ر�־λ

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
			rx_int0 <= 1'b0;
			rx_int1 <= 1'b0;
			rx_int2 <= 1'b0;
		end
	else begin
			rx_int0 <= rx_int;
			rx_int1 <= rx_int0;
			rx_int2 <= rx_int1;
		end
end

assign neg_rx_int =  ~rx_int1 & rx_int2;	//��׽���½��غ�neg_rx_int���߱���һ����ʱ������

//---------------------------------------------------------
reg[7:0] tx_data;	//���������ݵļĴ���
//---------------------------------------------------------
reg bps_start_r;
reg tx_en;	//��������ʹ���źţ�����Ч
reg[3:0] num;

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
			bps_start_r <= 1'bz;
			tx_en <= 1'b0;
			tx_data <= 8'd0;
		end
	else if(neg_rx_int) begin	//����������ϣ�׼���ѽ��յ������ݷ���ȥ
			bps_start_r <= 1'b1;
			tx_data <= rx_data;	//�ѽ��յ������ݴ��뷢�����ݼĴ���
//			tx_en <= 1'b1;		//���뷢������״̬��
			tx_en <= r_tx_en;		//���뷢������״̬��, modi by cong
		end
	else if(num==4'd11) begin	//���ݷ�����ɣ���λ
			bps_start_r <= 1'b0;
			tx_en <= 1'b0;
		end
end

assign bps_start = bps_start_r;

//---------------------------------------------------------
reg rs232_tx_r;

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
			num <= 4'd0;
			rs232_tx_r <= 1'b1;
		end
	else if(tx_en) begin
			if(clk_bps)	begin
					num <= num+1'b1;
					case (num)
						4'd0: rs232_tx_r <= 1'b0; 	//������ʼλ
						4'd1: rs232_tx_r <= tx_data[0];	//����bit0
						4'd2: rs232_tx_r <= tx_data[1];	//����bit1
						4'd3: rs232_tx_r <= tx_data[2];	//����bit2
						4'd4: rs232_tx_r <= tx_data[3];	//����bit3
						4'd5: rs232_tx_r <= tx_data[4];	//����bit4
						4'd6: rs232_tx_r <= tx_data[5];	//����bit5
						4'd7: rs232_tx_r <= tx_data[6];	//����bit6
						4'd8: rs232_tx_r <= tx_data[7];	//����bit7
						//modi by cong
						4'd9: if(r_pari_mode==2'b00)rs232_tx_r <= 1'b1;	//���ͽ���λ
						      else if(r_pari_mode==2'b01)rs232_tx_r <= ~(^tx_data);	//old parity
						      else if(r_pari_mode==2'b10)rs232_tx_r <= (^tx_data);	//even parity
						      else rs232_tx_r <= 1'b1;	//���ͽ���λ
					 	default: rs232_tx_r <= 1'b1;
						endcase
				end
			else if(num==4'd11) num <= 4'd0;	//��λ
		end
end

assign rs232_tx = rs232_tx_r;
assign int_tx_finish = (num==4'd11);	//add by cong

endmodule

