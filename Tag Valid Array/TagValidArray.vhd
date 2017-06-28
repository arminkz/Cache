library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TVArray is
	port(
		clk : in std_logic;
		reset_n : in std_logic;
		address : in std_logic_vector(5 downto 0);
		writeEn : in std_logic;
		invalidate : in std_logic;
		writeData : in std_logic_vector(3 downto 0);
		output : out std_logic_vector(4 downto 0)
	);
end entity;

architecture behavioral of TVArray is
	type mem is array (0 to 63) of std_logic_vector (4 downto 0);
	signal buffermem : mem := (others => (others => '0'));
	
begin

	output <= buffermem(to_integer(unsigned(address)));

	process (clk)
	begin

		if rising_edge(clk) then
			if writeEn = '1' then
				buffermem(to_integer(unsigned(address))) <= "1" & writeData;
			end if;
			if invalidate = '1' then
				buffermem(to_integer(unsigned(address)))(0) <= '0';
			end if;
			if reset_n = '1' then
				buffermem <= (others => (others => '0'));
			end if;
		end if;
		
	end process;
	
end architecture;