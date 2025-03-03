class env extends uvm_env;

   	`uvm_component_utils(env)
	
	master_agent_top m_top;
	slave_agent_top s_top;
	
	env_config env_cfg;
	scoreboard sb;

	function new(string name = "env", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);		
		if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
			`uvm_fatal("ENV","Cannot get() configuration env_cfg from uvm_config_db. Have you set() it in test?")		
		s_top = slave_agent_top::type_id::create("s_top",this);
		m_top = master_agent_top::type_id::create("m_top",this);
		uvm_config_db #(slave_config)::set(this,"*","slave_config",env_cfg.s_cfg);
		uvm_config_db #(master_config)::set(this,"*","master_config",env_cfg.m_cfg);
		if(env_cfg.has_scoreboard == 1)
			sb = scoreboard::type_id::create("sb",this);
	endfunction
		
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		m_top.m_agenth.m_monh.m_monitor_ap.connect(sb.m_fifo.analysis_export);
		s_top.s_agenth.s_monh.s_monitor_ap.connect(sb.s_fifo.analysis_export);		
	endfunction
endclass
