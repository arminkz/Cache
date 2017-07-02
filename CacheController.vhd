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
	signal dataCache : std_logic_vector (15 downto 0);
	signal dataRAM : std_logic_vector (15 downto 0);
	signal dataWriteCache : std_logic_vector (15 downto 0);
	signal cacheHit0 , cacheHit1 : std_logic;
	signal MRU : std_logic := '0' ; 
	
	-- FSM
	type state_type is (reset, st1, st2);
	signal cur_state : state_type := reset;
	
begin

	MainMemory : RAM port map (clk,readRAM,writeRAM,address,dataRAM,memdataready);
	CacheMemory : Cache port map(clk,writeCache0,writeCache1,address,dataWriteCache,dataCache,cacheHit0,cacheHit1);
	
	process (clk)
	begin
		
		
		
		if rising_edge(clk) then
		
			readRAM <= '0';
			writeRAM <= '0';
			writeCache0 <= '0';
			writeCache1 <= '0';
			dataRAM <= (others => 'Z');
			memdataready <= '0';
		
			case cur_state is
				
				when reset =>
					readRAM <= '0';
					writeRAM <= '0';
					writeCache0 <= '0';
					writeCache1 <= '0';
					dataRAM <= (others => 'Z');
					memdataready <= '0';
					cur_state <= st1;
			
				-- STATE 1 (MAIN)
				when st1 =>
				
					if readmem = '1' then
					
						if (cacheHit0 = '1') or (cacheHit1 = '1') then
							data <= dataCache;
							if(cacheHit0 = '1') then
								MRU <= '0';
							elsif (cacheHit1 = '1') then
								MRU <= '1';
							end if;
							cur_state <= st1; 
						else
							readRAM <= '1';
							cur_state <= st2;
						end if;
						
					elsif writemem = '1' then
					
						-- write to RAM
						dataRAM <= data;
						writeRAM <= '1';
						-- write to Cache
						dataWriteCache <= data;
						if MRU = '0' then
							writeCache0 <= '1';
						end if;
						if MRU = '1' then
							writeCache1 <= '1';
						end if;
						
						cur_state <= st1;
						
					end if;
				
				-- STATE 2 (MISS)
				when st2 =>
				
					data <= dataRAM;
					memdataready <= '1';
					dataWriteCache <= dataRAM;
					
					-- write to cache based on MRU
					if MRU = '0' then
						writeCache0 <= '1';
					end if;
					if MRU = '1' then
						writeCache1 <= '1';
					end if;
					
					cur_state <= st1;
			end case;
		end if;
	end process;
	
end architecture;