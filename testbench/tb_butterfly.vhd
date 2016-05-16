library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_complex.ALL;

entity tb_butterfly is
end tb_butterfly;

architecture Behavioral of tb_butterfly is
    signal clk, en : std_logic := '0';
    signal xt1, xt2, Xk1, Xk2 : complex;
    constant period : time := 100ns;
begin

uut : entity work.butterfly

 port map(clk, en, xt1, xt2, Xk1, Xk2);

clock: process        
begin
    clk <= '0';
    wait for period / 2;
    clk <= '1';
    wait for period / 2;
end process;
    
stimulus: process
begin
    xt1 <= to_complex(1.0, 0.0);
    xt2 <= to_complex(2.0, 0.0);
    en <= '1';        
    wait for 100ns;
    assert Xk1 = to_complex(3.0, 0.0) and Xk2 = to_complex(-1.0, 0.0) 
        report "error in butterfly calculation # 1"
            severity failure;
                
    xt1 <= to_complex(1.0, 0.0);
    xt2 <= to_complex(2.0, 0.0);
    en <= '0';
    wait for 100ns;
    assert Xk1 = to_complex(0.0, 0.0) and Xk2 = to_complex(0.0, 0.0) 
        report "error in butterfly calculation # 2"
            severity failure;
                
    xt1 <= to_complex(2.0, -1.0);
    xt2 <= to_complex(1.0, -2.25);
    en <= '1';
    wait for 100ns;
    assert Xk1 = to_complex(3.0, -3.25) and Xk2 = to_complex(1.0, 1.25) 
            report "error in butterfly calculation # 3"
                severity failure;
                
    xt1 <= to_complex(-1.1, 1.0);
    xt2 <= to_complex(1.0, 2.0);
    en <= '1';
    wait for 100ns;
    assert Xk1 = to_complex(-0.09375, 3.0) and Xk2 = to_complex(-2.09375, -1.0) 
            report "error in butterfly calculation # 4"
                severity failure;             
  wait;  
end process;
   


end Behavioral;
