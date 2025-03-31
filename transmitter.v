module transmitter (
    input wire clk,
    input wire rst,
    input wire [31:0] data,
    input wire start,
    input wire parity_type,
    output reg tx,
    output reg busy
);
    localparam BITS_PER_WORD = 32;
    localparam CLOCK_DIVIDER = 10417;
    
    localparam WAIT_FOR_DATA = 0;
    localparam SEND_START_BIT = 1;
    localparam SEND_DATA_BITS = 2;
    localparam SEND_PARITY_BIT = 3;
    localparam SEND_STOP_BIT = 4;

    reg [2:0] current_state;
    reg [31:0] data_buffer;
    reg [7:0] clock_counter;
    reg [5:0] bit_position;
    reg parity_bit;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= WAIT_FOR_DATA;
            tx <= 1'b1;
            busy <= 1'b0;
            clock_counter <= 0;
            bit_position <= 0;
            data_buffer <= 0;
            parity_bit <= 0;
        end 
        else begin
            if (clock_counter < CLOCK_DIVIDER-1)
                clock_counter <= clock_counter + 1;
            else
                clock_counter <= 0;

            case (current_state)
                WAIT_FOR_DATA: begin
                    tx <= 1'b1;
                    
                    if (start && !busy) begin
                        busy <= 1'b1;
                        data_buffer <= data;
                        parity_bit <= parity_type ? ^data : ~^data;
                        current_state <= SEND_START_BIT;
                        clock_counter <= 0;
                    end
                end

                SEND_START_BIT: begin
                    tx <= 1'b0;
                    
                    if (clock_counter == CLOCK_DIVIDER-1) begin
                        current_state <= SEND_DATA_BITS;
                        bit_position <= 0;
                    end
                end

                SEND_DATA_BITS: begin
                    tx <= data_buffer[bit_position];
                    
                    if (clock_counter == CLOCK_DIVIDER-1) begin
                        if (bit_position == BITS_PER_WORD-1) begin
                            current_state <= SEND_PARITY_BIT;
                        end 
                        else begin
                            bit_position <= bit_position + 1;
                        end
                    end
                end
                
                SEND_PARITY_BIT: begin
                    tx <= parity_bit;
                    
                    if (clock_counter == CLOCK_DIVIDER-1) begin
                        current_state <= SEND_STOP_BIT;
                    end
                end

                SEND_STOP_BIT: begin
                    tx <= 1'b1;
                    
                    if (clock_counter == CLOCK_DIVIDER-1) begin
                        busy <= 1'b0;
                        current_state <= WAIT_FOR_DATA;
                    end
                end
            endcase
        end
    end
endmodule
