module testbench;
    reg clock;
    reg reset;
    reg [31:0] test_data;
    reg start_send;
    reg parity_mode;
    
    wire tx_to_rx;
    wire busy_signal;
    wire [31:0] received_data;
    wire data_received;
    wire parity_err;

    transmitter sender (
        .clk(clock),
        .rst(reset),
        .data(test_data),
        .start(start_send),
        .parity_type(parity_mode),
        .tx(tx_to_rx),
        .busy(busy_signal)
    );

    receiver collector (
        .clk(clock),
        .rst(reset),
        .rx(tx_to_rx),
        .parity_type(parity_mode),
        .data(received_data),
        .data_ready(data_received),
        .parity_error(parity_err)
    );

    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    initial begin
        reset = 1;
        start_send = 0;
        test_data = 0;
        parity_mode = 0;
        
        #100 reset = 0;
        #100;
        
        $display("=== Starting UART Test with Odd Parity ===");
        parity_mode = 0;
        test_data = 32'hA5A5A5A5;
        #10 start_send = 1;
        #20 start_send = 0;
        
        @(posedge data_received);
        #10;
        
        $display("=== Test 1 Results ===");
        $display("Sent:     %h", test_data);
        $display("Received: %h", received_data);
        $display("Parity Error: %b", parity_err);
        
        if (received_data == 32'hA5A5A5A5 && !parity_err)
            $display("TEST 1 PASSED!");
        else
            $display("TEST 1 FAILED!");
            
        #1000;
        
        $display("\n=== Starting UART Test with Even Parity ===");
        parity_mode = 1;
        test_data = 32'h12345678;
        #10 start_send = 1;
        #20 start_send = 0;
        
        @(posedge data_received);
        #10;
        
        $display("=== Test 2 Results ===");
        $display("Sent:     %h", test_data);
        $display("Received: %h", received_data);
        $display("Parity Error: %b", parity_err);
        
        if (received_data == 32'h12345678 && !parity_err)
            $display("TEST 2 PASSED!");
        else
            $display("TEST 2 FAILED!");
        
        #100 $finish;
    end

    initial begin
        $monitor("Time=%0t TX=%b Busy=%b RxState=%0d BitPos=%0d Data=%h Ready=%b ParityErr=%b", 
                 $time, tx_to_rx, busy_signal, collector.current_state, 
                 collector.bit_position, received_data, data_received, parity_err);
    end
endmodule