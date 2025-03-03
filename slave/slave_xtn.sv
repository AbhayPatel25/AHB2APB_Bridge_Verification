class slave_xtn extends uvm_sequence_item;
	
	`uvm_object_utils(slave_xtn)

	rand bit [31:0] Prdata;
	bit	 [31:0] Paddr;
	bit      [31:0] Pwdata;
	bit 	 [3:0]  Pselx;
	bit 	        Penable;
	bit     	Pwrite;

	function new(string name = "slave_xtn");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		super.do_print(printer);
					//srting name	bitstream value		size	radix for printing
		printer.print_field(	"Prdata",	this.Prdata,		32,	UVM_DEC);
		printer.print_field(	"Paddr",	this.Paddr,		32,	UVM_DEC);
		printer.print_field(	"Pwdata",	this.Pwdata,		32,	UVM_DEC);
		printer.print_field(	"Pselx",	this.Pselx,		4,	UVM_DEC);
		printer.print_field(	"Penable",	this.Penable,		1,	UVM_DEC);
		printer.print_field(	"Pwrite",	this.Pwrite,		1,	UVM_DEC);
	endfunction

endclass
