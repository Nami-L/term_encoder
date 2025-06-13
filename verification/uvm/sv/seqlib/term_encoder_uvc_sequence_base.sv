`ifndef TERM_ENCODER_UVC_SEQUENCE_BASE_SV 
`define TERM_ENCODER_UVC_SEQUENCE_BASE_SV

class term_encoder_uvc_sequence_base extends uvm_sequence #(term_encoder_uvc_sequence_item);

`uvm_object_utils(term_encoder_uvc_sequence_base)
rand term_encoder_uvc_sequence_item m_trans;

extern function new(string name = "");
extern virtual task body();

endclass: term_encoder_uvc_sequence_base

function term_encoder_uvc_sequence_base::new(string name ="");
super.new(name);
m_trans = term_encoder_uvc_sequence_item::type_id::create("m_trans");

endfunction:new

task term_encoder_uvc_sequence_base::body();
  start_item(m_trans);
  finish_item(m_trans);
endtask:body

`endif //TERM_ENCODER_UVC_SEQUENCE_BASE_SV