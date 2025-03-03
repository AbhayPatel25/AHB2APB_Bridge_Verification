interface inf(input clock);
                   bit Hresetn;
                   bit  [1:0] Htrans;
		   bit 	[2:0]Hsize; 
		   bit 	Hreadyin;
		   bit 	[31:0]Hwdata; 
		   bit	[31:0]Haddr;
		   bit  Hwrite;
                   bit	[31:0]Prdata;
		   bit 	[31:0]Hrdata;
		   bit 	[1:0]Hresp;
		   bit 	Hreadyout;
		   bit  [3:0]Pselx;
		   bit  Pwrite;
		   bit  Penable; 
		   bit  [31:0] Paddr;
		   bit  [31:0] Pwdata;

		   bit  [2:0] Hburst;
	clocking m_drv_cb @(posedge clock);
		default input #1 output #1;
		output Hresetn,Htrans,Hwrite,Hreadyin,Hwdata,Hsize,Haddr,Hburst;
		input  Hreadyout;
	endclocking

	clocking m_mon_cb @(posedge clock);
		default input #1 output #1;
		input Hresetn,Htrans,Hwrite,Hreadyin,Hwdata,Hrdata,Hreadyout,Hsize,Haddr;
	endclocking
	
	clocking s_drv_cb @(posedge clock);
		default input #1 output #1;
		output Prdata;
		input Pwrite,Pselx;
	endclocking

	clocking s_mon_cb @(posedge clock);
		default input #1 output #1;
		input Prdata,Pwdata,Penable,Pwrite,Pselx,Paddr;
	endclocking


	modport M_DRV_MP(clocking m_drv_cb);
	modport M_MON_MP(clocking m_mon_cb);
	modport S_DRV_MP(clocking s_drv_cb);
	modport S_MON_MP(clocking s_mon_cb);

	property p1;
		@(posedge clock) (!Hreadyout) |=> (Haddr && Hsize && Htrans && Hwrite && Hburst);
	endproperty
	
	property p2;
		@(posedge clock) (Hwrite) |=> (Hwdata);
	endproperty

	property p3;
		@(posedge clock) (!Pwrite)  |-> (Prdata);
	endproperty

endinterface
