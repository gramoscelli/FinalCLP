-----------------------------------------------------------------------------
--  
--  Copyright (c) 2009 Xilinx Inc.
--
--  Project  : Programmable Wave Generator
--  Module   : led_ctl.v
--  Parent   : uart_led.v
--  Children : None
--
--  Description: 
--     LED output generator
--
--  Parameters:
--     None
--
--  Local Parameters:
--
--  Notes       : 
--
--  Multicycle and False Paths
--    None
--

library IEEE;
use IEEE.std_logic_1164.all;

entity recpt_stm is
	port(
		clk_rx:			in std_logic;					-- Clock input
		rst_clk_rx:		in std_logic;					-- Active HIGH reset - synchronous to clk_rx
		rx_data:		in std_logic_vector(7 downto 0);-- 8 bit data output
		rx_data_rdy:	in std_logic;					-- valid when rx_data_rdy is asserted
		char_recpt:      out std_logic_vector(7 downto 0);
		new_data:        out std_logic
	);
end;


architecture recpt_stm_arq of recpt_stm is
	signal old_rx_data_rdy: std_logic := '0';
	signal char_data: std_logic_vector(7 downto 0) := "00000000";
	signal new_data_local: std_logic := '0';
begin

	process(clk_rx)
	begin
		if rising_edge(clk_rx) then
			if rst_clk_rx = '1' then
				old_rx_data_rdy <= '0';
				char_recpt      <= "00000000";
				new_data_local  <= '0';
			else
				-- Capture the value of rx_data_rdy for edge detection
				old_rx_data_rdy <= rx_data_rdy;
				-- If rising edge of rx_data_rdy, capture rx_data and generate sync pulse
				if (rx_data_rdy = '1' and old_rx_data_rdy = '0') then
					char_data <= rx_data;			
                    new_data_local <= '1';	
                else -- else reset pulse
                    new_data_local <= '0';	
				end if;
    		end if;	-- if !rst
		end if;
        char_recpt <= char_data;
        new_data <= new_data_local;
	end process;

end;

