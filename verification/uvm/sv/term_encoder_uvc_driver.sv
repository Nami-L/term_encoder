`ifndef TERM_ENCODER_UVC_DRIVER_SV
`define TERM_ENCODER_UVC_DRIVER_SV

class term_encoder_uvc_driver extends uvm_driver #(term_encoder_uvc_sequence_item);
`uvm_component_utils(term_encoder_uvc_driver)

virtual term_encoder_uvc_if vif;
term_encoder_uvc_config m_config;

extern function new(string name,uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task do_drive();


endclass: term_encoder_uvc_driver


function term_encoder_uvc_driver:: new(string name, uvm_component parent);
super.new(name,parent);
endfunction: new


function void term_encoder_uvc_driver:: build_phase(uvm_phase phase);

//EN EL BUILD VAMOS A OBTENER LAS SEÑALES DEL DUT A TRAVES DE UN HANDLE Y TAMBIEN DEL CONFIG
// POR SI EN UN MOMENTO SE OCUPA
 if (!uvm_config_db#(virtual term_encoder_uvc_if)::get(get_parent(), "", "vif", vif)) begin
    `uvm_fatal(get_name(), "Could not retrieve term_encoder_uvc_if from VIF db")
  end

if (!uvm_config_db#(term_encoder_uvc_config)::get(get_parent(), "", "config", m_config)) begin
    `uvm_fatal(get_name(), "Could not retrieve term_encoder_uvc_config from config db")
  end

endfunction: build_phase

task term_encoder_uvc_driver::run_phase(uvm_phase phase);
forever begin
//PIDE LA TRANSACTION AL SEQUENCER QUE YA GENERO EL SEQUENCE
seq_item_port.get_next_item(req);
//LAS SEÑALES QUE SE HAN OBTENIDO SE VAN AL DO_DRIVE
do_drive();
//YA QUE TERMINO LA TAREA, LE DICE AL SEQUENCER QUE 
//FINALIZO
seq_item_port.item_done();
end
endtask: run_phase

task term_encoder_uvc_driver::do_drive();
//SINCRONIZAMOS
@(vif.cb_drv);
  `uvm_info(get_type_name(), {"\n ------ DRIVER (THERMOMETER ENCODER UVC) ------", req.convert2string()}, UVM_DEBUG)

//PASAMOS LAS SEÑALES QUE SE GENERARON DESDE EL DRIVER AL
//DUT 

vif.cb_drv.thermometer_i <= req.m_thermometer;
vif.cb_drv.enable_i <= req.m_enable;
//@(vif.cb_drv);
endtask: do_drive


`endif //TERM_ENCODER_UVC_DRIVER_SV