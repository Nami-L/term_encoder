`ifndef TERM_ENCODER_UVC_SEQUENCE_ITEM_SV
`define TERM_ENCODER_UVC_SEQUENCE_ITEM_SV

class term_encoder_uvc_sequence_item extends uvm_sequence_item;
`uvm_object_utils (term_encoder_uvc_sequence_item)


//TRANSACTION VARIABLES: INPUTS
    rand logic [6:0] m_thermometer; //
    rand logic m_enable; //
//READ VARIABLES :OUTPUTS
    logic [2:0] m_binary;    // 


extern function new(string name ="");
extern function void do_copy(uvm_object rhs);
extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
extern function void do_print(uvm_printer printer);
extern function string convert2string();

endclass:term_encoder_uvc_sequence_item

function term_encoder_uvc_sequence_item::new(string name ="");
super.new(name);
endfunction: new

function void term_encoder_uvc_sequence_item::do_copy(uvm_object rhs);
term_encoder_uvc_sequence_item rhs_;

 if (!$cast(rhs_, rhs)) `uvm_fatal(get_type_name(), "Cast of rhs object failed")
  super.do_copy(rhs);

     m_thermometer = rhs_.m_thermometer;
     m_enable = rhs_.m_enable; 
     m_binary = rhs_.m_binary;    

endfunction: do_copy


function bit term_encoder_uvc_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);
bit result;
term_encoder_uvc_sequence_item rhs_;
  if (!$cast(rhs_, rhs)) `uvm_fatal(get_type_name(), "Cast of rhs object failed")

result = super.do_compare(rhs, comparer);
result &= (m_thermometer == rhs_.m_thermometer);
result &= (m_enable == rhs_.m_enable);
result &= (m_binary == rhs_.m_binary);
return result;
endfunction: do_compare

function void term_encoder_uvc_sequence_item::do_print(uvm_printer printer);
  if (printer.knobs.sprint == 0) `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
  else printer.m_string = convert2string();
endfunction: do_print



function string term_encoder_uvc_sequence_item::convert2string();

  string s;
  s = super.convert2string();
  $sformat(s, {s, "\n", "TRANSACTION INFORMATION (THERMOMETER ENCODER UVC):"});
  $sformat(s, {s, "\n", "m_thermometer = %5d, m_enable = %5d, m_binary = %5d\n"}, m_thermometer,
           m_enable, m_binary);
  return s;

endfunction: convert2string



`endif //TERM_ENCODER_UVC_SEQUENCE_ITEM_SV