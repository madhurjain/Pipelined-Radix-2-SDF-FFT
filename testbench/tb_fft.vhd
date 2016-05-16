---------------------------------------------------------------------------------
-- Design Name: Decimation-in-Frequency Fast Fourier Transform using Radix-2 
--              Singlepath Delay Feedback Architecture
-- Name: Madhur Jain
-- Create Date: 04/23/2016 11:38:49 PM
-- Description: Main Test Bench for FFT. Provides various input stimulus 
--              and plots the output waveform
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library ieee_proposed;
use ieee_proposed.fixed_pkg.ALL;
use work.pkg_complex.ALL;
use work.pkg_misc.ALL;

entity tb_fft is
end tb_fft;

architecture Behavioral of tb_fft is  
    constant MAX_SAMPLES : integer := 2**6;
    constant stages : natural := clogb2(MAX_SAMPLES);        
      
    signal clk : std_logic := '0';
    signal data_in, data_out : complex;  
    signal out_reg : complex_array(0 to MAX_SAMPLES-1);                            
    
    constant rev_bit_pos : natural_array := init_reverse_bit_pos(MAX_SAMPLES);
    -- Call the function to create the input data
    constant IP_DATA : complex_array(0 to MAX_SAMPLES-1) := create_ip_table(MAX_SAMPLES);
    
--    constant IP_DATA : T_IP_TABLE := (to_complex(-2.0, 1.2), to_complex(-2.2, 1.7), to_complex(1.0, -2.0), to_complex(-3.0,-3.2), 
--                                      to_complex(4.5, -2.5), to_complex(-1.6, 0.2), to_complex(0.5, 1.5), to_complex(-2.8, -4.2));

--      constant IP_DATA : T_IP_TABLE := (to_complex(-2.0, 1.2), to_complex(-2.2, 1.7), to_complex(1.0, -2.0), to_complex(-3.0,-3.2), 
--                                        to_complex(4.5, -2.5), to_complex(-1.6, 0.2), to_complex(0.5, 1.5), to_complex(-2.8, -4.2),
--                                        to_complex(0.0, 0.0), to_complex(0.0, 0.0), to_complex(0.0, 0.0), to_complex(0.0, 0.0),
--                                        to_complex(0.0, 0.0), to_complex(0.0, 0.0), to_complex(0.0, 0.0), to_complex(0.0, 0.0));    
                                         
--      constant IP_DATA : complex_array(0 to MAX_SAMPLES-1) := 
--        (to_complex(0.0, 0.0), to_complex(0.3826, 0.0), to_complex(0.7071, 0.0), to_complex(0.9238, 0.0), 
--         to_complex(1.0, 0.0), to_complex(0.9238, 0.0), to_complex(0.7071, 0.0), to_complex(0.3886, 0.0),
--         to_complex(0.0, 0.0), to_complex(-0.3826, 0.0), to_complex(-0.7071, 0.0), to_complex(-0.9238, 0.0),
--         to_complex(-1.0, 0.0), to_complex(-0.9238, 0.0), to_complex(-0.7071, 0.0), to_complex(-0.3826, 0.0));
         
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
        data_in <= IP_DATA(i);        
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
            out_reg(rev_bit_pos(index)) <= data_out;
        elsif cnt = 2 * MAX_SAMPLES then            
            psd <= get_power_spectral_density(out_reg);
        elsif cnt > 2*MAX_SAMPLES and cnt < 3*MAX_SAMPLES+1 then
            index :=  cnt - 2*MAX_SAMPLES - 1;
            wave_in <= IP_DATA(index).Re;
            wave_out <= to_sfixed(psd(index), 9, -6);
        else
            wave_in <= to_sfixed(0.0, 9, -6);
            wave_out <= to_sfixed(0.0, 9, -6);
        end if;
    end if;
end process;
    
end Behavioral;
