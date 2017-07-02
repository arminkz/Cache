library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Cache_tb is
end;

architecture bench of Cache_tb is

  component Cache 
  	port (
  	clk, wen0 , wen1 : in std_logic;
  	address: in std_logic_vector (15 downto 0);
  	wdata : in std_logic_vector (15 downto 0);
  	data : out std_logic_vector (15 downto 0);
  	hit0 , hit1 : out std_logic
  	);
  end component;

  signal clk, wen0 , wen1: std_logic;
  signal address: std_logic_vector (15 downto 0);
  signal wdata: std_logic_vector (15 downto 0);
  signal data: std_logic_vector (15 downto 0);
  signal hit0 ,hit1 : std_logic ;
  
	constant clock_period: time := 10 ns;
	signal stop_the_clock: boolean;

begin

  uut: Cache port map ( clk     => clk,
                        wen0    => wen0,
                        wen1    => wen1,
                        address => address,
                        wdata   => wdata,
                        data    => data,
                        hit0    => hit0,
						hit1    => hit1);

  stimulus: process
  begin
  
    -- Put initialisation code here
	address <= "0000000000000001";
	wdata <= "0000000000000111";
	wen0 <= '1';
	wen1 <= '0';
	
	wait for 20ns;
	
	address <= "0000000000000010";
	wdata <= "0000000000000101";
	wen0 <= '0';
	wen1 <= '1';
	
	wait for 20ns;
	
	address <= "0000000000000001";

    -- Put test bench stimulus code here

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