class slave_config extends uvm_object;
	
	`uvm_object_utils(slave_config)

	virtual inf s_vif;
		
	uvm_active_passive_enum is_active;

	function new(string name = "slave_config");
		super.new(name);
	endfunction
	
endclass
