class master_sequence extends uvm_sequence #(master_xtn);  
	
	`uvm_object_utils(master_sequence)  

	bit [31:0] haddr;
	bit [2:0]  hsize;
	bit [2:0]  hburst;
	bit 	   hwrite;
	bit [9:0]  hlength;

	function new(string name ="master_sequence");
		super.new(name);
	endfunction

endclass


class single_transfer extends master_sequence;

	`uvm_object_utils(single_transfer)
	
	function new(string name = "single_transfer");
		super.new(name);
	endfunction

	task body();
		req = master_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with { Htrans == 2'b10; 
					      Hburst == 3'b000;} );
		finish_item(req);
	endtask
endclass


class incr_transfer extends master_sequence;

	`uvm_object_utils(incr_transfer)
	
	function new(string name = "incr_transfer");
		super.new(name);
	endfunction

	task body();
		req = master_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with { Htrans == 2'b10; 
					      Hburst inside {1, 3, 5, 7}; } );
		finish_item(req);
		haddr = req.Haddr;
		hsize = req.Hsize;
		hwrite = req.Hwrite;
		hlength = req.Hlength;
		hburst = req.Hburst;
		for(int i=1; i<hlength; i++)
		begin
			start_item(req);
			assert(req.randomize() with { Hsize  == hsize;
						      Hburst == hburst;
						      Hlength == hlength;
						      Htrans == 2'b11;
						      Haddr  == haddr + (2**hsize); } );
			finish_item(req);
			haddr = req.Haddr;
		end						
	endtask
endclass


class wrap_transfer extends master_sequence;

	`uvm_object_utils(wrap_transfer)
	
	bit [31:0] start_addr;
	bit [31:0] boundary_addr;

	function new(string name = "wrap_transfer");
		super.new(name);
	endfunction

	task body();
		req = master_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with { Htrans == 2'b10; 
					      Hburst inside {2, 4, 6};} );
		finish_item(req);
		haddr = req.Haddr;
		hsize = req.Hsize;
		hwrite = req.Hwrite;
		hlength = req.Hlength;
		haddr = req.Haddr + (2**hsize);	
		start_addr = int'((haddr/((2**hsize)*hlength))*((2**hsize)*hlength));
		boundary_addr = start_addr + ((2**hsize)*hlength);	
		$display("start addr = %0d, boundary_addr = %0d", start_addr, boundary_addr);			 
		for(int i=1; i<hlength; i++)
			begin
				if(haddr == boundary_addr)
					haddr = start_addr;
				start_item(req);
				assert(req.randomize() with { Htrans == 2'b11;
							      Haddr == haddr;
							      Hburst == hburst;
							      Hsize == hsize;
			                                      Hlength == hlength; } );
				finish_item(req);
				haddr = req.Haddr + (2**hsize);
			end
	endtask
endclass
