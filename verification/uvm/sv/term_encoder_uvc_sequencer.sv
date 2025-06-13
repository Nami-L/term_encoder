`ifndef TERM_ENCODER_UVC_SEQUENCER_SV
`define TERM_ENCODER_UVC_SEQUENCER_SV

class term_encoder_uvc_sequencer extends uvm_sequencer #(term_encoder_uvc_sequence_item);
`uvm_component_utils(term_encoder_uvc_sequencer)

term_encoder_uvc_config m_config;

extern function new(string name, uvm_component parent);
extern function void build_phase(uvm_phase phase);

endclass: term_encoder_uvc_sequencer

function term_encoder_uvc_sequencer::new(string name, uvm_component parent);
super.new(name, parent);
endfunction: new

function void term_encoder_uvc_sequencer::build_phase(uvm_phase phase);
//OBTENEMOS TODO LO QUE TENGA EL CONFIG POR SI SE OCUPA
if(!uvm_config_db#(term_encoder_uvc_config)::get(get_parent(),"","config",m_config))begin
    `uvm_fatal(get_name(), "Could not retrieve term_encoder_uvc_config from config db")

end
endfunction: build_phase


`endif //TERM_ENCODER_UVC_SEQUENCER_SV