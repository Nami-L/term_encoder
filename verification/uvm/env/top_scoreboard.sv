`ifndef TOP_SCOREBOARD_SV
`define TOP_SCOREBOARD_SV

class top_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(top_scoreboard)
  `uvm_analysis_imp_decl(_term_encoder)
  uvm_analysis_imp_term_encoder #(term_encoder_uvc_sequence_item, top_scoreboard) term_encoder_imp_export;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void write_term_encoder(input term_encoder_uvc_sequence_item t);

  int unsigned m_num_passed;
  int unsigned m_num_failed;
  int unsigned m_num_enable;
  term_encoder_uvc_sequence_item m_term_encoder_queue[$];


endclass : top_scoreboard

function top_scoreboard::new(string name, uvm_component parent);
  super.new(name, parent);
  m_num_failed = 0;
  m_num_passed = 0;
  m_num_enable= 0;
endfunction : new

function void top_scoreboard::build_phase(uvm_phase phase);
  term_encoder_imp_export = new("term_encoder_imp_export", this);
endfunction : build_phase

function void top_scoreboard::write_term_encoder(input term_encoder_uvc_sequence_item t);
  term_encoder_uvc_sequence_item received_trans;
  received_trans = term_encoder_uvc_sequence_item::type_id::create("received_trans");
  received_trans.do_copy(t);
  m_term_encoder_queue.push_back(received_trans);
endfunction : write_term_encoder


function void top_scoreboard::report_phase(uvm_phase phase);

  //  string s;
  //     foreach (m_term_encoder_queue[i]) begin
  //       s = {s, $sformatf("\nTRANS[%3d]: \n", i+1) ,m_term_encoder_queue[i].convert2string(), "\n"};
  //     end
  //     `uvm_info(get_type_name(), s, UVM_DEBUG)
  `uvm_info(get_type_name(), $sformatf("PASSED = %3d, FAILED = %3d, ENABLE= %3d", m_num_passed, m_num_failed,m_num_enable),
            UVM_DEBUG)

endfunction : report_phase


// function bit valor_valido(input logic [6:0] thermometer);
//   bit detector_1 = 0;  //BANDERA PARA INDICAR QUE YA HAY UN 1
//   bit detector_0 = 0;  //BANDERA PARA INDICAR QUE YA HAY UN 0
//   for (int i = 0; i <= 6; i++) begin

//     if (thermometer[i] == 1) begin

//       if (detector_0) begin

//         return 0;
//       end
//       detector_1 = 1;

//     end else begin
//       if (detector_1) begin
//         detector_0 = 1;
//       end
//     end

//   end
//   return 1;

// endfunction : valor_valido

task top_scoreboard::run_phase(uvm_phase phase);
  string s;
    bit paso=0;
  forever begin

    wait (m_term_encoder_queue.size() > 0)

      foreach (m_term_encoder_queue[i]) begin
                 if((m_term_encoder_queue[i].m_enable ==1)) begin
                    m_num_enable++;
        case (m_term_encoder_queue[i].m_thermometer)

          7'd1:
          paso = (m_term_encoder_queue[i].m_binary == 'd1);
          7'd3:
          paso= (m_term_encoder_queue[i].m_binary == 'd2 );
          7'd7:
          paso= (m_term_encoder_queue[i].m_binary == 'd3);
          7'd15:
          paso= (m_term_encoder_queue[i].m_binary == 'd4);
          7'd31:
          paso =(m_term_encoder_queue[i].m_binary == 'd5);
          7'd63:
          paso=(m_term_encoder_queue[i].m_binary == 'd6);
          7'd127:
          paso = (m_term_encoder_queue[i].m_binary == 'd7);
          default: paso=0;
        endcase
        if (paso) begin
        m_num_passed++;
          `uvm_info(get_type_name(), $sformatf(
                    "PASS:  (thermometer=%0d, binary=%0d)",
                    m_term_encoder_queue[i].m_thermometer,
                    m_term_encoder_queue[i].m_binary
                    ), UVM_LOW)
        end else begin
        m_num_failed++;
          `uvm_info(get_type_name(), $sformatf(
                    "FAIL:  (thermometer=%0d, binary=%0d)",
                    m_term_encoder_queue[i].m_thermometer,
                    m_term_encoder_queue[i].m_binary
                    ), UVM_LOW)
      end
      end
      end

        //         if((m_term_encoder_queue[i].m_enable ==1) && (valor_valido(m_term_encoder_queue[i].m_thermometer))) begin

        //             if((m_term_encoder_queue[i].m_thermometer=='d1) && (m_term_encoder_queue[i].m_binary == 'd1))begin
        //             m_num_passed++;
        //              `uvm_info(get_type_name(),
        // $sformatf("PASS:  (thermometer=%0d, binary=%0d)",
        //            m_term_encoder_queue[i].m_thermometer, m_term_encoder_queue[i].m_binary),
        // UVM_LOW)
        //             end else if((m_term_encoder_queue[i].m_thermometer=='d3) && (m_term_encoder_queue[i].m_binary== 'd2))begin
        //                      m_num_passed++;
        //          `uvm_info(get_type_name(),
        // $sformatf("PASS:  (thermometer=%0d, binary=%0d)",
        //            m_term_encoder_queue[i].m_thermometer, m_term_encoder_queue[i].m_binary),
        // UVM_LOW)
        //             end else if((m_term_encoder_queue[i].m_thermometer=='d7) && (m_term_encoder_queue[i].m_binary== 'd3))begin
        //                      m_num_passed++;
        //          `uvm_info(get_type_name(),
        // $sformatf("PASS:  (thermometer=%0d, binary=%0d)",
        //            m_term_encoder_queue[i].m_thermometer, m_term_encoder_queue[i].m_binary),
        // UVM_LOW)
        //             end else if((m_term_encoder_queue[i].m_thermometer=='d15) && (m_term_encoder_queue[i].m_binary== 'd4))begin
        //                      m_num_passed++;
        //          `uvm_info(get_type_name(),
        // $sformatf("PASS:  (thermometer=%0d, binary=%0d)",
        //            m_term_encoder_queue[i].m_thermometer, m_term_encoder_queue[i].m_binary),
        // UVM_LOW)
        //             end else if((m_term_encoder_queue[i].m_thermometer=='d31) && (m_term_encoder_queue[i].m_binary== 'd5))begin
        //                      m_num_passed++;
        //          `uvm_info(get_type_name(),
        // $sformatf("PASS:  (thermometer=%0d, binary=%0d)",
        //            m_term_encoder_queue[i].m_thermometer, m_term_encoder_queue[i].m_binary),
        // UVM_LOW)
        //             end else if((m_term_encoder_queue[i].m_thermometer=='d63) && (m_term_encoder_queue[i].m_binary== 'd6))begin
        //                      m_num_passed++;
        //          `uvm_info(get_type_name(),
        // $sformatf("PASS:  (thermometer=%0d, binary=%0d)",
        //            m_term_encoder_queue[i].m_thermometer, m_term_encoder_queue[i].m_binary),
        // UVM_LOW)
        //             end else if((m_term_encoder_queue[i].m_thermometer=='d127) && (m_term_encoder_queue[i].m_binary== 'd7))begin
        //             m_num_passed++;
        //                          `uvm_info(get_type_name(),
        // $sformatf("PASS:  (thermometer=%0d, binary=%0d)",
        //            m_term_encoder_queue[i].m_thermometer, m_term_encoder_queue[i].m_binary),
        // UVM_LOW)
        //             end else begin
        //                      m_num_failed++; 
        //                                   `uvm_info(get_type_name(),
        // $sformatf("FAIL:  (thermometer=%0d, binary=%0d)",
        //            m_term_encoder_queue[i].m_thermometer, m_term_encoder_queue[i].m_binary),
        // UVM_LOW)
        //         end
        //         end
      //end

    foreach (m_term_encoder_queue[i]) begin
      s = {
        s,
        $sformatf("\nTRANS[%3d]: \n ------ SCOREBOARD (THERMOMETER ENCODER UVC) ------  ", i),
        m_term_encoder_queue[i].convert2string(),
        "\n"
      };
    end
    `uvm_info(get_type_name(), s, UVM_DEBUG)
    s = "";
    //m_term_encoder_queue.delete();     m_num_failed++;

    m_term_encoder_queue.delete();

  end

endtask : run_phase


`endif  //TOP_SCOREBOARD_SV
