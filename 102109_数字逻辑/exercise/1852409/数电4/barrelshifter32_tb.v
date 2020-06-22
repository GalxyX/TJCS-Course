
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/12 19:53:25
// Design Name: 
// Module Name: barrelshifter32_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ns
module barrelshifter32_tb();
    
    reg [31:0] a;
    reg [4:0] b;
    reg [1:0] aluc;
    wire [31:0] c;
    
    
    initial
    begin 
    // �������� 6λ
        a = 32'b11010101_01010101_01011101_01010101;
        b = 5'b0011_0;
        aluc = 2'b00;
    // �߼����� 6λ
        #40
        a = 32'b11010101_01010101_01011101_01010101;        
        b = 5'b0011_0;
        aluc = 2'b10;
    // �������� 2λ   
        #40
        a = 32'b11010101_01010101_01011101_01010101;
        b = 5'b0001_0;
        aluc = 2'b01;
    // �߼����� 4λ
        #40
        a = 32'b11010101_01010101_01011101_01010101;
        b = 5'b0010_0;
        aluc = 2'b11;                     
    // �������� 8λ
        #40
        a = 32'b11010101_01010101_01011101_01010101;
        b = 5'b0100_0;
        aluc = 2'b01;
    // �߼����� 16λ
        #40
        a = 32'b11010101_01010101_01011101_01010101;
        b = 5'b1000_0;
        aluc = 2'b11;
        
    end
    
    barrelshifter32 uul(.a(a), .b(b), .aluc(aluc), .c(c));

endmodule
