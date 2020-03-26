`define InstBusWidth  32    // Width of data bus of instruction memory
`define InstAddrBus   32    // Width of address bus of instruction memory

module instRom (
    input  [`InstAddrBus-1:0]  address,
    output reg [`InstBusWidth-1:0] inst
  );
  
  parameter InstNOP   = 4'd0;  // 0 filled
  parameter InstLOAD  = 4'd1;  // dest, op1, offset  : R[dest] = M[R[op1] + offset]
  parameter InstSTORE = 4'd2;  // src, op1, offset   : M[R[op1] + offset] = R[src]
  parameter InstSET   = 4'd3;  // dest, const        : R[dest] = const
  parameter InstLT    = 4'd4;  // dest, op1, op2     : R[dest] = R[op1] < R[op2]
  parameter InstEQ    = 4'd5;  // dest, op1, op2     : R[dest] = R[op1] == R[op2]
  parameter InstBEQ   = 4'd6;  // op1, const         : R[0] = R[0] + (R[op1] == const ? 2 : 1)
  parameter InstBNE   = 4'd7;  // op1, const         : R[0] = R[0] + (R[op1] != const ? 2 : 1)
  parameter InstADD   = 4'd8;  // dest, op1, op2     : R[dest] = R[op1] + R[op2]
  parameter InstSUB   = 4'd9;  // dest, op1, op2     : R[dest] = R[op1] - R[op2]
  parameter InstSHL   = 4'd10; // dest, op1, op2     : R[dest] = R[op1] << R[op2]
  parameter InstSHR   = 4'd11; // dest, op1, op2     : R[dest] = R[op1] >> R[op2]
  parameter InstAND   = 4'd12; // dest, op1, op2     : R[dest] = R[op1] & R[op2]
  parameter InstOR    = 4'd13; // dest, op1, op2     : R[dest] = R[op1] | R[op2]
  parameter InstINV   = 4'd14; // dest, op1          : R[dest] = ~R[op1]
  parameter InstXOR   = 4'd15; // dest, op1, op2     : R[dest] = R[op1] ^ R[op2]
  
  
  always @ (address) begin
    inst = {InstNOP, 12'b0};
 
    case (address)
      // begin:
      0:  inst = {InstSET,   4'd2, 8'b001};       // SET R2, 32
      1:  inst = {InstSET,   4'd1, 8'd128};       // SET R1, 128
      2:  inst = {InstSET,   4'd3, 8'b001};       // SET R3, 32
      3:  inst = {InstSET,   4'd4, 8'd0};         // SET R4, 0
      4:  inst = {InstINV,   4'd4, 4'd4, 4'd0};   // INV R4, R4
      5:  inst = {InstADD,   4'd2, 4'd2, 4'd3};   // ADD R2, R2, R3
      6:  inst = {InstBNE,   4'd4, 8'd0};         // BNE R4, 0
      7:  inst = {InstSET,   4'd0, 8'd4};         // goto 4
      8:  inst = {InstSTORE, 4'd2, 4'd1, 4'd0};   // STORE R2, R1, 0
    endcase
  end
endmodule