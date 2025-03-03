class master_driver extends uvm_driver #(master_xtn);

	`uvm_component_utils(master_driver)

	virtual inf.M_DRV_MP m_vif;

	master_config m_cfg;
	
	function new(string name = "master_driver", uvm_component parent);
		super.new(name, parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db #(master_config)::get(this,"","master_config",m_cfg)))
			`uvm_fatal("MASTER_DRIVER","Cannot get() m_cfg from uvm_config_db. Have you set() it in env?")
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		m_vif = m_cfg.m_vif;
	endfunction
		
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		@(m_vif.m_drv_cb);
		m_vif.m_drv_cb.Hresetn <= 1'b0;
		@(m_vif.m_drv_cb);
		m_vif.m_drv_cb.Hresetn <= 1'b1;
		forever
		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		end
	endtask
	
	task send_to_dut(master_xtn req);
		while(m_vif.m_drv_cb.Hreadyout !== 1'b1)
			@(m_vif.m_drv_cb);
		m_vif.m_drv_cb.Haddr <= req.Haddr;
		m_vif.m_drv_cb.Hsize <= req.Hsize;
		m_vif.m_drv_cb.Hwrite <= req.Hwrite;
		m_vif.m_drv_cb.Htrans <= req.Htrans;
		m_vif.m_drv_cb.Hburst <= req.Hburst;
		m_vif.m_drv_cb.Hreadyin <= 1'b1;
		@(m_vif.m_drv_cb);
		while(m_vif.m_drv_cb.Hreadyout !== 1'b1)
			@(m_vif.m_drv_cb);
		if(req.Hwrite)
			m_vif.m_drv_cb.Hwdata <= req.Hwdata;
		`uvm_info("master_driver","master driver data",UVM_NONE)		
		req.print();
	endtask		
endclass
