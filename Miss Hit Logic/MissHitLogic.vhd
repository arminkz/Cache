library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MHLogic is
	port (
		tag : in std_logic_vector(3 downto 0);
		w0 : in std_logic_vector(4 downto 0);
		w1 : in std_logic_vector(4 downto 0);
		hit : out std_logic;
		w0v : out std_logic;
		w1v : out std_logic
	);
end entity;

architecture behavioral of MHLogic is	
begin
	
	hit <= '1' when '1' & tag = w0 or '1' & tag = w1 else '0';
	w0v <= '1' when w0 = '1' & tag else '0';
	w1v <= '1' when w1 = '1' & tag else '0';
	
end architecture;