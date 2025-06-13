module tb;

  `include "uvm_macros.svh"
  import uvm_pkg::*;

  import top_test_pkg::*;

  // Clock signal
  localparam time CLK_PERIOD = 10ns;
  logic clk_i = 0;
  always #(CLK_PERIOD / 2) clk_i = ~clk_i;

  // Reset signal
  logic rst_i = 1;
  initial begin
    repeat(2) @(posedge clk_i);
    rst_i = 0;
  end

  // Interface
  term_encoder_uvc_if term_encoder_vif (clk_i);

  // DUT Instantiation
  term_encoder dut (
 .thermometer_i(term_encoder_vif.thermometer_i),
 .binary_o(term_encoder_vif.binary_o),
 .enable_i(term_encoder_vif.enable_i)
  );

  initial begin
    $timeformat(-12, 0, "ps", 10);
    uvm_config_db #(virtual term_encoder_uvc_if)::set(null, "uvm_test_top.m_env.m_term_encoder_agent", "vif", term_encoder_vif);
    run_test();
  end

endmodule : tb