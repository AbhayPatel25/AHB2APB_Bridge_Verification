class base_test extends uvm_test;

	`uvm_component_utils(base_test)

	env envh;
	env_config env_cfg;
	
	master_config m_cfg;
	slave_config s_cfg;

	function new(string name = "base_test", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		env_cfg = env_config::type_id::create("env_cfg");
		m_cfg = master_config::type_id::create("m_cfg");
		s_cfg = slave_config::type_id::create("s_cfg");
						
		if(!(uvm_config_db #(virtual inf)::get(this,"","inf",m_cfg.m_vif)))
			`uvm_fatal("TEST","cannot get virtual interface, have you set it in top?")
		m_cfg.is_active = UVM_ACTIVE;
		env_cfg.m_cfg = m_cfg;

		if(!(uvm_config_db #(virtual inf)::get(this,"","inf",s_cfg.s_vif)))
			`uvm_fatal("TEST","cannot get virtual interface, have you set it in top?")
		s_cfg.is_active = UVM_ACTIVE;
		env_cfg.s_cfg = s_cfg;
		
		uvm_config_db #(env_config)::set(this,"*","env_config",env_cfg);

		envh = env::type_id::create("envh", this);
	endfunction
	
	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology;
	endfunction
endclass
		
class single_trans_test extends base_test;
		
	`uvm_component_utils(single_trans_test)

	single_transfer s_seq;

	function new(string name = "single_trans_test" ,uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		repeat(100)
			begin
				phase.raise_objection(this);
				s_seq = single_transfer::type_id::create("s_seq");
				s_seq.start(envh.m_top.m_agenth.m_seqrh);
				#110;
				phase.drop_objection(this);
			end
	endtask     
endclass


class incr_trans_test extends base_test;
		
	`uvm_component_utils(incr_trans_test)

	incr_transfer i_seq;

	function new(string name = "incr_trans_test" ,uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		repeat(100)
			begin
				phase.raise_objection(this);
				i_seq = incr_transfer::type_id::create("i_seq");
				i_seq.start(envh.m_top.m_agenth.m_seqrh);
				#130;
				phase.drop_objection(this);
			end
	endtask     
endclass


class wrap_trans_test extends base_test;
		
	`uvm_component_utils(wrap_trans_test)

	wrap_transfer w_seq;

	function new(string name = "wrap_trans_test" ,uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		repeat(100)
			begin
				phase.raise_objection(this);
				w_seq = wrap_transfer::type_id::create("w_seq");
				w_seq.start(envh.m_top.m_agenth.m_seqrh);
				#160;
				phase.drop_objection(this);
			end
	endtask     
endclass
