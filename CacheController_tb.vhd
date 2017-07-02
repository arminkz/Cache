library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity CacheController_tb is
end;

architecture bench of CacheController_tb is

  component CacheController 
  	port (
  	clk, readmem, writemem : in std_logic;
  	address: in std_logic_vector (15 downto 0);
  	data : inout std_logic_vector (15 downto 0);
  	memdataready : out std_logic
  	);
  end component;

  signal clk, readmem, writemem: std_logic;
  signal address: std_logic_vector (15 downto 0);
  signal data: std_logic_vector (15 downto 0);
  signal memdataready: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: CacheController port map ( clk          => clk,
                                  readmem      => readmem,
                                  writemem     => writemem,
                                  address      => address,
                                  data         => data,
                                  memdataready => memdataready );

  stimulus: process
  begin
  
    -- Put initialisation code here
	address <= "0000000000000001";
	data <= "0000000000000101";
	writemem <= '1';

    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;