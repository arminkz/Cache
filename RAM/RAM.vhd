library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RAM is
	generic (blocksize : integer := 1024);

	port (clk, readmem, writemem : in std_logic;
		addressbus: in std_logic_vector (15 downto 0);
		databus : inout std_logic_vector (15 downto 0);
		memdataready : out std_logic);
end entity;

architecture behavioral of RAM is
	type mem is array (0 to blocksize - 1) of std_logic_vector (15 downto 0);
	
	signal buffermem : mem := (others => (others => '0'));
	
begin
	process (clk)
		variable ad : integer;
		variable init : boolean := true;
	begin
		if init = true then
			-- some initiation
			buffermem(0) <= "0000000000000000"; -- nop
			buffermem(1) <= "1111000000001111"; -- load 15 into R0 (low)
			buffermem(2) <= "1111010000000111"; -- load 7 into R1 (low)
			buffermem(3) <= "0010100100000000"; -- load R2 from M[7]
			--
			
			--
			buffermem(4) <= "0110001000000000"; -- and (R0 = R0 & R2)
			buffermem(5) <= "0000000100000000"; -- hlt
			buffermem(7) <= "1010101010101010"; -- some data
			
			init := false;
		end if;

		--
		memdataready <= '0';

		if  clk'event and clk = '1' then
			ad := to_integer(unsigned(addressbus));

			if readmem = '1' then -- Reading :)
				memdataready <= '1';
				if ad >= blocksize then
					databus <= (others => 'Z');
				else
					databus <= buffermem(ad);
				end if;
			elsif writemem = '1' then -- Writing :)
				memdataready <= '1';
				if ad < blocksize then
					buffermem(ad) <= databus;
				end if;
			else
				databus <= (others => 'Z');
			end if;
		end if;
	end process;
	
end architecture;