`ifndef TOP_ENV_SV
`define TOP_ENV_SV

class top_env extends uvm_env;
  `uvm_component_utils(top_env)

term_encoder_uvc_agent m_term_encoder_agent;
term_encoder_uvc_config m_term_encoder_config;
top_scoreboard m_scoreboard;
top_vsqr vsqr;

extern function new(string name, uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass: top_env


function top_env::new(string name, uvm_component parent);
super.new(name,parent);
endfunction:new

function void top_env::build_phase(uvm_phase phase);
//CREAMOS EL AGENTE 
m_term_encoder_agent = term_encoder_uvc_agent::type_id:: create("m_term_encoder_agent",this);
//2. CREAMOS EL CONFIG
m_term_encoder_config = term_encoder_uvc_config::type_id::create("m_term_encoder_config");
m_term_encoder_config.is_active = UVM_ACTIVE;
uvm_config_db#(term_encoder_uvc_config)::set(this,"m_term_encoder_agent*","config",m_term_encoder_config);
//CREAMOS LA SECUENCIA VIRTUAL
vsqr = top_vsqr::type_id::create("vsqr",this);
//CREAMOS EL SCOREBOARD
m_scoreboard = top_scoreboard::type_id::create("m_term_encoder_scoreboard",this);

endfunction: build_phase

function void top_env::connect_phase(uvm_phase phase);
//CONECTAMOS LA SECUENCIA VIRTUAL
vsqr.m_term_encoder_sequencer = m_term_encoder_agent.m_sequencer;
// CONECTAMOS EL SCOREBOARD AL AGENTE, EL ANALYSIS PORT
m_term_encoder_agent.analysis_port.connect(m_scoreboard.term_encoder_imp_export);



endfunction: connect_phase


`endif  // TOP_TEST_ENV_SV
