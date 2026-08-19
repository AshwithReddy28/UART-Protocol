module uart_tx #(
    parameter CLK_FREQ  = 10000000,   // 10 MHz
    parameter BAUD_RATE = 115200
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       tx_start,
    input  wire [7:0] data_in,
    output reg        tx,
    output reg        busy
);

localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

reg [1:0] state;
reg [15:0] clk_count;
reg [2:0] bit_index;
reg [7:0] tx_data;

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        state      <= IDLE;
        tx         <= 1'b1;
        busy       <= 1'b0;
        clk_count  <= 16'd0;
        bit_index  <= 3'd0;
        tx_data    <= 8'd0;
    end
    else
    begin
        case(state)

        IDLE:
        begin
            tx        <= 1'b1;
            busy      <= 1'b0;
            clk_count <= 16'd0;
            bit_index <= 3'd0;

            if(tx_start)
            begin
                busy    <= 1'b1;
                tx_data <= data_in;
                state   <= START;
            end
        end

        START:
        begin
            tx <= 1'b0;

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else
            begin
                clk_count <= 0;
                state <= DATA;
            end
        end

        DATA:
        begin
            tx <= tx_data[bit_index];

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else
            begin
                clk_count <= 0;

                if(bit_index < 7)
                    bit_index <= bit_index + 1;
                else
                begin
                    bit_index <= 0;
                    state <= STOP;
                end
            end
        end

        STOP:
        begin
            tx <= 1'b1;

            if(clk_count < CLKS_PER_BIT-1)
                clk_count <= clk_count + 1;
            else
            begin
                clk_count <= 0;
                state <= IDLE;
                busy <= 1'b0;
            end
        end

        default:
            state <= IDLE;

        endcase
    end
end

endmodule