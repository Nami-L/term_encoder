`ifndef TOP_TEST_VSEQ_SV
`define TOP_TEST_VSEQ_SV

class top_test_vseq extends uvm_sequence;
`uvm_object_utils(top_test_vseq)
`uvm_declare_p_sequencer(top_vsqr)


extern function new (string name ="");
extern task term_encoder_rand_seq();
extern task body();

endclass:top_test_vseq

function top_test_vseq::new(string name = "");
super.new(name);
endfunction:new

task top_test_vseq::term_encoder_rand_seq();
term_encoder_uvc_sequence_base seq;
seq = term_encoder_uvc_sequence_base::type_id::create("seq");

  if (!(seq.randomize() with {
        // m_trans no se declara ni se crea en top_test_vseq, porque ya está declarado y 
        // creado dentro de la clase uvc_sequence_base

        //el objeto es m_tras y accedemos al item
        m_trans.m_thermometer inside {[0 :7]};
        m_trans.m_enable inside {[0 :1 ]};

      }))
    `uvm_fatal("RAND_ERROR", "Randomization error!")
  seq.start(p_sequencer.m_term_encoder_sequencer);
endtask: term_encoder_rand_seq



task top_test_vseq::body();

  // Initial delay
  #(30ns);

  repeat (15) begin
    term_encoder_rand_seq();
    //#(10ns);
  end

  // Drain time
  #(15ns);

endtask : body

`endif // TOP_TEST_VSEQ_SV