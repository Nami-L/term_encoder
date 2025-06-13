`ifndef TERM_ENCODER_UVC_CONFIG_SV
`define TERM_ENCODER_UVC_CONFIG_SV

class term_encoder_uvc_config extends uvm_object;
`uvm_object_utils(term_encoder_uvc_config)

uvm_active_passive_enum is_active= UVM_ACTIVE;
extern function new(string name ="");

endclass: term_encoder_uvc_config

function term_encoder_uvc_config :: new(string name = "");
super.new(name);
endfunction: new



`endif //TERM_ENCODER_UVC_CONFIG_SV

