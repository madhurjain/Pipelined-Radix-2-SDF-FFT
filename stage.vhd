-------------------------------------------------------------------------------
-- Design Name: Decimation-in-Frequency Fast Fourier Transform using Radix-2 
--              Singlepath Delay Feedback Architecture
-- Name: Madhur Jain
-- Create Date: 04/23/2016 11:38:49 PM
-- Description: Radix-2 stage consisting of a butterfly, delay line (FIFO),
--              twiddle multiplier and internal counter for twiddle ROM address
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_complex.ALL;

entity stage is
    Generic (
        --constant DATA_WIDTH : natural := 16;
        constant STAGE_LENGTH : natural := 4);
    Port (clk, toggle : in std_logic;
          data_in : in complex;          
          data_out : out complex);
end stage;

architecture Behavioral of stage is
    signal fifo_full : std_logic := '0';
    signal tg2 : std_logic := '0';
    signal fifo_in, fifo_out : complex := to_complex(0.0, 0.0);
    signal a, b, bf_sum, bf_diff : complex := to_complex(0.0, 0.0);
    signal multiply_in, multiply_out : complex := to_complex(0.0, 0.0);
    signal W_rot : natural := 0;
begin
    
    -- internal counter for ROM addr of twiddle coefficient
    process(clk)
        variable W_rot_cnt : natural := 0;
    begin
        if clk'event and clk = '1' then
            W_rot_cnt := W_rot + 1;
            if W_rot_cnt = STAGE_LENGTH / 2 then
                W_rot_cnt := 0;
            end if;
            W_rot <= W_rot_cnt;
        end if; 
    end process;
    
    -- first stores upper half of input data
    -- later stores BF difference output
    fifo: entity work.fifo2
        generic map(STAGE_LENGTH/2)
        port map(Clk=>clk, data_in=>fifo_in, data_out=>fifo_out);
        
    -- computes sum and difference of time domain inputs
    butterfly: entity work.butterfly
        port map(CLK=>clk, En=>toggle, xt1=>a, xt2=>b, Xk1=>bf_sum, Xk2=>bf_diff);
    
    -- phase factor multiplier
    -- multiply when En=1/Toggle=0/Data streaming from FIFO Out
    -- pass through when En=0/Toggle=1/Data streaming from BF Sum
    multiplier : entity work.twiddle
            generic map(STAGE_LENGTH)
            port map(CLK=>clk, Bypass=>toggle, rot=>W_rot, a=>multiply_in, b=>multiply_out);    
    -- mux
    -- toggle = 0
    -- load new(upper half) data to FIFO
    -- multiply data stored in FIFO with phase factor and pass to next stage     
                
    -- toggle = 1
    -- store bf diff data to FIFO
    -- pass through bf sum data through multiplier    
    multiply_in <= bf_sum when toggle='1' else fifo_out;
    fifo_in <= bf_diff when toggle='1' else data_in;                      
        
    -- always
    a <= fifo_out;
    b <= data_in;
    data_out <= multiply_out;          
    
end Behavioral;
