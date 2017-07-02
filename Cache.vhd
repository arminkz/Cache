library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Cache is 
	port (
	clk, wen0 , wen1 : in std_logic;
	address: in std_logic_vector (15 downto 0);
	wdata : in std_logic_vector (15 downto 0);
	data : out std_logic_vector (15 downto 0);
	hit : out std_logic
	);
end entity;

architecture behavioral of Cache is
	
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
	
	component TVArray is
	port(
	clk : in std_logic;
	reset_n : in std_logic;
	address : in std_logic_vector(5 downto 0);
	writeEn : in std_logic;
	invalidate : in std_logic;
	writeData : in std_logic_vector(3 downto 0);
	output : out std_logic_vector(4 downto 0)
	);
	end component;
	
	component DataArray is
	port (
	clk : in std_logic;
	address : in std_logic_vector(5 downto 0);
	writeEn : in std_logic;
	writeData : in std_logic_vector(15 downto 0);
	data : out std_logic_vector(15 downto 0)
	);
	end component;
	
	signal CacheAddress : std_logic_vector(5 downto 0);
	signal CacheTag : std_logic_vector(9 downto 6);
	
	-- Data Array Outputs
	signal DA0_out , DA1_out : std_logic_vector(15 downto 0);
	
	-- Tag / Valid Outputs
	signal TV0_out , TV1_out : std_logic_vector(4 downto 0);
	
	signal hitR : std_logic;
	signal hit0 , hit1 : std_logic;
	signal reset_n , invalidate : std_logic;
	
	-- FSM
	--type state_type is (start,st_read,st_write);
	--signal cur_state : state_type := start;
	--signal next_state : state_type;
	
begin

	CacheAddress <= address(5 downto 0);
	CacheTag <= address(9 downto 6);
	
	Way0DA : DataArray port map (clk,CacheAddress,wen0,wdata,DA0_out);
	Way1DA : DataArray port map (clk,CacheAddress,wen1,wdata,DA1_out);
	
	Way0TV : TVArray port map (clk,reset_n,CacheAddress,wen0,invalidate,CacheTag,TV0_out);
	Way1TV : TVArray port map (clk,reset_n,CacheAddress,wen1,invalidate,CacheTag,TV1_out);
	 
	MHL : MHLogic port map (CacheTag,TV0_out,TV1_out,hitR,hit0,hit1);
	
	data <= DA0_out when hit0 = '1' else
			DA1_out when hit1 = '1' else
			(others => 'Z');
			
	hit <= hitR;
	
end architecture;