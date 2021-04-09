----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.03.2021 16:52:48
-- Design Name: 
-- Module Name: tb_main - Behavioral
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

entity tb_main is
--  Port ( );
end tb_main;

architecture Behavioral of tb_main is
    component main is
        Port(clk, sA, sB: in std_logic; -- Reloj interno
            OpS: in std_logic_vector( 1 downto 0);
            OpA, OpB: in std_logic_vector(3 downto 0); --OpA: Operador A; OpB: Operador B; OpS: Selección de operación
            De: out std_logic_vector(7 downto 0); --De: Habilitador del display
            sR: out std_logic;
            Od: out integer:=0;--out std_logic_vector(3 downto 0); --Od: Datos de salida;
            OpI: out std_logic_vector(2 downto 0));  -- OpI: Led indicador de operación
    end component;
signal clk_s, sA_s, sB_s, sR_s: std_logic;
signal OpS_s: std_logic_vector(1 downto 0);
signal OpA_s, OpB_s: std_logic_vector(3 downto 0);
signal De_s: std_logic_vector(7 downto 0);
signal OpI_s: std_logic_vector(2 downto 0);
signal Od_s: integer:=0;--std_logic_vector(3 downto 0);
begin
DUT: main port map(
    clk => clk_s,
    sA  => sA_S,
    sB  => sB_s,
    OpA => OpA_s,
    OpB => OpB_s,
    OpS => OpS_s,
    Od  => Od_s,
    De  => De_s,
    sR  => sR_s,
    OpI => OpI_s);
    process
    begin
        wait until clk_s'event and clk_s = '1';
        sA_s      <= '0';
        sB_s      <= '0';
        OpA_s <= "0101";
        OpB_s <= "0011";
        Ops_s <= "00";
        
        wait until clk_s'event and clk_s = '1';
        sA_s      <= '0';
        sB_s      <= '0';
        OpA_s <= "1001";
        OpB_s <= "0100";
        Ops_s <= "01"; 
        
        wait until clk_s'event and clk_s = '1';
        sA_s      <= '0';
        sB_s      <= '0';
        OpA_s <= "0101";
        OpB_s <= "0011";
        Ops_s <= "10";
        
        wait until clk_s'event and clk_s = '1';
        sA_s      <= '1';
        sB_s      <= '1';
        OpA_s <= "1000";
        OpB_s <= "0101";
        Ops_s <= "00"; 
        
        wait until clk_s'event and clk_s = '1';
        sA_s      <= '0';
        sB_s      <= '1';
        OpA_s <= "0110";
        OpB_s <= "0010";
        Ops_s <= "10";     
    end process;
end Behavioral;
