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
  int unsigned m_num_invalid;
  term_encoder_uvc_sequence_item m_term_encoder_queue[$];


endclass : top_scoreboard

function top_scoreboard::new(string name, uvm_component parent);
  super.new(name, parent);
  m_num_failed  = 0;
  m_num_passed  = 0;
  m_num_enable  = 0;
  m_num_invalid = 0;
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
  `uvm_info(get_type_name(), $sformatf(
            "PASSED = %3d, FAILED = %3d, ENABLE= %3d, INVALID = %3d",
            m_num_passed,
            m_num_failed,
            m_num_enable,
            m_num_invalid
            ), UVM_DEBUG)

endfunction : report_phase


function bit valor_valido(input logic [6:0] thermometer);
  bit detector_1 = 0;  //BANDERA PARA INDICAR QUE YA HAY UN 1
  bit detector_0 = 0;  //BANDERA PARA INDICAR QUE YA HAY UN 0
  for (int i = 0; i <= 6; i++) begin
    if (thermometer[i] == 1) begin
      if (detector_0) begin
        return 0;
      end
      detector_1 = 1;
    end else begin
      if (detector_1) begin
        detector_0 = 1;
      end
    end
  end
  return 1;
endfunction : valor_valido

// 0000011
// primera iteracion detector_1 =1
// segunda iteracion detector_1 =1 
// tercera iteracion detector_0=1
// cuarta iteracion detector_0=1
// quinta iteracion detector_0=1
// sexta iteracion detector_0=1
// septima iteracion detector_0=1
//  Palabra Valida = 0000011;

//  0000101
//  primera iteracion detector_1 =1
// segunda iteracion detector_0 =1
// tercera iteracion detector_0=1 //termina la ejecución

// Palabra no valida= 0000101;



task top_scoreboard::run_phase(uvm_phase phase);
  string s;
  bit paso = 0;

  forever begin

    wait (m_term_encoder_queue.size() > 0)

      foreach (m_term_encoder_queue[i]) begin

        //&& valor_valido(m_term_encoder_queue[i].m_thermometer)
        if ((m_term_encoder_queue[i].m_enable == 1)) begin
                     `uvm_info(get_type_name(),
             $sformatf("Thermometer recibido: %07b", m_term_encoder_queue[i].m_thermometer),
             UVM_LOW)

          `uvm_info(get_type_name(), $sformatf("Validez: %0d", valor_valido(
                                               m_term_encoder_queue[i].m_thermometer)), UVM_LOW)


          m_num_enable++;
          if (valor_valido(m_term_encoder_queue[i].m_thermometer)) begin
case (m_term_encoder_queue[i].m_thermometer)
  7'b0000001: paso = (m_term_encoder_queue[i].m_binary == 1);
  7'b0000011: paso = (m_term_encoder_queue[i].m_binary == 2);
  7'b0000111: paso = (m_term_encoder_queue[i].m_binary == 3);
  7'b0001111: paso = (m_term_encoder_queue[i].m_binary == 4);
  7'b0011111: paso = (m_term_encoder_queue[i].m_binary == 5);
  7'b0111111: paso = (m_term_encoder_queue[i].m_binary == 6);
  7'b1111111: paso = (m_term_encoder_queue[i].m_binary == 7);
  default: paso = 0;
endcase
            // end else begin
            //   paso = 0;
            //   m_num_invalid++;
            //   `uvm_info(get_type_name(), $sformatf(
            //             "INVALID:  (thermometer=%0d, binary=%0d)",
            //             m_term_encoder_queue[i].m_thermometer,
            //             m_term_encoder_queue[i].m_binary
            //             ), UVM_LOW)
            // end


            if (paso) begin
              m_num_passed++;
              `uvm_info(get_type_name(), $sformatf("PASS:  (thermometer=%0b, binary=%0d)",
                                                   m_term_encoder_queue[i].m_thermometer,
                                                   m_term_encoder_queue[i].m_binary), UVM_LOW)


            end else begin
              m_num_failed++;
              `uvm_info(get_type_name(), $sformatf(
                        "FAIL:  (thermometer=%0d, binary=%0d)",
                        m_term_encoder_queue[i].m_thermometer,
                        m_term_encoder_queue[i].m_binary
                        ), UVM_LOW)

            end
          end else begin
            m_num_invalid++;
            `uvm_info(get_type_name(), $sformatf(
                      "INVALID:  (thermometer=%0d, binary=%0d)",
                      m_term_encoder_queue[i].m_thermometer,
                      m_term_encoder_queue[i].m_binary
                      ), UVM_LOW)m_term_encoder_queue.delete();


          end

        end
      end
      m_term_encoder_queue.delete();

    foreach (m_term_encoder_queue[i]) begin
      `uvm_info(get_type_name(), "Bits de thermometer:", UVM_LOW)
      for (int j = 0; j <= 6; j++) begin
        `uvm_info(get_type_name(), $sformatf(
                  "  bit[%0d] = %0b", j, m_term_encoder_queue[i].m_thermometer[j]), UVM_LOW)
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
    //m_term_encoder_queue.delete();     m_num_failed++
    m_term_encoder_queue.delete();

  end

endtask : run_phase


`endif  //TOP_SCOREBOARD_SV
