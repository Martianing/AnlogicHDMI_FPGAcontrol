
`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: anlgoic
// Author: 	xg 
//////////////////////////////////////////////////////////////////////////////////

/*
// 0x01 : red
// 0x02 : green
// 0x03 : blue
// 0x04 : white
// 0x05 : gray red
// 0x06 : gray green
// 0x07 : gray blue
// 0x08 : gray white
// 0x09 : mosaic
// 0x0A : diagonal gray scan
// 0x0B : grid scan
*/

//-------------------------------------------------------------------------------------------
module hdmi_top(   
		input   PXLCLK_I,
        input   PXLCLK_5X_I,
		input	RST_I,
		
		input   		DEN_TPG,
		input [3:0] 	TPG_mode,
		input			LOCKED_I,

		//HDMI
		output			HDMI_CLK_P,
		output			HDMI_D2_P,
		output			HDMI_D1_P,
		output			HDMI_D0_P
		 
	);

wire  			VGA_DE;
wire  [23:0]  	VGA_RGB;	

wire [15:0] VGA_RGB_16;

assign VGA_RGB = {VGA_RGB_16[15:11],3'b0,VGA_RGB_16[10:5],2'b0,VGA_RGB_16[4:0],3'b0};
	

//********************************************************************//
//****************** Parameter and Internal Signal *******************//
//********************************************************************//
//wire define
wire    [11:0]  pix_x   ;   //VGA有效显示区域X轴坐标
wire    [11:0]  pix_y   ;   //VGA有效显示区域Y轴坐标
wire    [15:0]  pix_data;   //VGA像素点色彩信息

//------------- vga_ctrl_inst -------------
vga_ctrl  vga_ctrl_inst
(
    .vga_clk    (PXLCLK_I    ),  //输入工作时钟,频率25MHz,1bit
    .sys_rst_n  (LOCKED_I     ),  //输入复位信号,低电平有效,1bit
    .pix_data   (pix_data   ),  //输入像素点色彩信息,16bit

    .pix_x      (pix_x      ),  //输出VGA有效显示区域像素点X轴坐标,10bit
    .pix_y      (pix_y      ),  //输出VGA有效显示区域像素点Y轴坐标,10bit
    .hsync      (VGA_HS      ),  //输出行同步信号,1bit
    .vsync      (VGA_VS      ),  //输出场同步信号,1bit
    .rgb_valid  (VGA_DE  ),
    .rgb        (VGA_RGB_16     )   //输出像素点色彩信息,16bit
);
 
//------------- vga_pic_inst -------------
vga_pic vga_pic_inst
(
    .vga_clk    (PXLCLK_I    ),  //输入工作时钟,频率25MHz,1bit
    .sys_rst_n  (LOCKED_I      ),  //输入复位信号,低电平有效,1bit
    .pix_x      (pix_x      ),  //输入VGA有效显示区域像素点X轴坐标,10bit
    .pix_y      (pix_y      ),  //输入VGA有效显示区域像素点Y轴坐标,10bit

    .pix_data   (pix_data   )   //输出像素点色彩信息,16bit

);
	
	
hdmi_tx #(.FAMILY("EG4"))	//EF2、EF3、EG4、AL3、PH1
 u3_hdmi_tx
	(
		.PXLCLK_I(PXLCLK_I),
		.PXLCLK_5X_I(PXLCLK_5X_I),

		.RST_N (RST_I),
		
		//VGA
		.VGA_HS (VGA_HS ),
		.VGA_VS (VGA_VS ),
		.VGA_DE (VGA_DE ),
		.VGA_RGB(VGA_RGB),

		//HDMI
		.HDMI_CLK_P(HDMI_CLK_P),
		.HDMI_D2_P (HDMI_D2_P ),
		.HDMI_D1_P (HDMI_D1_P ),
		.HDMI_D0_P (HDMI_D0_P )	
		
	);
	

endmodule
