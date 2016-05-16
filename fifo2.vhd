-------------------------------------------------------------------------------------
-- Design Name: Decimation-in-Frequency Fast Fourier Transform using Radix-2 
--              Singlepath Delay Feedback Architecture
-- Name: Madhur Jain
-- Create Date: 04/23/2016 11:38:49 PM
-- Description: Delay line (FIFO) element used in Radix-2 Single-path Delay Feedback
--------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_complex.ALL;

entity fifo2 is
    Generic (FIFO_DEPTH:positive := 16);
    Port (Clk : in std_logic; data_in : in complex; data_out : out complex);
end fifo2;

architecture Behavioral of fifo2 is
    type memory is array(FIFO_DEPTH-1 downto 0) of complex;
    
begin    
    process(Clk)
        variable SR : memory := (others => to_complex(0.0, 0.0));
    begin
        if Clk'EVENT and Clk = '1' then
            SR := SR(FIFO_DEPTH-2 downto 0) & data_in;  -- left shift
            data_out <= SR(FIFO_DEPTH-1);               -- MSB to output
        end if;    
    end process;                    
end Behavioral;
