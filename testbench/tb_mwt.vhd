---------------------------------------------------------------------------------
-- Design Name: Decimation-in-Frequency Fast Fourier Transform using Radix-2 
--              Singlepath Delay Feedback Architecture
-- Name: Madhur Jain
-- Create Date: 05/2/2016 02:30:29 AM
-- Test Bench for 8 to 64-Point Modified Walsh Transform
-- Note: Set multiplier stage Bypass input to '1' for MWT
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library ieee_proposed;
use ieee_proposed.fixed_pkg.ALL;
use work.pkg_complex.ALL;
use work.pkg_misc.ALL;

entity tb_mwt is
end tb_mwt;

architecture Behavioral of tb_mwt is  
    constant MAX_SAMPLES : integer := 2**6;
    constant stages : natural := clogb2(MAX_SAMPLES);        
      
    signal clk : std_logic := '0';
    signal data_in, data_out : complex;  
    signal out_reg : complex_array(0 to MAX_SAMPLES-1);                            
    
    constant rev_bit_pos : natural_array := (0, 1, 2, 3, 4, 5, 6, 7);
    
    -- Function to generate input data table for MWT
    -- x(0) = a, x(1) = b, x(4) = c, x(5) = d, x(16) = e, x(17) = f, x(20) = g, x(21) = h
    function create_mwt_ip(size: natural) return complex_array is
        variable result : complex_array(0 to size-1) := (others => to_complex(0.0, 0.0));
    begin
        result(0) := to_complex(1.0, 0.0);
        result(1) := to_complex(0.0, 0.0);
        result(4) := to_complex(1.0, 0.0);
        result(5) := to_complex(0.0, 0.0);
        result(16) := to_complex(0.0, 0.0);
        result(17) := to_complex(1.0, 0.0);
        result(20) := to_complex(1.0, 0.0);
        result(21) := to_complex(0.0, 0.0);
        return result;
    end function create_mwt_ip;
    
    -- 1, 0, 1, 0, 0, 1, 1, 0 Input
    -- 4, 2, 0, -2, 0, 2, 0, 2 Output
    constant IP_DATA_MWT: complex_array(0 to MAX_SAMPLES-1) := create_mwt_ip(MAX_SAMPLES);    
         
      signal psd : real_array(0 to MAX_SAMPLES-1) := (others => 0.0); 
      signal wave_in, wave_out : fpoint16;   
begin    

uut : entity work.fft
        generic map(MAX_SAMPLES)
        port map(clk=>clk, xt=>data_in, Xk=>data_out);
                        
clock: process    
begin
    clk <= '0';
    wait for 1ns;
    clk <= '1';
    wait for 1ns;
end process clock;   
    
stimulus: process
begin
    for i IN 0 to MAX_SAMPLES-1 loop
        --data_in <= to_complex(real(i+1), -real(i+1));
        --data_in <= IP_DATA(i);
        data_in <= IP_DATA_MWT(i);        
        wait for 2ns;        
    end loop;                    
    wait;
end process stimulus;

output: process(clk)
    variable cnt : natural := 0;
    variable index : natural := 0;    
begin
    if rising_edge(clk) then
        cnt := cnt + 1;
        if cnt > MAX_SAMPLES-1 and cnt < 2 * MAX_SAMPLES then
            index := cnt-MAX_SAMPLES;
            out_reg(index) <= data_out;
        elsif cnt = 2 * MAX_SAMPLES then            
            psd <= get_power_spectral_density(out_reg);
        elsif cnt > 2*MAX_SAMPLES and cnt < 3*MAX_SAMPLES+1 then
            index :=  cnt - 2*MAX_SAMPLES - 1;
            wave_in <= IP_DATA_MWT(index).Re;
            wave_out <= to_sfixed(psd(index), 9, -6);
        else
            wave_in <= to_sfixed(0.0, 9, -6);
            wave_out <= to_sfixed(0.0, 9, -6);
        end if;
    end if;
end process;
    
end Behavioral;
