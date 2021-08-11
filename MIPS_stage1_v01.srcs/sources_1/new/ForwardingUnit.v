module ForwardingUnit (rs,rt,EXE_MEM_RegWr,EXE_MEM_Rd,MEM_WB_Rd,MEM_WB_RegWr,forwardA,forwardB);

    input [4:0]rs;
    input [4:0]rt;
    
    input      EXE_MEM_RegWr;
    input [4:0]EXE_MEM_Rd;

    input [4:0]MEM_WB_Rd;
    input      MEM_WB_RegWr;

    output reg [1:0]forwardA;
    output reg [1:0]forwardB;
    
    initial begin
        forwardA=2'b00;
        forwardB=2'b00;
    end

    always@(*)begin
        if(EXE_MEM_RegWr && EXE_MEM_Rd != 1'b0 && EXE_MEM_Rd == rs)
            forwardA=2'b10;
            else begin
                 if (MEM_WB_RegWr && MEM_WB_Rd != 1'b0 && MEM_WB_Rd == rs)
                    forwardA=2'b01;
                    else
                        forwardA=2'b00;
            end
    end
    
    always@(*)begin
        if(EXE_MEM_RegWr && EXE_MEM_Rd != 1'b0 && EXE_MEM_Rd == rt)
            forwardB=2'b10;
            else begin
                 if (MEM_WB_RegWr && MEM_WB_Rd != 1'b0 && MEM_WB_Rd == rt)
                    forwardB=2'b01;
                    else
                        forwardB=2'b00;
            end
    end

endmodule  //ForwardingUnit