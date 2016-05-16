-------------------------------------------------------------------------------------
-- Design Name: Decimation-in-Frequency Fast Fourier Transform using Radix-2 
--              Singlepath Delay Feedback Architecture
-- Name: Madhur Jain
-- Create Date: 04/23/2016 11:38:49 PM
-- Description: Provides miscellaneous types and helper functions for calculating 
--              log to the base 2 of a number, power spectral density of output,
--              create input table based on waveform, etc
--------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use work.pkg_complex.ALL;

package pkg_misc is
    type natural_array is array(natural range <>) of natural;
    type real_array is array(natural range <>) of real;
    function clogb2 (depth: in natural) return integer;
    function reverse_vector(iv : std_logic_vector) return std_logic_vector;
    function init_reverse_bit_pos(size : integer) return natural_array;
    function create_ip_table(size: natural) return complex_array;
    function get_power_spectral_density(Xk: complex_array) return real_array;
end pkg_misc;

package body pkg_misc is
    -- returns log2(N)
    function clogb2(depth : natural) return integer is
        variable temp    : integer := depth;
        variable ret_val : integer := 0; 
    begin					
        while temp > 1 loop
            ret_val := ret_val + 1;
            temp    := temp / 2;     
        end loop;
        return ret_val;
    end function;
    
    -- reverses bit position of a std logic vector
    function reverse_vector(iv : std_logic_vector) return std_logic_vector is
        variable result : std_logic_vector(iv'RANGE);
        alias rev_iv : std_logic_vector(iv'REVERSE_RANGE) is iv;
    begin
        for i IN rev_iv'RANGE loop
            result(i) := rev_iv(i);
        end loop;
        return result;
    end function;
    
    -- initialize an array of integer with reversed bit positions of index as element
    function init_reverse_bit_pos(size : integer) return natural_array is
        variable result : natural_array(0 to size-1) := (others => 0);
        variable t : std_logic_vector(clogb2(size)-1 downto 0); 
    begin
        for i IN 0 to size-1 loop
            t := std_logic_vector(to_unsigned(i, t'length));
            result(i) := to_integer(unsigned(reverse_vector(t)));
        end loop;
        return result;
    end function;
    
    -- Function to generate input data table
    -- Data is a complex sinusoid exp(-jwt) with a frequency 1khz + 500Hz
    function create_ip_table(size: natural) return complex_array is
        variable result : complex_array(0 to size-1);
        variable theta  : real;
    begin
        for i in 0 to size-1 loop
            theta   := 2.0 * MATH_PI * real(i) * 0.0625;
            result(i)   := to_complex(sin(theta) + sin(theta/2.0)/4.0, 0.0);
        end loop;
        return result;
    end function create_ip_table;
    
    function get_power_spectral_density(Xk: complex_array) return real_array is
        variable result : real_array(Xk'RANGE) := (others => 0.0);
        variable Xk_real : real_complex;
    begin
        for i IN Xk'RANGE loop
            Xk_real := to_real_complex(Xk(i));
            result(i) := Xk_real.re * Xk_real.re + Xk_real.im * Xk_real.im;
        end loop;
        return result;
    end function get_power_spectral_density;
end pkg_misc;
