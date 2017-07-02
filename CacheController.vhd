library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CacheController is 
	port (
	clk, readmem, writemem : in std_logic;
	addressbus: in std_logic_vector (15 downto 0);
	databus : inout std_logic_vector (15 downto 0);
	memdataready : out std_logic
	);
end entity;

architecture behavioral of CacheController is
	
	component RAM
  	generic (blocksize : integer := 1024);
  	port (clk, readmem, writemem : in std_logic;
  	addressbus: in std_logic_vector (15 downto 0);
  	databus : inout std_logic_vector (15 downto 0);
  	memdataready : out std_logic);
	end component;
  
	component Cache is 
	port (clk, readmem, writemem : in std_logic;
	address: in std_logic_vector (15 downto 0);
	wdata : in std_logic_vector (15 downto 0);
	data : out std_logic_vector (15 downto 0);
	hit : out std_logic);
	end component;
	
begin

	MainMemory : RAM port map (clk,readmem,writemem,addressbus,databus,memdataready);
	
end architecture;