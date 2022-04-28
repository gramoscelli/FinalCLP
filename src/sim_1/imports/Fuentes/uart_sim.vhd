----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.04.2022 16:11:48
-- Design Name: 
-- Module Name: uart_sim - uart_sim_arch
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
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_sim is
    Port ( clk_uart_sim : in STD_LOGIC;
           uart_tx : out STD_LOGIC);
end uart_sim;

architecture uart_sim_arch of uart_sim is
  signal uart_tx_aux: std_logic;
  constant msg_to_send: string := "AUUUlgfsDDDDasd";
begin
  process(clk_uart_sim)
      variable starting: integer := 0;
      variable counter: integer := 0;
      variable index: natural := 0;
      variable chr: std_logic_vector(7 downto 0);
      variable tx_aux: std_logic := '1';
  begin
      if rising_edge(clk_uart_sim) then 
          if starting < 3 then -- wait for 8,68us x 3 = 26us
              if index < msg_to_send'high then -- does not index reach the end of string msg?
                  tx_aux := '1';
                  if counter = 0 then -- start bit
                      uart_tx_aux <= '0';
                      index := index + 1;
                      chr := std_logic_vector(to_unsigned(character'pos(msg_to_send(index)), 8));
                      tx_aux := '0';
                  elsif counter > 0 and counter < 9 then -- data bits
                      tx_aux := chr(counter - 1);
                  end if;
                   
                  counter := counter + 1;
                  if counter = 27 then  -- counter: bit inicio + 8 char bits + 20 stop bits = 27 clocks
                      counter := 0;
                  end if;
              end if;
            else
              starting := starting + 1;
            end if;
      end if;    
      uart_tx <= tx_aux;  
  end process; 

end uart_sim_arch;
