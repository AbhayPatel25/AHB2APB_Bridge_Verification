class master_agent_top extends uvm_env;
	
	`uvm_component_utils(master_agent_top)

	master_agent m_agenth;

	//env_config env_cfg;

	function new(string name = "master_agent_top", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_agenth = master_agent::type_id::create("m_agenth",this);
	endfunction

endclass
