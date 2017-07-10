library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CacheController is 
	port (
	clk, readmem, writemem : in std_logic;
	address: in std_logic_vector (15 downto 0);
	data : inout std_logic_vector (15 downto 0);
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
  
	component Cache 
	port (clk, wen0 , wen1 : in std_logic;
	address: in std_logic_vector (15 downto 0);
	wdata : in std_logic_vector (15 downto 0);
	data : out std_logic_vector (15 downto 0);
	hit0 , hit1 : out std_logic);
	end component;
	
	signal readRAM , writeRAM , writeCache0 , writeCache1 : std_logic;
	
	
	signal outFromCache : std_logic;
	signal outFromRAM : std_logic;
	
	signal forwardToRAM : std_logic;
	signal forwardToCache : std_logic;
	signal RamToCache : std_logic;
	
	signal dataWriteCache : std_logic_vector (15 downto 0);
	signal dataRAM : std_logic_vector (15 downto 0);
	
	signal cacheOut : std_logic_vector (15 downto 0);
	
	signal cacheHit0 , cacheHit1 : std_logic;
	signal RamDataReady : std_logic;
	signal MRU : std_logic := '0' ; 
	
	-- FSM
	type state_type is (reset, st1, st2);
	signal cur_state : state_type := reset;
	signal next_state : state_type;
	
begin

	MainMemory : RAM port map (clk,readRAM,writeRAM,address,dataRAM,RamDataReady);
	CacheMemory : Cache port map(clk,writeCache0,writeCache1,address,dataWriteCache,cacheOut,cacheHit0,cacheHit1);
	
	data <= cacheOut when outFromCache = '1' else
			dataRAM when outFromRAM = '1' else
			(others => 'Z');
			
	dataRAM <= data when forwardToRAM = '1' else
			   (others => 'Z');
			   
	dataWriteCache <= data when forwardToCache = '1' else
				 dataRAM when RamToCache = '1' else
			     (others => 'Z');
	
	process (clk)
	begin
		
		if rising_edge(clk) then
		
			case cur_state is
				
				when reset =>
				
					readRAM <= '0';
					writeRAM <= '0';
					writeCache0 <= '0';
					writeCache1 <= '0';
					memdataready <= '0';
					outFromCache <= '0';
					outFromRAM <= '0';
					forwardToRAM <= '0';
					forwardToCache <= '0';
					RamToCache <= '0';
					
					cur_state <= st1;
			
				-- STATE 1 (MAIN)
				when st1 =>
				
					if readmem = '1' then
					
						if (cacheHit0 = '1') or (cacheHit1 = '1') then
							outFromCache <= '1';
							if(cacheHit0 = '1') then
								MRU <= '0';
							elsif (cacheHit1 = '1') then
								MRU <= '1';
							end if;
							cur_state <= reset; 
						else
							readRAM <= '1';
							cur_state <= st2;
						end if;
						
					elsif writemem = '1' then
					
						-- write to RAM
						forwardToRAM <= '1';
						writeRAM <= '1';
						
						-- write to Cache
						forwardToCache <= '1';
						if MRU = '0' then
							writeCache0 <= '1';
						end if;
						if MRU = '1' then
							writeCache1 <= '1';
						end if;
						
						cur_state <= reset;
						
					end if;
				
				-- STATE 2 (MISS)
				when st2 =>
				
					outFromRAM <= '1';
					memdataready <= '1';
					RamToCache <= '1';
					
					-- write to cache based on MRU
					if MRU = '0' then
						writeCache0 <= '1';
					end if;
					if MRU = '1' then
						writeCache1 <= '1';
					end if;
					
					cur_state <= reset;
			end case;
		end if;
	end process;
	
end architecture;