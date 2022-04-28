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

entity uart_top is
	port(
		--Write side inputs
		clk_pin: in std_logic;		-- Clock input (from pin)
		-- rst_pin: in std_logic;		-- Active HIGH reset (from pin)
		rxd_pin: in std_logic; 		-- Uart input
		txd_pin: out std_logic
		-- counter_data: out std_logic_vector(15 downto 0) -- counter of data
	);
end;
	

architecture uart_top_arq of uart_top is

	component uart_proxy is
		generic(
			BAUD_RATE: integer := 115200;   
			CLOCK_RATE: integer := 20E6
		);
		port(
			-- Write side inputs
			clk_pin:	in std_logic;      					-- Clock input (from pin)
			rst_pin: 	in std_logic;      					-- Active HIGH reset (from pin)
			rxd_pin: 	in std_logic;      					-- RS232 RXD pin - directly from pin
			data_out: 	out std_logic_vector(7 downto 0);   -- 8 LED outputs
			rx_data_rdy_out: out std_logic
		);
	end component;
	
	component counter is
		port(
			--Write side inputs
			clk_pin:      in std_logic;		                  -- Clock input (from pin)
			rst:          in std_logic;	          			  -- Active HIGH reset - synchronous to clk
			char_input:   in std_logic_vector(7 downto 0);    -- char from UART
			data_rdy:     in std_logic_vector(0 downto 0);
			counter_data: out std_logic_vector(15 downto 0)
		);
	end component;

    COMPONENT vio_0
      PORT (
        clk : IN STD_LOGIC;
        probe_in0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
      );
    END COMPONENT;
    
    COMPONENT ila
        PORT (
            clk : IN STD_LOGIC;
            probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
            probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); 
            probe2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0); 
            probe3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

	signal data_recpt: std_logic_vector(7 downto 0) := "00000000";
    signal rx_data_rdy_out: std_logic_vector(0 downto 0);
    signal counter_data_aux: std_logic_vector(15 downto 0);
    signal rst_aux: std_logic_vector(0 downto 0);
begin

	txd_pin <= rxd_pin; 

	U0: uart_proxy
		generic map(
			BAUD_RATE => 115200,
			CLOCK_RATE => 20E6
		)
		port map(
			clk_pin => clk_pin,  	-- Clock input (from pin)
			rst_pin => rst_aux(0),  	-- Active HIGH reset (from pin)
			rxd_pin => rxd_pin,  	-- RS232 RXD pin - directly from pin
			data_out => data_recpt, 	-- Decoded char 
			rx_data_rdy_out => rx_data_rdy_out(0) -- Pulse of new data
		);

    C0: counter
        port map(
			clk_pin      => clk_pin,  	-- Clock input (from pin)
			rst          => rst_aux(0),
			char_input   => data_recpt, -- char from UART
			data_rdy     => rx_data_rdy_out,
			counter_data => counter_data_aux
		);
	V0: vio_0
          PORT MAP (
            clk        => clk_pin,
            probe_in0  => counter_data_aux,
            probe_out0 => rst_aux
          );
          
          
    --ILA0: ila
    --      PORT MAP (
    --          clk => clk_pin,
    --          probe0 => rxd_pin, 
    --          probe1 => rx_data_rdy_out, 
    --          probe2 => data_recpt, 
    --          probe3 => counter_data_aux
    --      );
end;