class scoreboard extends uvm_scoreboard;
	
	`uvm_component_utils(scoreboard)
	
	master_xtn m_xtn;
	slave_xtn s_xtn;
	
	uvm_tlm_analysis_fifo #(master_xtn) m_fifo;
	uvm_tlm_analysis_fifo #(slave_xtn) s_fifo;

	covergroup m_cg;
		HADDR: coverpoint m_xtn.Haddr{	bins b1 = {[32'h 8000_0000 : 32'h 8000_03FF]};
						bins b2 = {[32'h 8400_0000 : 32'h 8400_03FF]};
						bins b3 = {[32'h 8800_0000 : 32'h 8800_03FF]};
						bins b4 = {[32'h 8C00_0000 : 32'h 8C00_03FF]};	}
					       
		HSIZE: coverpoint m_xtn.Hsize{	bins zero = {0};
						bins one  = {1};
						bins two  = {2};  }

		HTRANS: coverpoint m_xtn.Htrans{  bins nseq = {2};
						  bins seq  = {3};  }

		HWRITE: coverpoint m_xtn.Hwrite{  bins rd = {0};
						  bins wr = {1};  }
		
		cross HADDR, HSIZE, HTRANS, HWRITE;
	endgroup

	covergroup s_cg;
		PADDR: coverpoint s_xtn.Paddr{	bins b1 = {[32'h 8000_0000 : 32'h 8000_03FF]};
						bins b2 = {[32'h 8400_0000 : 32'h 8400_03FF]};
						bins b3 = {[32'h 8800_0000 : 32'h 8800_03FF]};
						bins b4 = {[32'h 8C00_0000 : 32'h 8C00_03FF]};	}
					       
		PWRITE: coverpoint s_xtn.Pwrite{  bins rd = {0};
						  bins wr = {1};  }
		
		PSELX: coverpoint s_xtn.Pselx{  bins s1 = {1};
						bins s2 = {2};
						bins s3 = {4};
						bins s4 = {8};  }
		
		cross PADDR, PWRITE;

		//cross PWRITE, PSELX;
	endgroup

	function new (string name = "scoreboard", uvm_component parent);
		super.new(name, parent);
		m_fifo = new("m_fifo", this);
		s_fifo = new("s_fifo", this);
		m_cg = new();
		s_cg = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_xtn = master_xtn::type_id::create("m_xtn");
		s_xtn = slave_xtn::type_id::create("s_xtn");
	endfunction

	task run_phase(uvm_phase phase);
		forever 
		begin
			fork
				begin
					m_fifo.get(m_xtn);
					$display("master_xtn in SB");
					m_xtn.print();
					m_cg.sample();	
				end
				begin
					s_fifo.get(s_xtn);
					$display("slave_xtn in SB");					
					s_xtn.print();
					s_cg.sample();
				end
			join
			check1(m_xtn, s_xtn);			
		end
	endtask

	task compare(int Haddr, Paddr, Hdata, Pdata);
		if(Haddr == Paddr)
			$display("Address matched");
		else
			$display("Address mismatched");
		if(Hdata == Pdata)
			$display("Data matched");
		else
			$display("Data mismatched");
	endtask

	task check1(master_xtn m_xtn, slave_xtn s_xtn);
		if(m_xtn.Hwrite == 1'b1)
			begin
				if(m_xtn.Hsize == 2'b00)
					begin
						if(m_xtn.Haddr[1:0] == 2'b00)
							compare(m_xtn.Haddr, s_xtn.Paddr, m_xtn.Hwdata[7:0], s_xtn.Pwdata);
						if(m_xtn.Haddr[1:0] == 2'b01)
							compare(m_xtn.Haddr, s_xtn.Paddr, m_xtn.Hwdata[15:8], s_xtn.Pwdata);
						if(m_xtn.Haddr[1:0] == 2'b10)
							compare(m_xtn.Haddr, s_xtn.Paddr, m_xtn.Hwdata[23:16], s_xtn.Pwdata);
						if(m_xtn.Haddr[1:0] == 2'b11)
							compare(m_xtn.Haddr, s_xtn.Paddr, m_xtn.Hwdata[31:24], s_xtn.Pwdata);
					end
				if(m_xtn.Hsize == 2'b01)
					begin
						if(m_xtn.Haddr[1:0] == 2'b00)
							compare(m_xtn.Haddr, s_xtn.Paddr, m_xtn.Hwdata[15:0], s_xtn.Pwdata);
						if(m_xtn.Haddr[1:0] == 2'b10)
							compare(m_xtn.Haddr, s_xtn.Paddr, m_xtn.Hwdata[31:16], s_xtn.Pwdata);
					end
				if(m_xtn.Hsize == 2'b10)
					compare(m_xtn.Haddr, s_xtn.Paddr, m_xtn.Hwdata, s_xtn.Pwdata);
			end
		if(m_xtn.Hwrite == 1'b0)
			begin
				if(m_xtn.Hsize == 2'b00)
					begin
						if(m_xtn.Haddr[1:0] == 2'b00)
							compare(m_xtn.Haddr, s_xtn.Paddr, m_xtn.Hrdata, s_xtn.Prdata[7:0]);
						if(m_xtn.Haddr[1:0] == 2'b01)
							compare(m_xtn.Haddr, s_xtn.Paddr, m_xtn.Hrdata, s_xtn.Prdata[15:8]);
						if(m_xtn.Haddr[1:0] == 2'b10)
							compare(m_xtn.Haddr, s_xtn.Paddr, m_xtn.Hrdata, s_xtn.Prdata[23:16]);
						if(m_xtn.Haddr[1:0] == 2'b11)
							compare(m_xtn.Haddr, s_xtn.Paddr, m_xtn.Hrdata, s_xtn.Prdata[31:24]);
					end
				if(m_xtn.Hsize == 2'b01)
					begin
						if(m_xtn.Haddr[1:0] == 2'b00)
							compare(m_xtn.Haddr, s_xtn.Paddr, m_xtn.Hrdata, s_xtn.Prdata[15:0]);
						if(m_xtn.Haddr[1:0] == 2'b10)
							compare(m_xtn.Haddr, s_xtn.Paddr, m_xtn.Hrdata, s_xtn.Prdata[31:16]);
					end
				if(m_xtn.Hsize == 2'b10)
					compare(m_xtn.Haddr, s_xtn.Paddr, m_xtn.Hrdata, s_xtn.Prdata[31:0]);

			end
	endtask
endclass
