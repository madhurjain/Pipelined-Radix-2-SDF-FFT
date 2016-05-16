---------------------------------------------------------------------------------------
-- Design Name: Decimation-in-Frequency Fast Fourier Transform using Radix-2 
--              Singlepath Delay Feedback Architecture
-- Name: Madhur Jain
-- Create Date: 04/23/2016 11:38:49 PM
-- Description: Provides type for twiddle (phase factor co-efficient) ROM and a function 
--              to initialize the ROM with values of Cos and -Sin
----------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.MATH_REAL.ALL;
use work.pkg_complex.ALL;

package pkg_rom is
    type rom_type is array(natural range <>) of complex;    
    function init_twiddle_rom(N : in integer) return rom_type;     
end pkg_rom;

package body pkg_rom is        
    -- generate phase factor coefficients        
    function init_twiddle_rom(N : in integer) return rom_type is
        variable rom : rom_type(0 to N/2 - 1);
        variable theta : real;
    begin
        for i IN 0 to N/2-1 loop
            -- theta = 2.0 * MATH_PI * real(i) / real(2*N);
            theta := 2.0 * MATH_PI * real(i) / real(N);
            rom(i) := to_complex(cos(theta), -sin(theta));
        end loop;
        return rom;
    end function;
    
end package body pkg_rom;
