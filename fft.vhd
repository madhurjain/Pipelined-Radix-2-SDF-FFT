---------------------------------------------------------------------------------
-- Design Name: Decimation-in-Frequency Fast Fourier Transform using Radix-2 
--              Singlepath Delay Feedback Architecture
-- Name: Madhur Jain
-- Create Date: 04/23/2016 11:38:49 PM
-- Description: Main FFT module that generates stages based on FFT size required
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.pkg_complex.ALL;
use work.pkg_misc.ALL;

entity fft is
    Generic(FFT_SIZE : positive := 16);
    Port (Clk: in std_logic;
          xt: in complex;
          Xk: out complex);
end fft;

architecture Behavioral of fft is
    constant stages : natural := clogb2(FFT_SIZE);
    -- stores intermediate stage outputs
    type stage_output_array is array(stages downto 0) of complex;
    signal StageOutput : stage_output_array := (others => to_complex(0.0, 0.0));
    -- control signal    
    signal counter : std_logic_vector(stages-1 downto 0) := (others => '0');          
begin

-- generates control signals for each butterfly
binary_counter:
process(clk)
begin
    if falling_edge(clk) then
        counter <= counter + 1;
    end if;
end process binary_counter;

--stage1:
--    entity work.stage generic map(2**3) port map(clk, counter(3), StageOutput(4), StageOutput(3));
--stage2:
--    entity work.stage generic map(2**2) port map(clk, counter(2), StageOutput(3), StageOutput(2));
--stage3:
--    entity work.stage generic map(2**1) port map(clk, counter(1), StageOutput(2), StageOutput(1));
--stage4:
--    entity work.stage generic map(2**1) port map(clk, counter(0), StageOutput(1), StageOutput(0));
                                    
-- generate Butterfly/FIFO/Multiplier/ROM stages
-- STAGE_SIZE = 32,16,8,4,2
-- counter bits = 4,3,2,1,0
fft_stages:
for i IN stages downto 1 generate      
begin
fft_inst:
    entity work.stage generic map(2**i) port map(clk, counter(i-1), StageOutput(i), StageOutput(i-1));                
end generate;

StageOutput(stages) <= xt;  -- input
Xk <= StageOutput(0);       -- output
           
end Behavioral;