library IEEE;
use IEEE.std_logic_1164.all;

entity MHLogic is
	port (
		tag : in std_logic_vector(3 downto 0);
		w0 : in std_logic_vector(4 downto 0);
		w1 : in std_logic_vector(4 downto 0);
		hit : out std_logic;
		w0v : out std_logic;
		w1v : out std_logic;
	);
end entity;