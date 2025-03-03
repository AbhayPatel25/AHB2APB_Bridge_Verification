module top();
	
	import test_pkg::*;
   
	import uvm_pkg::*;
	
	bit clock;
	
	inf in(clock);

	rtl_top DUT (.Hclk(clock),
                     .Hresetn(in.Hresetn),
                     .Htrans(in.Htrans),
		     .Hsize(in.Hsize), 
		     .Hreadyin(in.Hreadyin),
		     .Hwdata(in.Hwdata), 
		     .Haddr(in.Haddr),
		     .Hwrite(in.Hwrite),
                     .Prdata(in.Prdata),
		     .Hrdata(in.Hrdata),
		     .Hresp(in.Hresp),
		     .Hreadyout(in.Hreadyout),
		     .Pselx(in.Pselx),
		     .Pwrite(in.Pwrite),
		     .Penable(in.Penable), 
		     .Paddr(in.Paddr),
		     .Pwdata(in.Pwdata));

	initial
	begin
		forever
		#10 clock = ~clock;
	end

	initial
	begin
	
		`ifdef VCS
			$fsdbDumpvars(0,top);
		`endif

		uvm_config_db #(virtual inf)::set(null,"*","inf",in);
	
		run_test();
	end
endmodule

