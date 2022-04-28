-------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/19/2015 10:24:29 AM
-- Design Name: 
-- Module Name: uart_top
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--////////////////////////////////////////////////////////////////////////////////

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
	port(
		clk_pin:      in std_logic;		                  -- Clock input (from pin)
		rst:	  	  in std_logic;	          			  -- Active HIGH reset - is asynchronous
		char_input:   in std_logic_vector(7 downto 0);    -- char from UART
		data_rdy:     in std_logic_vector(0 downto 0);
		counter_data: out std_logic_vector(15 downto 0)
		);
end;
	

architecture counter_arch of counter is
	signal count: natural range 0 to 65535 := 0;
begin
    stm: process(clk_pin)
    begin
		if rising_edge(clk_pin) then
		    if (rst = '1') then
				count <= 0;
			elsif data_rdy(0) = '1' then -- data_rdy(0) solo dura un pulso
				if char_input = "01010101" then -- char 'U'
					count <= count+1;
				elsif char_input = "01000100" then -- char 'D'
					count <= count-1;
				end if;
			end if;
		end if;
    end process;	

	counter_data <= std_logic_vector(to_unsigned(count, 16));
	
end counter_arch;