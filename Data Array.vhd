library IEEE;
use IEEE.std_logic_1164.all;

entity DataArray is
	port (
		clk : in std_logic;
		address : in std_logic_vector(5 downto 0);
		writeEn : in std_logic;
		writeData : in std_logic_vector(31 downto 0);
		data : out std_logic_vector(31 downto 0);
	);
end entity;