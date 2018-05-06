----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:00:10 03/27/2017 
-- Design Name: 
-- Module Name:    zegar - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity zegar is
	Port (	Clk : in  STD_LOGIC;
				reset : in std_logic;
				BT : in std_logic_vector(1 downto 0);
				AN : out  STD_LOGIC_vector(3 downto 0);
				SEG : out  STD_LOGIC_vector(6 downto 0);
				dp : out std_logic);
end zegar;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dzielnik is
    Port ( --Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           LD7 : out  STD_LOGIC);
end dzielnik;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display is
Port (     	Clk : in  STD_LOGIC;
				digit_i : in  STD_LOGIC_vector(31 downto 0);
				AN : out  STD_LOGIC_vector(3 downto 0);
				SEG : out  STD_LOGIC_vector(6 downto 0);
				dp : out std_logic);
end display;

architecture wyswietl of display is
begin
	pokaz: process(Clk) is
		variable counter: integer range 0 to 3 := 0;
		begin
			if rising_edge(Clk)	then
				if(counter = 0) then
					SEG <= digit_i(6 downto 0);
					AN <= "1110";
					dp <= digit_i(7);
				elsif(counter = 1) then
					SEG <= digit_i(14 downto 8);
					AN <= "1110";
					dp <= digit_i(15);
				elsif(counter = 2) then
					SEG <= digit_i(22 downto 16);
					AN <= "1110";
					dp <= digit_i(23);
				elsif(counter = 3) then
					SEG <= digit_i(30 downto 24);
					AN <= "1110";
					dp <= digit_i(31);
				end if;
				counter := counter + 1;
				if (counter = 4) then 
				counter := 0;
				end if;
			end if;
		end process;
end wyswietl;

architecture var of dzielnik is
constant N : integer := 2; 
begin

	dzielimy: process(Clk) is
		variable counter : integer range 0 to N := 0;
		variable state : std_logic := '0';
		begin
--		if (Reset = '1') then
--			state := '0';
--			counter := 0;
		if rising_edge(Clk) then

			if (counter = N/2) then
				state := '1';
			elsif(counter = N) then
				state := '0';
				counter := 0;
			end if;
			counter := counter + 1;
		end if;
			LD7 <= state;
	end process;
end var;


architecture Behavioral of zegar is

component dzielnik is
    Port ( --Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           LD7 : out  STD_LOGIC);
end component dzielnik;

component display is
Port (     	Clk : in  STD_LOGIC;
				digit_i : in  STD_LOGIC_vector(31 downto 0);
				AN : out  STD_LOGIC_vector(3 downto 0);
				SEG : out  STD_LOGIC_vector(6 downto 0);
				dp : out std_logic);
end component display;

signal Clock: std_logic;
signal digit_i : std_logic_vector (31 downto 0) := "11000000010000001100000011000000";

begin
g1: dzielnik port map (Clk, Clock);
g2: display port map (Clock, digit_i, AN, SEG, dp);
	
	p0:process (Clock, reset)
		begin
		if(reset = '1') then
			digit_i <= "11000000010000001100000011000000";
		elsif falling_edge(Clock) then
			case digit_i(6 downto 0) is
					when "0000001" =>
						digit_i(6 downto 0) <= (1=>'0', 2=>'0', others=>'1');
					when "1001111" =>
						digit_i(6 downto 0) <= (2=>'1', 5=>'1', others=>'0');
					when "0010010" =>
						digit_i(6 downto 0) <= (4=>'1', 5=>'1', others=>'0');
					when "0000110" =>
						digit_i(6 downto 0) <= (0=>'1', 3=>'1', 4=>'1', others=>'0');
					when "1001100" =>
						digit_i(6 downto 0) <= (1=>'1', 4=>'1', others=>'0');
					when "0100100" =>
						digit_i(6 downto 0) <= (1=>'1', others=>'0');
					when "0100000" =>
						digit_i(6 downto 0) <= (0=>'0', 1=>'0', 2=>'0', others=>'1');
					when "0001111" =>
						digit_i(6 downto 0) <= (others=>'0');
					when "0000000" =>
						digit_i(6 downto 0) <= (3=>'1', 4=>'1', others=>'0');
					when "0001100" =>
						digit_i(6 downto 0) <= (6=>'1', others=>'0');
						case digit_i(14 downto 8) is
								when "0000001" =>
									digit_i(14 downto 8) <= (9=>'0', 10=>'0', others=>'1');
								when "1001111" =>
									digit_i(14 downto 8) <= (10=>'1', 13=>'1', others=>'0');
								when "0010010" =>
									digit_i(14 downto 8) <= (12=>'1', 13=>'1', others=>'0');
								when "0000110" =>
									digit_i(14 downto 8) <= (8=>'1', 11=>'1', 12=>'1', others=>'0');
								when "1001100" =>
									digit_i(14 downto 8) <= (9=>'1', 12=>'1', others=>'0');
								when "0100100" =>
									digit_i(14 downto 8) <= (9=>'1', others=>'0');
								when "0100000" =>
									digit_i(14 downto 8) <= (8=>'0', 9=>'0', 10=>'0', others=>'1');
								when "0001111" =>
									digit_i(14 downto 8) <= (others=>'0');
								when "0000000" =>
									digit_i(14 downto 8) <= (11=>'1', 12=>'1', others=>'0');
								when "0001100" =>
									digit_i(14 downto 8) <= (14=>'1', others=>'0');
									case digit_i(22 downto 16) is								
										when "0000001" =>
											digit_i(22 downto 16) <= (17=>'0', 18=>'0', others=>'1');
										when "1001111" =>
											digit_i(22 downto 16) <= (18=>'1', 21=>'1', others=>'0');
										when "0010010" =>
											digit_i(22 downto 16) <= (20=>'1', 21=>'1', others=>'0');
										when "0000110" =>
											digit_i(22 downto 16) <= (16=>'1', 19=>'1', 20=>'1', others=>'0');
										when "1001100" =>
											digit_i(22 downto 16) <= (17=>'1', 20=>'1', others=>'0');
										when "0100100" =>
											digit_i(22 downto 16) <= (17=>'1', others=>'0');
										when "0100000" =>
											digit_i(22 downto 16) <= (16=>'0', 17=>'0', 18=>'0', others=>'1');
										when "0001111" =>
											digit_i(22 downto 16) <= (others=>'0');
										when "0000000" =>
											digit_i(22 downto 16) <= (19=>'1', 20=>'1', others=>'0');
										when "0001100" =>
											digit_i(22 downto 16) <= (22=>'1', others=>'0');
											case digit_i(30 downto 24) is
												when "0100100" =>
													digit_i(30 downto 24) <= (30=>'1', others=>'0');
												when "0000001" =>
													digit_i(30 downto 24) <= (25=>'0', 26=>'0', others=>'1');
												when "1001111" =>
													digit_i(30 downto 24) <= (26=>'1', 29=>'1', others=>'0');
												when "0010010" =>
													digit_i(30 downto 24) <= (28=>'1', 29=>'1', others=>'0');
												when "0000110" =>
													digit_i(30 downto 24) <= (24=>'1', 27=>'1', 28=>'1', others=>'0');
												when "1001100" =>
													digit_i(30 downto 24) <= (25=>'1', 28=>'1', others=>'0');
												when others => null;
											end case;
										when others => null;
									end case;
								when others => null;
							end case;
						when others => null;
				end case;				
			end if;
	end process;

end Behavioral;

