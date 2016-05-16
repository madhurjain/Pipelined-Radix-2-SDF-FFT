library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.pkg_complex.ALL;

entity tb_fifo2 is
end tb_fifo2;

architecture Behavioral of tb_fifo2 is
    signal data_in, data_out : complex;
    signal clk : std_logic := '0';
begin
    uut : entity work.fifo2
        generic map(4)
        port map(clk, data_in, data_out);
    
    process
    begin
        clk <= '0';
        wait for 50ns;
        clk <= '1';
        wait for 50ns;
    end process;
    
    process
    begin
        data_in <= to_complex(1.0, -1.0);        
        wait for 100ns;
        assert data_out = to_complex(0.0, 0.0) 
            report "error in FIFO # 1"
                severity failure;
                
        data_in <= to_complex(2.0, -2.0);        
        wait for 100ns;
        assert data_out = to_complex(0.0, 0.0) 
            report "error in FIFO # 2"
                severity failure;
                
        data_in <= to_complex(3.0, -3.0);        
        wait for 100ns;
        assert data_out = to_complex(0.0, 0.0) 
            report "error in FIFO # 3"
                severity failure;
                                                
        data_in <= to_complex(4.0, -4.0);        
        wait for 100ns;
        assert data_out = to_complex(1.0, -1.0) 
            report "error in FIFO # 4"
                severity failure;
                                
        data_in <= to_complex(5.0, -5.0);        
        wait for 100ns;
        assert data_out = to_complex(2.0, -2.0) 
            report "error in FIFO # 5"
                severity failure;     
                
        data_in <= to_complex(6.0, -6.0);        
        wait for 100ns;
        assert data_out = to_complex(3.0, -3.0) 
            report "error in FIFO # 6"
                severity failure;
                
        data_in <= to_complex(7.0, -7.0);        
        wait for 100ns;
        assert data_out = to_complex(4.0, -4.0) 
            report "error in FIFO # 7"
                severity failure;
                
        data_in <= to_complex(8.0, -8.0);        
        wait for 100ns;
        assert data_out = to_complex(5.0, -5.0) 
            report "error in FIFO # 8"
                severity failure;                                                                                                                            
        wait;
    end process;

end Behavioral;
