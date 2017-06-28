library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity MHLogic_tb is
end;

architecture bench of MHLogic_tb is

	component MHLogic is
		port (
			tag : in std_logic_vector(3 downto 0);
			w0 : in std_logic_vector(4 downto 0);
			w1 : in std_logic_vector(4 downto 0);
			hit : out std_logic;
			w0v : out std_logic;
			w1v : out std_logic
		);
	end component;
	
	signal tag : std_logic_vector(3 downto 0);
	signal w0 , w1 : std_logic_vector(4 downto 0);
	signal hit , w0v , w1v : std_logic;
	
begin
	
	mhl : MHLogic port map(
		tag => tag,
		w0 => w0,
		w1 => w1,
		hit => hit,
		w0v => w0v,
		w1v => w1v
	);
	
	stimulus: process
	begin
		tag <= "0000";
		w0 <= "10101";
		w1 <= "10010";
		
		wait;
	end process;
	

end architecture;