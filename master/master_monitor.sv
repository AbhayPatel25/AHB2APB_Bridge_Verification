class master_monitor extends uvm_monitor;
	
	`uvm_component_utils(master_monitor)
	
	virtual inf.M_MON_MP m_vif;	

	master_config m_cfg;

	uvm_analysis_port #(master_xtn) m_monitor_ap;

	function new(string name = "master_monitor", uvm_component parent);
		super.new(name, parent);
		m_monitor_ap = new("m_monitor_ap", this);				
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db #(master_config)::get(this,"","master_config",m_cfg)))
			`uvm_fatal("MASTER_MONITOR","cannot get() m_cfg fron uvm_config_db. Have you set() it?")
	endfunction

	function void connect_phase(uvm_phase phase);
		m_vif = m_cfg.m_vif;
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever
			collect_data();
	endtask

	task collect_data();
		master_xtn req;
		req = master_xtn::type_id::create("req");
		while(m_vif.m_mon_cb.Hreadyout !== 1'b1)
			@(m_vif.m_mon_cb);
		req.Hsize = m_vif.m_mon_cb.Hsize;
		req.Hwrite = m_vif.m_mon_cb.Hwrite;
		req.Haddr = m_vif.m_mon_cb.Haddr;
		req.Htrans = m_vif.m_mon_cb.Htrans;
		req.Hreadyin = m_vif.m_mon_cb.Hreadyin;
		@(m_vif.m_mon_cb);		
		while(m_vif.m_mon_cb.Hreadyout !== 1'b1)
			@(m_vif.m_mon_cb);
		if(m_vif.m_mon_cb.Hwrite == 1)
			req.Hwdata = m_vif.m_mon_cb.Hwdata;
		else 
			req.Hrdata = m_vif.m_mon_cb.Hrdata;
		if(req.Haddr !== 0)
		begin
			`uvm_info("master_monitor","master monitor data",UVM_LOW)
			req.print();
			m_monitor_ap.write(req);
		end
	endtask
endclass
