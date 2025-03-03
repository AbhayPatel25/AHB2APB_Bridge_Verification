class env_config extends uvm_object;

	`uvm_object_utils(env_config)

	bit has_scoreboard = 1;
	
	slave_config s_cfg;
	master_config m_cfg;
	
	function new(string name = "env_config");
  		super.new(name);
	endfunction

endclass
