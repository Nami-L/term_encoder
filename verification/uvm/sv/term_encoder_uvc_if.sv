`ifndef TERM_ENCODER_UVC_IF_SV
`define TERM_ENCODER_UVC_IF_SV

interface term_encoder_uvc_if (
 input logic clk_i
);

 logic [6:0] thermometer_i;
 logic [2:0] binary_o;
 logic enable_i;
//valores por defecto
initial begin
thermometer_i='d0;
enable_i='d0;  
end

  clocking cb_drv @(posedge clk_i);
    default input #1ns output #1ns;
    output thermometer_i;
    output enable_i;
  endclocking : cb_drv

  clocking cb_mon @(posedge clk_i);
    default input #1ns output #1ns;
    input binary_o;
  endclocking : cb_mon


endinterface : term_encoder_uvc_if

`endif // TERM_ENCODER_UVC_IF_SV