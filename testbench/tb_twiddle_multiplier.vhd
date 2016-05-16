library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_complex.ALL;

entity tb_twiddle_multiplier is
end tb_twiddle_multiplier;

architecture Behavioral of tb_twiddle_multiplier is
    signal clk, bypass : std_logic := '0';
    signal a, b : complex;
    signal rot : natural := 0;
    constant period : time := 100ns;
begin

uut : entity work.twiddle
    generic map(8)
    port map(clk, bypass, rot, a, b);

clock: process        
begin
    clk <= '0';
    wait for period / 2;
    clk <= '1';
    wait for period / 2;
end process;
    
stimulus: process
begin
    a <= to_complex(1.0, 0.0);
    rot <= 1;
    bypass <= '1';        
    wait for 100ns;
    assert b = to_complex(1.0, 0.0) 
        report "error in twiddle multiplier # 1 (bypass error)"
            severity failure;
                
    a <= to_complex(1.0, 0.0);
    rot <= 1;
    bypass <= '0';
    wait for 100ns;
    assert b = to_complex(0.703125,-0.703125) 
        report "error in twiddle multiplier # 2"
            severity failure;
                
    a <= to_complex(2.0, -1.0);
    rot <= 2;
    bypass <= '0';
    wait for 100ns;
    assert b = to_complex(-1.0, -2.0) 
            report "error in twiddle multiplier # 3"
                severity failure;
                
    a <= to_complex(-1.1, 1.0);
    rot <= 0;
    bypass <= '0';
    wait for 100ns;
    assert b = to_complex(-1.09375, 1.0) 
            report "error in twiddle multiplier # 4"
                severity failure;             
  wait;  
end process;
   


end Behavioral;
