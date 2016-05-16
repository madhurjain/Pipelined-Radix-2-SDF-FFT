---------------------------------------------------------------------------------------
-- Design Name: Decimation-in-Frequency Fast Fourier Transform using Radix-2 
--              Singlepath Delay Feedback Architecture
-- Name: Madhur Jain
-- Create Date: 04/23/2016 11:38:49 PM
-- Description: Performs the basic butterfly operation of + and - on time domain inputs
---------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_complex.ALL;

entity butterfly is
    Port (Clk, En: in std_logic;          
          xt1, xt2 : in complex := to_complex(0.0, 0.0);
          Xk1, Xk2 : out complex);
end butterfly;

architecture Behavioral of butterfly is
begin
    -- perform butterfly +/-
    Xk1 <= xt1 + xt2 when En='1' else to_complex(0.0, 0.0);
    Xk2 <= (xt1 - xt2) when En='1' else to_complex(0.0, 0.0);    
end Behavioral;
