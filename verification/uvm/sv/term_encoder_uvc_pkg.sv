`ifndef TERM_ENCODER_UVC_PKG_SV
`define TERM_ENCODER_UVC_PKG_SV

package term_encoder_uvc_pkg;

  `include "uvm_macros.svh"
  import uvm_pkg::*;


   `include "term_encoder_uvc_sequence_item.sv"
   `include "term_encoder_uvc_config.sv"
  `include "term_encoder_uvc_sequencer.sv"

   `include "term_encoder_uvc_monitor.sv"
   `include "term_encoder_uvc_driver.sv"
  `include "term_encoder_uvc_agent.sv"

  // Sequence library
  //`include "term_encoder_uvc_sequence_base.sv"

endpackage : term_encoder_uvc_pkg

`endif  //TERM_ENCODER_UVC_PKG_SV
