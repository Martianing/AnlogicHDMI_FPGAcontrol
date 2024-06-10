module AHBlite_HDMI(
    input       wire            HCLK,
    input       wire            HRESETn,
    input       wire            HSEL,
    input       wire [31:0]     HADDR,
    input       wire    [2:0]   HBURST,
    input       wire            HMASTLOCK,
    input       wire [1:0]      HTRANS,
    input       wire [2:0]      HSIZE,
    input       wire [3:0]      HPROT,
    input       wire            HWRITE,
    input       wire [31:0]     HWDATA,
    input       wire            HREADY,
    output      wire            HREADYOUT,
    output      wire[31:0]      HRDATA,
    output      wire            HRESP,
         
    output      wire            display_on
    );
 

assign HRESP=1'b0;
assign HREADYOUT=1'b1;

wire display_en;
assign display_en=HSEL & HTRANS[1] & HWRITE & HREADY;

reg dis_en_reg;
always@(posedge HCLK or negedge HRESETn)
    begin
        if(~HRESETn)
            dis_en_reg<=1'b0;
        else if(display_en)
            dis_en_reg<=1'b1;
        else
            dis_en_reg<=dis_en_reg;
    end
 
assign display_on = dis_en_reg ? 1'b1 : 1'b0;


endmodule
