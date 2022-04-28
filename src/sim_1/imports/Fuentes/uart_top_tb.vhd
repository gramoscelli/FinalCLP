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

entity uart_top_tb is
end;
	

architecture uart_top_tb_arch of uart_top_tb is

	component uart_top is
		port(
			--Write side inputs
			clk_pin: in std_logic;		-- Clock input (from pin)
			-- rst_pin: in std_logic;		-- Active HIGH reset (from pin)
			rxd_pin: in std_logic; 		-- Uart input
			txd_pin: out std_logic
			-- counter_data: out std_logic_vector(15 downto 0) -- counter of data
		);
	end component;
	
	component uart_sim is
        Port ( 
		    clk_uart_sim : in STD_LOGIC;
            uart_tx : out STD_LOGIC
		);
	end component;
	
    signal clk_tb: std_logic := '0';
	signal clk_115: std_logic := '0';
	signal tx_rx_aux: std_logic := '1';
begin
    
	clk_tb <= not clk_tb after 25 ns; -- 20MHz clock
    clk_115 <= not clk_115 after 4341 ns; -- 115200 Hz clock

    UAT: uart_top
		port map(
			rxd_pin => tx_rx_aux,
			clk_pin => clk_tb,
			txd_pin => open
		);
		
    TX: uart_sim
		port map(
			clk_uart_sim => clk_115,
			uart_tx      => tx_rx_aux
		);
end;