`ifndef TERM_ENCODER_UVC_MONITOR_SV
`define TERM_ENCODER_UVC_MONITOR_SV

class term_encoder_uvc_monitor extends uvm_monitor;
  `uvm_component_utils(term_encoder_uvc_monitor)

uvm_analysis_port #(term_encoder_uvc_sequence_item) analysis_port;
  virtual term_encoder_uvc_if vif;
  term_encoder_uvc_config m_config;
  term_encoder_uvc_sequence_item m_trans;

  

    logic [6:0]tem_thermometer; //
   logic tem_enable; //
  logic [2:0]tem_binary;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task do_mon();


endclass : term_encoder_uvc_monitor

function term_encoder_uvc_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void term_encoder_uvc_monitor::build_phase(uvm_phase phase);
  //EN ESTA PARTE, AL IGUAL QUE EL DRIVER, SE NECESITA TENER ACCESO
  //A LA INTERFAZ VIRTUAL
  // AGREGAMOS EL CONFIG POR SI SE OCUPA
  if (!uvm_config_db#(virtual term_encoder_uvc_if)::get(get_parent(), "", "vif", vif)) begin
    `uvm_fatal(get_name(), "Could not retrieve term_encoder_uvc_if from VIF db")
  end

  if (!uvm_config_db#(term_encoder_uvc_config)::get(get_parent(), "", "config", m_config)) begin
    `uvm_fatal(get_name(), "Could not retrieve term_encoder_uvc_config from config db")
  end

  analysis_port = new("analysis_port", this);

endfunction : build_phase

task term_encoder_uvc_monitor::run_phase(uvm_phase phase);
  // CREAMOS EL OBJETO PORQUE AHORA NECESITAMOS LEER LO QUE TIENE 
  //EL DUT A TRAVES DE LA INTERFAZ
  m_trans = term_encoder_uvc_sequence_item::type_id::create("m_trans");
  do_mon();
endtask : run_phase

task term_encoder_uvc_monitor::do_mon();

  forever begin

    tem_enable = vif.enable_i;
    tem_thermometer= vif.thermometer_i;
    tem_binary = vif.binary_o;

    @(vif.cb_drv);
        if ((tem_enable != vif.enable_i) || (tem_thermometer != vif.thermometer_i) || (tem_binary != vif.binary_o)) begin

        m_trans.m_thermometer = vif.thermometer_i;
        m_trans.m_enable = vif.enable_i;
        m_trans.m_binary = vif.binary_o;

      `uvm_info(get_type_name(), {"\n ------ MONITOR (TimeAlign UVC) ------ ",
                                  m_trans.convert2string()}, UVM_DEBUG)

      analysis_port.write(m_trans);
    
        end
  end

endtask : do_mon


`endif  //TERM_ENCODER_UVC_MONITOR_SV
