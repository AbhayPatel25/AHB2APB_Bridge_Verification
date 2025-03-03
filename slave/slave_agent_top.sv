class slave_agent_top extends uvm_env;
	
	`uvm_component_utils(slave_agent_top)

	slave_agent s_agenth;

	function new(string name = "slave_agent_top", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		s_agenth = slave_agent::type_id::create("s_agenth",this);
	endfunction

endclass
