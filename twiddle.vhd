--------------------------------------------------------------------------------
-- Design Name: Decimation-in-Frequency Fast Fourier Transform using Radix-2 
--              Singlepath Delay Feedback Architecture
-- Name: Madhur Jain
-- Create Date: 04/23/2016 11:38:49 PM
-- Description: Twiddle / Phase Co-Efficient Multiplier
--              Multiplies input with precalculated sin/cos values stored in ROM
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_complex.ALL;
use work.pkg_rom.ALL;

entity twiddle is
    Generic(constant FFT_SIZE : positive := 4);    -- N
    Port (
        CLK : in STD_LOGIC;
        Bypass : in STD_LOGIC;
        rot : natural := 0;
        a : in complex;
        b : out complex
    );
end twiddle;

architecture Behavioral of twiddle is
    -- phase coefficient ROM
    signal W_k : rom_type(0 TO FFT_SIZE/2 - 1) := init_twiddle_rom(FFT_SIZE);           
begin      
    -- pass through the sum part of butterfly to next stage without multiplying
    b <= a when Bypass = '1' else a * W_k(rot);                  
end Behavioral;
