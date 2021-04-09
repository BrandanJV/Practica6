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
use IEEE.numeric_std.all;

entity main is
    Port(clk, sA, sB: in std_logic;             -- Reloj interno; Signo A; Signo B
        OpS: in std_logic_vector(1 downto 0);   --Operación a realizar
        OpA, OpB: in std_logic_vector(3 downto 0); --OpA: Operador A; OpB: Operador B;
        y: in std_logic_vector(3 downto 0) := (others => '1'); -- a rows
        sR: out std_logic;
        De: out std_logic_vector(7 downto 0);   -- De: Habilitador del display
        Od: out integer:=0; --out std_logic_vector(3 downto 0);   -- Od: Datos de salida;
        x: out std_logic_vector(3 downto 0);    -- a columnas
        OpI: out std_logic_vector(2 downto 0)); -- OpI: Led indicador de operación
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
    
signal reset_int, signeR: std_logic;
signal cOa, cOb, int_DataOutput1, int_DataOutput2: std_logic_vector(3 downto 0); --señales internas de los operadores 
signal internal_Output: integer;
signal d7s: std_logic_vector(63 downto 0) := (others => '1');
begin
    d7s(31 downto 24) <= "10110111";                            --Display '='
    Od <= internal_Output;
    cOa <= std_logic_vector(unsigned(not OpA) + 1);
    cOb <= std_logic_vector(unsigned(not OpB) + 1);
process(clk, internal_Output)
begin
    if internal_Output < 0 then sR <= '1';
        else sR <= '0';
        end if;
    if(clk'event and clk = '1') then
        case(OpS) is
            when "00" =>
                if(sA = '1' and sB = '1') then 
                    internal_Output <= to_integer(signed(cOa)) + to_integer(signed(cOb));
                elsif(sA ='1' and sB = '0') then
                    internal_Output <= to_integer(signed(cOa)) + to_integer(unsigned(OpB));
                elsif(sA = '0' and sB = '1') then
                    internal_Output <= to_integer(unsigned(OpA)) + to_integer(signed(cOb));
                else 
                    internal_Output <= to_integer(unsigned(OpA)) + to_integer(unsigned(OpB));
                end if;
            when "01" =>
                    if(sA = '1' and sB = '1') then 
                    internal_Output <= to_integer(signed(cOa)) - to_integer(signed(cOb));
                elsif(sA ='1' and sB = '0') then
                    internal_Output <= to_integer(signed(cOa)) - to_integer(unsigned(OpB));
                elsif(sA = '0' and sB = '1') then
                    internal_Output <= to_integer(unsigned(OpA)) - to_integer(signed(cOb));
                else 
                    internal_Output <= to_integer(unsigned(OpA)) - to_integer(unsigned(OpB));
                end if;
            when "10" =>
                    if(sA = '1' and sB = '1') then 
                    internal_Output <= to_integer(signed(cOa)) * to_integer(signed(cOb));
                elsif(sA ='1' and sB = '0') then
                    internal_Output <= to_integer(signed(cOa)) * to_integer(unsigned(OpB));
                elsif(sA = '0' and sB = '1') then
                    internal_Output <= to_integer(unsigned(OpA)) * to_integer(signed(cOb));
                else 
                    internal_Output <= to_integer(unsigned(OpA)) * to_integer(unsigned(OpB));
                end if;
            when "11" =>
                --internal_Output <= ;
            when others =>
                internal_Output <= 0;
            end case;
            
            
        --Desplegar valores en display    
        case(sA) is                                     --Signo Número A
        when '1' => d7s(63 downto 56) <= "10111111";        -- negativo
        when others => d7s(63 downto 56) <= "11111111";     --positivo
        end case;
        case(OpA) is                              --Número A
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
        case(sB) is                                     --Signo Número B
        when '1' => d7s(47 downto 40) <= "10000000";        --Negativo
        when others => d7s(47 downto 40) <= "11111111";     --Positivo
        end case;
        case(OpB) is                              -- Número B
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

--Disp7: sSegDisplay port map(clk, d7s, Od, De);
--keypad: pmod_keypad generic map(clk_freq => clk, stable_time => stable_time) 
  --          port map(clk => clk, reset_n => reset_int, rows => y, columns => x);
end Behavioral;
