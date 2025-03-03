class master_xtn extends uvm_sequence_item;
	
	`uvm_object_utils(master_xtn)

	rand bit [31:0] Haddr;
	rand bit [1:0] 	Htrans;
	rand bit [2:0] 	Hsize;
	rand bit 	Hwrite;
	rand bit [31:0]	Hwdata;
	rand bit [2:0]	Hburst;
	rand bit [9:0]  Hlength;
	bit             Hreadyin;
	bit      [31:0]	Hrdata;
	bit 		Hreadyout;
	bit 	 [1:0]	Hresp;
	
	constraint valid_haddr { Haddr inside {[32'h 8000_0000 : 32'h 8000_03FF],
					       [32'h 8400_0000 : 32'h 8400_03FF],
					       [32'h 8800_0000 : 32'h 8800_03FF],
					       [32'h 8C00_0000 : 32'h 8C00_03FF]}; }

	constraint valid_hsize { Hsize inside {0, 1, 2}; }

	constraint aligned_addr { (Hsize == 1) -> (Haddr%2 == 0);
				  (Hsize == 2) -> (Haddr%4 == 0); }

	constraint length_calc { Haddr%1024 + Hlength*(2**Hsize) <= 1023; }
	
	constraint valid_length { (Hburst == 2) -> Hlength == 4;
				  (Hburst == 3) -> Hlength == 4; 
				  (Hburst == 4) -> Hlength == 8; 
				  (Hburst == 5) -> Hlength == 8; 
				  (Hburst == 6) -> Hlength == 16; 
				  (Hburst == 7) -> Hlength == 16; }

	constraint hwrite { Hwrite dist {1:= 10, 0:=10}; }
	
	function new(string name = "master_xtn");
		super.new(name);
	endfunction

	function void do_print (uvm_printer printer);
		super.do_print(printer);
         				//srting name	bitstream value		size	radix for printing
		printer.print_field(	"Haddr",	this.Haddr,		32,	UVM_DEC);
		printer.print_field(	"Htrans",	this.Htrans,		2,	UVM_DEC);
		printer.print_field(	"Hsize",	this.Hsize,		3,	UVM_DEC);
		printer.print_field(	"Hwrite",	this.Hwrite,		1,	UVM_DEC);
		printer.print_field(	"Hwdata",	this.Hwdata,		32,	UVM_DEC);
		printer.print_field(	"Hburst",	this.Hburst,		3,	UVM_DEC);
		printer.print_field(	"Hlength",	this.Hlength,		10,	UVM_DEC);
	endfunction
endclass
