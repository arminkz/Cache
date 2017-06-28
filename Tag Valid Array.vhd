library IEEE;
use IEEE.std_logic_1164.all;

entity TVArray is
	port(
		clk : in std_logic;
		reset_n : in std_logic;
		address : in std_logic_vector(5 downto 0);
		writeEn : in std_logic;
		invalidate : in std_logic;
		writeData : in std_logic_vector(3 downto 0);
	);
end entity;