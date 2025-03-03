class slave_monitor extends uvm_monitor;
	
	`uvm_component_utils(slave_monitor)
	
	virtual inf.S_MON_MP s_vif;

	slave_config s_cfg;

	uvm_analysis_port #(slave_xtn) s_monitor_ap;

	function new(string name = "slave_monitor", uvm_component parent);
		super.new(name, parent);
		s_monitor_ap = new("s_monitor_ap", this);		
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db #(slave_config)::get(this,"","slave_config",s_cfg)))
			`uvm_fatal("SLAVE_MONITOR","cannot get() s_cfg fron uvm_config_db. Have you set() it?")
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);		
		s_vif = s_cfg.s_vif;
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever 
			collect_data();
	endtask

	task collect_data();
		slave_xtn req;
		req = slave_xtn::type_id::create("req");
		while(s_vif.s_mon_cb.Penable !== 1)
			@(s_vif.s_mon_cb);	
		req.Paddr = s_vif.s_mon_cb.Paddr;
		req.Pwrite = s_vif.s_mon_cb.Pwrite;
		req.Pselx = s_vif.s_mon_cb.Pselx;
		req.Penable = s_vif.s_mon_cb.Penable;
		if(req.Pwrite)
			req.Pwdata = s_vif.s_mon_cb.Pwdata;
		else
			req.Prdata = s_vif.s_mon_cb.Prdata;	
		repeat(2)
			@(s_vif.s_mon_cb);		
		`uvm_info("slave_monitor","salve monitor data",UVM_NONE)		
		req.print();
		s_monitor_ap.write(req);
	endtask
endclass
