library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity forwarding_unit is 
port(
    
    EX_MEMRegWrite : in std_logic;
    EX_MEMRegisterRd : in std_logic;
    ID_EXRegisterRs : in std_logic;
    ID_EXRegisterRt : in std_logic;
    MEM_WBRegWrite : in std_logic;
    MEM_WBRegisterRd : in std_logic;
    A : out std_logic_vector(1 downto 0);
    B : out std_logic_vector(1 downto 0)
);
end forwarding_unit;

architecture rtl of forwarding_unit is

begin

process (all)
begin
    
    if ((EX_MEMRegWrite = '1') and (EX_MEMRegisterRd /= '0') and (EX_MEMRegisterRd = ID_EXRegisterRs)) then
        A <= "10";
    elsif ((MEM_WBRegWrite = '1') and (MEM_WBRegisterRd /= '0') and (EX_MEMRegisterRd /=  ID_EXRegisterRs) and (MEM_WBRegisterRd = ID_EXRegisterRs) ) then
        A <= "01";
    else
        A <= "00";
    end if;    

    if ((EX_MEMRegWrite = '1') and(EX_MEMRegisterRd /= '0') and (EX_MEMRegisterRd = ID_EXRegisterRt)) then
        B <= "10";
    elsif  ((MEM_WBRegWrite = '1') and (MEM_WBRegisterRd /= '0') and (EX_MEMRegisterRd /= ID_EXRegisterRt) and (MEM_WBRegisterRd = ID_EXRegisterRt)) then
        B <= "01";
    else
        B <= "00";
    end if;    


end process;

end architecture;