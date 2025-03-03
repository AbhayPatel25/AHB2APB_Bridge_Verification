class slave_driver extends uvm_driver #(slave_xtn);

	`uvm_component_utils(slave_driver)

	virtual inf.S_DRV_MP s_vif;
	slave_config s_cfg;
	
	function new(string name = "slave_driver", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db #(slave_config)::get(this,"","slave_config",s_cfg)))
			`uvm_fatal("SLAVE_DRIVER","Cannot get() s_cfg from uvm_config_db. Have you set() it in env?")
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		s_vif = s_cfg.s_vif;
	endfunction
		
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever	
			send_to_dut();
	endtask

	task send_to_dut();
		while(s_vif.s_drv_cb.Pselx !== (1|2|4|8))
			@(s_vif.s_drv_cb);
		if(s_vif.s_drv_cb.Pwrite == 0)
			s_vif.s_drv_cb.Prdata <= $random;
		repeat(2)
			@(s_vif.s_drv_cb);
	endtask
endclass
