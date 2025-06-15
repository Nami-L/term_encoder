`ifndef TOP_COVERAGE_SV
`define TOP_COVERAGE_SV


class top_coverage extends uvm_component;

`uvm_component_utils(top_coverage)
`uvm_analysis_imp_decl(_term_encoder)
uvm_analysis_imp_term_encoder#(term_encoder_uvc_sequence_item,top_coverage) term_encoder_imp_export;


term_encoder_uvc_sequence_item m_trans;
    covergroup m_cov;

    //cp_thermometer: coverpoint m_trans.m_thermometer{bins thermometer_bin[]={[0:7]};}
    cp_thermometer: coverpoint m_trans.m_thermometer {
  bins thermometer_bin[] = {
    7'b0000001,
    7'b0000011,
    7'b0000111,
    7'b0001111,
    7'b0011111,
    7'b0111111,
    7'b1111111,
    7'b1011111
  };
}
    cp_enable: coverpoint m_trans.m_enable{bins enable_bin[]={[0:1]};}
    //cp_msb: coverpoint m_trans.m_msb{bins msb_bin[]={[0:7]}}
        cp_cross: cross m_trans.m_thermometer, m_trans.m_enable;

    endgroup

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);
  extern function void write_term_encoder(input term_encoder_uvc_sequence_item t);

endclass: top_coverage


function top_coverage:: new(string name, uvm_component parent);
super.new(name, parent);
m_trans = term_encoder_uvc_sequence_item::type_id::create("m_trans");
m_cov=new();
endfunction:new

function void top_coverage :: build_phase(uvm_phase phase);
term_encoder_imp_export = new("term_encoder_imp_export",this);
endfunction: build_phase


function void top_coverage::write_term_encoder(input term_encoder_uvc_sequence_item t);
    m_trans = t;
    m_cov.sample();
endfunction : write_term_encoder


function void top_coverage :: report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("FINAL Coverage Score = %3.1f%%", m_cov.get_coverage()), UVM_DEBUG)
// Imprimir detalle de los bins de cada coverpoint

endfunction:report_phase



`endif // TOP_COVERAGE_SV