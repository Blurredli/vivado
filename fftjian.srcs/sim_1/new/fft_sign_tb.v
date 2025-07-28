`timescale 1ns/1ps

module fft_dds_signal_recovery_tb;

    parameter CLK_PERIOD = 20;           // 50MHz
    parameter SAMPLES = 500000;
    parameter AMPLITUDE_A = 0.4;         // 
    parameter AMPLITUDE_N = 0.4;         // 

    // ʱ & 
    reg clk;
    reg rst_n;

    // /
    reg  [7:0] D;
    reg  [7:0] noise_ref;
    wire [7:0] A;
    
    
    real val_a;
    real val_n;
    real d_val;
    // ʵģ
    fft_dds_signal_recovery uut (
        .clk(clk),
        .rst_n(rst_n),
        .D(D),
        .noise_ref(noise_ref),
        .A(A)
    );

    // ʱ
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // ź
    real freq_a = 10000;     // A źƵ (Hz)
    real freq_n = 20000;     // Ƶ
    real sample_rate = 1000000; // 1 MHz
    real t;
    integer i;

    initial begin
        rst_n = 0;
        D = 0;
        noise_ref = 0;
        #(10*CLK_PERIOD);
        rst_n = 1;

        for (i = 0; i < SAMPLES; i = i + 1) begin
            t = i / sample_rate;

            // ԭʼ -1~+1 Ҳ
             val_a = AMPLITUDE_A * $sin(2 * 3.1415926 * freq_a * t);
             val_n = AMPLITUDE_N * $sin(2 * 3.1415926 * freq_n * t);
             d_val = val_a + val_n;

            // תΪ 0~255
            D         = $rtoi((d_val + 1.0) * 127.5);
            noise_ref = $rtoi((val_n + 1.0) * 127.5);

            #(50*CLK_PERIOD);
        end

    end

endmodule
