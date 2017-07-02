library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity RAM_tb is
end entity;

architecture bench of RAM_tb is

  component RAM
  	generic (blocksize : integer := 1024);
  	port (clk, readmem, writemem : in std_logic;
  		addressbus: in std_logic_vector (15 downto 0);
  		databus : inout std_logic_vector (15 downto 0);
  		memdataready : out std_logic);
  end component;

  signal clk, readmem, writemem: std_logic;
  signal addressbus: std_logic_vector (15 downto 0);
  signal databus: std_logic_vector (15 downto 0);
  signal memdataready: std_logic;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: RAM generic map ( blocksize    =>  1024)
                 port map ( clk          => clk,
                            readmem      => readmem,
                            writemem     => writemem,
                            addressbus   => addressbus,
                            databus      => databus,
                            memdataready => memdataready );

  stimulus: process
  begin
  
    -- Put initialisation code here
	readmem <= '1';
	writemem <= '0';
	addressbus <= (others => '0');
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
  