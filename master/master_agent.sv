class master_agent extends uvm_agent;
	
	`uvm_component_utils(master_agent)

	master_config m_cfg;
	
	master_monitor m_monh;
	master_driver m_drvh;
	master_sequencer m_seqrh;

	function new(string name = "master_agent", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db #(master_config)::get(this,"","master_config",m_cfg)))
			`uvm_fatal("MASTER_AGENT","Cannot get() m_cfg from uvm_config_db. Have you set() it in env?")
		
		m_monh = master_monitor::type_id::create("m_monh",this);
		if(m_cfg.is_active == UVM_ACTIVE)
			begin
				m_drvh = master_driver::type_id::create("m_drvh",this);
				m_seqrh = master_sequencer::type_id::create("m_seqrh",this);
			end
	endfunction

	function void connect_phase(uvm_phase phase);
		if(m_cfg.is_active == UVM_ACTIVE)
			m_drvh.seq_item_port.connect(m_seqrh.seq_item_export);
	endfunction
endclass
