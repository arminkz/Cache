library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity DataArray_tb is
end;

architecture bench of DataArray_tb is

	component DataArray is
		port (
			clk : in std_logic;
			address : in std_logic_vector(5 downto 0);
			writeEn : in std_logic;
			writeData : in std_logic_vector(15 downto 0);
			data : out std_logic_vector(15 downto 0)
		);
	end component;

	signal clk, writeEn: std_logic;
	signal address: std_logic_vector (5 downto 0);
	signal writeData: std_logic_vector (15 downto 0);
	signal data : std_logic_vector(15 downto 0);

	constant clock_period: time := 10 ns;
	signal stop_the_clock: boolean;

begin

	dai : DataArray port map(
		clk => clk,
		address => address,
		writeEn => writeEn,
		writeData => writeData,
		data => data
	);

	stimulus: process
	begin

		-- initialisation code here
		address <= "000000";
		writeData <= "0000000000000010";
		writeEn <= '1';
		wait for clock_period;
		
		address <= "000001";
		writeData <= "0000000000000011";
		writeEn <= '0';
		wait for clock_period;
		
		address <= "000000";

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