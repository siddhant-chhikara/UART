module receiver (
    input wire clk,
    input wire rst,
    input wire rx,
    input wire parity_type,
    output reg [31:0] data,
    output reg data_ready,
    output reg parity_error
);
    localparam BITS_PER_WORD = 32;
    localparam CLOCK_DIVIDER = 16;
    localparam SAMPLE_MIDDLE = CLOCK_DIVIDER/2;
    
    localparam WAIT_FOR_START = 0;
    localparam CHECK_START_BIT = 1;
    localparam COLLECT_DATA_BITS = 2;
    localparam CHECK_PARITY_BIT = 3;
    localparam CHECK_STOP_BIT = 4;

    reg [2:0] current_state;
    reg [31:0] data_buffer;
    reg [7:0] clock_counter;
    reg [5:0] bit_position;
    reg rx_parity;
    reg expected_parity;
    
    reg rx_sync1, rx_sync2;
    reg previous_rx;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= WAIT_FOR_START;
            data_buffer <= 0;
            bit_position <= 0;
            data_ready <= 1'b0;
            parity_error <= 1'b0;
            clock_counter <= 0;
            rx_sync1 <= 1'b1;
            rx_sync2 <= 1'b1;
            previous_rx <= 1'b1;
            rx_parity <= 0;
            expected_parity <= 0;
            data <= 0;
        end 
        else begin
            previous_rx <= rx_sync2;
            rx_sync1 <= rx;
            rx_sync2 <= rx_sync1;
            
            if (data_ready) 
                data_ready <= 1'b0;

            case (current_state)
                WAIT_FOR_START: begin
                    parity_error <= 1'b0;
                    
                    if (previous_rx == 1'b1 && rx_sync2 == 1'b0) begin
                        current_state <= CHECK_START_BIT;
                        clock_counter <= 0;
                    end
                end

                CHECK_START_BIT: begin
                    if (clock_counter == SAMPLE_MIDDLE) begin
                        if (rx_sync2 == 1'b0) begin
                            current_state <= COLLECT_DATA_BITS;
                            bit_position <= 0;
                            data_buffer <= 0;
                        end 
                        else begin
                            current_state <= WAIT_FOR_START;
                        end
                    end
                    
                    if (clock_counter < CLOCK_DIVIDER-1)
                        clock_counter <= clock_counter + 1;
                    else
                        clock_counter <= 0;
                end

                COLLECT_DATA_BITS: begin
                    if (clock_counter == SAMPLE_MIDDLE) begin
                        data_buffer[bit_position] <= rx_sync2;
                        
                        if (bit_position == BITS_PER_WORD-1) begin
                            current_state <= CHECK_PARITY_BIT;
                        end 
                        else begin
                            bit_position <= bit_position + 1;
                        end
                    end
                    
                    if (clock_counter < CLOCK_DIVIDER-1)
                        clock_counter <= clock_counter + 1;
                    else
                        clock_counter <= 0;
                end
                
                CHECK_PARITY_BIT: begin
                    if (clock_counter == SAMPLE_MIDDLE) begin
                        rx_parity <= rx_sync2;
                        expected_parity <= parity_type ? ^data_buffer : ~^data_buffer;
                        current_state <= CHECK_STOP_BIT;
                    end
                    
                    if (clock_counter < CLOCK_DIVIDER-1)
                        clock_counter <= clock_counter + 1;
                    else
                        clock_counter <= 0;
                end

                CHECK_STOP_BIT: begin
                    if (clock_counter == SAMPLE_MIDDLE) begin
                        if (rx_sync2 == 1'b1) begin
                            data <= data_buffer;
                            data_ready <= 1'b1;
                            
                            if (rx_parity != expected_parity)
                                parity_error <= 1'b1;
                        end
                        else begin
                            parity_error <= 1'b1;
                        end
                        current_state <= WAIT_FOR_START;
                    end
                    
                    if (clock_counter < CLOCK_DIVIDER-1)
                        clock_counter <= clock_counter + 1;
                    else
                        clock_counter <= 0;
                end
            endcase
        end
    end
endmodule