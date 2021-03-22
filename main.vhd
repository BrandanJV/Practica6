----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2021 18:23:27
-- Design Name: 
-- Module Name: main - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port(clk: in std_logic; -- Reloj interno
        OpA, OpB, OpS: in std_logic_vector(7 downto 0); --OpA: Operador A; OpB: Operador B; OpS: Selección de operación
        Od, De: out std_logic_vector(7 downto 0); --Od: Datos de salida; De: Habilitador del display
        OpI: out std_logic_vector(2 downto 0));  -- OpI: Led indicador de operación
end main;

architecture Behavioral of main is
    component pmod_keypad is
        GENERIC(clk_freq    : INTEGER;
            stable_time : INTEGER);
        PORT(clk     :  IN     STD_LOGIC;                          --system clock
            reset_n :  IN     STD_LOGIC;                           --asynchornous active-low reset
            rows    :  IN     STD_LOGIC_VECTOR(1 TO 4);            --row connections to keypad
            columns :  BUFFER STD_LOGIC_VECTOR(1 TO 4) := "1111";  --column connections to keypad
            keys    :  OUT    STD_LOGIC_VECTOR(0 TO 15));          --resultant key presses
    end component;
    
    component sSegDisplay is
        Port(ck : in  std_logic;                          -- 100MHz system clock
            number : in  std_logic_vector (63 downto 0); -- eight digit number to be displayed
            seg : out  std_logic_vector (7 downto 0);    -- display cathodes
            an : out  std_logic_vector (7 downto 0));    -- display anodes (active-low, due to transistor complementing)
    end component;
    
signal reset_int, signeA, signeB, signeR: std_logic;
signal int_OperatorA, int_OperatorB, int_DataOutput1, int_DataOutput2: std_logic_vector(4 downto 0); --señales internas de los operadores 
signal d7s: std_logic_vector(63 downto 0) := (others => '1');
begin
d7s(31 downto 24) <= "10110111";                            --Display '='

process(clk)
begin
    if(clk'event and clk = '1') then
        --Desplegar valores en display    
        case(signeA) is                                     --Signo Número A
        when '1' => d7s(63 downto 56) <= "10111111";        -- negativo
        when others => d7s(63 downto 56) <= "11111111";     --positivo
        end case;
        case(int_OperatorA) is                              --Número A
            when "0000" => d7s(55 downto 48) <= "11000000";
            when "0001" => d7s(55 downto 48) <= "11111001";
            when "0010" => d7s(55 downto 48) <= "10100100";
            when "0011" => d7s(55 downto 48) <= "10110000";
            when "0100" => d7s(55 downto 48) <= "10011001";
            when "0101" => d7s(55 downto 48) <= "10010010";
            when "0110" => d7s(55 downto 48) <= "10000010";
            when "0111" => d7s(55 downto 48) <= "11111000";
            when "1000" => d7s(55 downto 48) <= "10000000";
            when "1001" => d7s(55 downto 48) <= "10010000";
            when others => d7s(55 downto 48) <= "11111111";
        end case;  
        case(signeB) is                                     --Signo Número B
        when '1' => d7s(47 downto 40) <= "10000000";        --Negativo
        when others => d7s(47 downto 40) <= "11111111";     --Positivo
        end case;
        case(int_OperatorB) is                              -- Número B
            when "0000" => d7s(39 downto 32) <= "11000000";
            when "0001" => d7s(39 downto 32) <= "11111001";
            when "0010" => d7s(39 downto 32) <= "10100100";
            when "0011" => d7s(39 downto 32) <= "10110000";
            when "0100" => d7s(39 downto 32) <= "10011001";
            when "0101" => d7s(39 downto 32) <= "10010010";
            when "0110" => d7s(39 downto 32) <= "10000010";
            when "0111" => d7s(39 downto 32) <= "11111000";
            when "1000" => d7s(39 downto 32) <= "10000000";
            when "1001" => d7s(39 downto 32) <= "10010000";
            when others => d7s(39 downto 32) <= "11111111";
        end case;
        case(signeR) is                                     -- Signo Resultado
            when '1' => d7s(23 downto 16) <= "10000000";    -- negativo
        when others => d7s(23 downto 16) <= "11111111";     --positivvo
        end case;
        case(int_DataOutput1) is                            --Número decimal Resultado
            when "0000" => d7s(15 downto 8) <= "11000000";
            when "0001" => d7s(15 downto 8) <= "11111001";
            when "0010" => d7s(15 downto 8) <= "10100100";
            when "0011" => d7s(15 downto 8) <= "10110000";
            when "0100" => d7s(15 downto 8) <= "10011001";
            when "0101" => d7s(15 downto 8) <= "10010010";
            when "0110" => d7s(15 downto 8) <= "10000010";
            when "0111" => d7s(15 downto 8) <= "11111000";
            when "1000" => d7s(15 downto 8) <= "10000000";
            when "1001" => d7s(15 downto 8) <= "10010000";
            when others => d7s(15 downto 8) <= "11111111";
        end case;
        case(int_DataOutput2) is                            --Número Unitario Resultado
            when "0000" => d7s(7 downto 0) <= "11000000";
            when "0001" => d7s(7 downto 0) <= "11111001";
            when "0010" => d7s(7 downto 0) <= "10100100";
            when "0011" => d7s(7 downto 0) <= "10110000";
            when "0100" => d7s(7 downto 0) <= "10011001";
            when "0101" => d7s(7 downto 0) <= "10010010";
            when "0110" => d7s(7 downto 0) <= "10000010";
            when "0111" => d7s(7 downto 0) <= "11111000";
            when "1000" => d7s(7 downto 0) <= "10000000";
            when "1001" => d7s(7 downto 0) <= "10010000";
            when others => d7s(7 downto 0) <= "11111111";
        end case;  
    end if;
end process;

Disp7: sSegDisplay port map(clk, d7s, Od, De);
--keypad: pmod_keypad generic map(clk_freq => clk_freq, stable_time => stable_time) 
            --port map(clk => clk, reset_n => reset_int, rows =>
end Behavioral;
