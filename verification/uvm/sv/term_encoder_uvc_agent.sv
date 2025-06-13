`ifndef TERM_ENCODER_UVC_AGENT_SV
`define TERM_ENCODER_UVC_AGENT_SV
//AGENTE
class term_encoder_uvc_agent extends uvm_agent;
  `uvm_component_utils(term_encoder_uvc_agent)

  uvm_analysis_port #(term_encoder_uvc_sequence_item) analysis_port;

   term_encoder_uvc_monitor m_monitor;
   term_encoder_uvc_driver m_driver;
   term_encoder_uvc_sequencer m_sequencer;
   term_encoder_uvc_config m_config;


  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : term_encoder_uvc_agent

function term_encoder_uvc_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void term_encoder_uvc_agent::build_phase(uvm_phase phase);
   //OBTENEMOS EL VALOR DE CONFIG, PARA VER SI ES ACTIVO O PASIVO
   if (!uvm_config_db#(term_encoder_uvc_config)::get(this, "", "config", m_config)) begin
     `uvm_fatal(get_name(), "Could not retrive term_encoder_uvc_config from config db")
   end
   //SI EL AGENTE ES ACTIVO ENTONCES SE CREA EL MONITOR, SEQUENCER Y DRIVER
   if (m_config.is_active == UVM_ACTIVE) begin
     m_sequencer = term_encoder_uvc_sequencer::type_id::create("m_sequencer", this);
     m_driver = term_encoder_uvc_driver::type_id::create("m_driver", this);
   end
   //SI EL AGENTE ES PASIVO, SOLO SE CREA EL MONITOR
   m_monitor = term_encoder_uvc_monitor::type_id::create("m_monitor", this);
   analysis_port = new("analysis_port",this);

endfunction : build_phase

function void term_encoder_uvc_agent::connect_phase(uvm_phase phase);
 if(m_config.is_active==UVM_ACTIVE) begin
 m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
 end

// // COMO YA HEMOS CREADO EN ANALYSIS PORT EN EL MONITOR ENTONCES
// //SOLO LO CONECTAMOS CON EL AGENTE

 m_monitor.analysis_port.connect(this.analysis_port);

endfunction : connect_phase




`endif  //TERM_ENCODER_UVC_AGENT_SV
