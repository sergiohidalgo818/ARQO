--------------------------------------------------------------------------------
-- Procesador RISC V uniciclo curso Arquitectura Ordenadores 2022
-- Initial Release G.Sutter jun 2022
-- Sergio Hidalgo y Miguel Ibañez
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.RISCV_pack.all;

entity processorRV is
   port(
      Clk      : in  std_logic;                     -- Reloj activo en flanco subida
      Reset    : in  std_logic;                     -- Reset asincrono activo nivel alto
      -- Instruction memory
      IAddr    : out std_logic_vector(31 downto 0); -- Direccion Instr
      IDataIn  : in  std_logic_vector(31 downto 0); -- Instruccion leida
      -- Data memory
      DAddr    : out std_logic_vector(31 downto 0); -- Direccion
      DRdEn    : out std_logic;                     -- Habilitacion lectura
      DWrEn    : out std_logic;                     -- Habilitacion escritura
      DDataOut : out std_logic_vector(31 downto 0); -- Dato escrito
      DDataIn  : in  std_logic_vector(31 downto 0)  -- Dato leido
   );
end processorRV;

architecture rtl of processorRV is

  component alu_RV
    port (
      OpA     : in  std_logic_vector (31 downto 0); -- Operando A
      OpB     : in  std_logic_vector (31 downto 0); -- Operando B
      Control : in  std_logic_vector ( 3 downto 0); -- Codigo de control=op. a ejecutar
      Result  : out std_logic_vector (31 downto 0); -- Resultado
      SignFlag: out std_logic;                      -- Sign Flag
      carryOut: out std_logic;                      -- Carry bit
      ZFlag   : out std_logic                       -- Flag Z
    );
  end component;

  component reg_bank
     port (
        Clk   : in  std_logic;                      -- Reloj activo en flanco de subida
        Reset : in  std_logic;                      -- Reset as�ncrono a nivel alto
        A1    : in  std_logic_vector(4 downto 0);   -- Direcci�n para el puerto Rd1
        Rd1   : out std_logic_vector(31 downto 0);  -- Dato del puerto Rd1
        A2    : in  std_logic_vector(4 downto 0);   -- Direcci�n para el puerto Rd2
        Rd2   : out std_logic_vector(31 downto 0);  -- Dato del puerto Rd2
        A3    : in  std_logic_vector(4 downto 0);   -- Direcci�n para el puerto Wd3
        Wd3   : in  std_logic_vector(31 downto 0);  -- Dato de entrada Wd3
        We3   : in  std_logic                       -- Habilitaci�n de la escritura de Wd3
     ); 
  end component reg_bank;

  component control_unit
     port (
        -- Entrada = codigo de operacion en la instruccion:
        OpCode   : in  std_logic_vector (6 downto 0);
        -- Seniales para el PC
        Branch   : out  std_logic;                     -- 1 = Ejecutandose instruccion branch
        -- Seniales relativas a la memoria
        ResultSrc: out  std_logic_vector(1 downto 0);  -- 00 salida Alu; 01 = salida de la mem.; 10 PC_plus4
        MemWrite : out  std_logic;                     -- Escribir la memoria
        MemRead  : out  std_logic;                     -- Leer la memoria
        -- Seniales para la ALU
        ALUSrc   : out  std_logic;                     -- 0 = oper.B es registro, 1 = es valor inm.
        AuipcLui : out  std_logic_vector (1 downto 0); -- 0 = PC. 1 = zeros, 2 = reg1.
        ALUOp    : out  std_logic_vector (2 downto 0); -- Tipo operacion para control de la ALU
        -- señal generacion salto
        Ins_jalr  : out  std_logic;                    -- 0=any instrucion, 1=jalr
        -- Seniales para el GPR
        RegWrite : out  std_logic                      -- 1 = Escribir registro
     );
  end component;

  component alu_control is
    port (
      -- Entradas:
      ALUOp  : in std_logic_vector (2 downto 0);     -- Codigo de control desde la unidad de control
      Funct3 : in std_logic_vector (2 downto 0);     -- Campo "funct3" de la instruccion (I(14:12))
      Funct7 : in std_logic_vector (6 downto 0);     -- Campo "funct7" de la instruccion (I(31:25))     
      -- Salida de control para la ALU:
      ALUControl : out std_logic_vector (3 downto 0) -- Define operacion a ejecutar por la ALU
    );
  end component alu_control;

 component Imm_Gen is
    port (
        instr     : in std_logic_vector(31 downto 0);
        imm       : out std_logic_vector(31 downto 0)
    );
  end component Imm_Gen;

  signal Alu_Op1      : std_logic_vector(31 downto 0);
  signal Alu_Op2      : std_logic_vector(31 downto 0);
  signal Alu_ZERO     : std_logic;
  signal Alu_SIGN      : std_logic;
  signal AluControl   : std_logic_vector(3 downto 0);
  signal reg_RD_data  : std_logic_vector(31 downto 0);

  signal branch_true : std_logic;
  signal PC_next        : std_logic_vector(31 downto 0);
  signal PC_reg         : std_logic_vector(31 downto 0);
  signal PC_plus4       : std_logic_vector(31 downto 0);

  signal Instruction    : std_logic_vector(31 downto 0); -- La instrucción desde lamem de instr
  signal Inm_ext        : std_logic_vector(31 downto 0); -- La parte baja de la instrucción extendida de signo
  signal reg_RS, reg_RT : std_logic_vector(31 downto 0);

  signal dataIn_Mem     : std_logic_vector(31 downto 0); -- From Data Memory
  signal Addr_Branch    : std_logic_vector(31 downto 0);

  signal Ctrl_Jalr, Ctrl_Branch, Ctrl_MemWrite, Ctrl_MemRead,  Ctrl_ALUSrc, Ctrl_RegWrite : std_logic;
  
  --Ctrl_RegDest,
  signal Ctrl_ALUOP     : std_logic_vector(2 downto 0);
  signal Ctrl_PcLui     : std_logic_vector(1 downto 0);
  signal Ctrl_ResSrc    : std_logic_vector(1 downto 0);

  signal Addr_jalr      : std_logic_vector(31 downto 0);
  signal Addr_Jump_dest : std_logic_vector(31 downto 0);
  signal desition_Jump  : std_logic;
  signal Alu_Res        : std_logic_vector(31 downto 0);
  -- Instruction filds
  signal Funct3         : std_logic_vector(2 downto 0);
  signal Funct7         : std_logic_vector(6 downto 0);
  signal RS1, RS2, RD   : std_logic_vector(4 downto 0);
  -- Signals IF_ID
  signal OPCode_ID : std_logic_vector(6 downto 0);
  signal Instruction_ID: std_logic_vector(31 downto 0);
  signal PC_ID : std_logic_vector(31 downto 0);
  signal PC4_ID   : std_logic_vector(31 downto 0);
  -- Signals ID_EX
  signal CtrlALUOP_EX : std_logic_vector(2 downto 0);
  signal CtrlALUsrc_EX : std_logic;
  signal CtrlPcLui_EX : std_logic_vector(1 downto 0);
  signal Funct3_EX : std_logic_vector(2 downto 0);
  signal Funct7_EX : std_logic_vector(6 downto 0);
  signal Inmm_EX : std_logic_vector(31 downto 0);
  signal PC_EX : std_logic_vector(31 downto 0);
  signal WB_EX : std_logic_vector(2 downto 0);
  signal M_EX : std_logic_vector(3 downto 0);
  signal PC_P4_ex    : std_logic_vector(31 downto 0);
  signal RT_EX : std_logic_vector(31 downto 0);
  signal RS_EX : std_logic_vector(31 downto 0);
  signal RS1_EX, RS2_EX, RD_EX   : std_logic_vector(4 downto 0);
  -- Signals EX_MEM
  signal ALUSign_MEMORY : std_logic;
  signal ALUZero_MEMORY : std_logic;
  signal ALURes_MEMORY : std_logic_vector(31 downto 0);
  signal MemRead_MEMORY : std_logic;
  signal MemWrite_MEMORY : std_logic;
  signal WB_MEMORY : std_logic_vector(2 downto 0);
  signal CtrlJalr_MEMORY : std_logic;
  signal CtrlBranch_MEMORY : std_logic;
  signal Funct3_MEMORY : std_logic_vector(2 downto 0);
  signal AddrJalr_MEMORY : std_logic_vector(31 downto 0);
  signal AddrBranch_MEMORY : std_logic_vector(31 downto 0);
  signal PC_P4_MEMORY     : std_logic_vector(31 downto 0);
  signal RegRT_MEMORY : std_logic_vector(31 downto 0);
  signal RS1_MEMORY, RS2_MEMORY, RD_MEMORY   : std_logic_vector(4 downto 0);
  -- Signals MEM_WB
  signal ALURes_WB : std_logic_vector(31 downto 0);
  signal CtrlRegWrite_WB : std_logic;
  signal CtrlResSrc_WB: std_logic_vector(1 downto 0);
  signal DataIN_WB : std_logic_vector(31 downto 0);
  signal PC_P4_WB     : std_logic_vector(31 downto 0);
  signal RS1_WB, RS2_WB, RD_WB   : std_logic_vector(4 downto 0);
  -- Forwarding unit
  signal forwardA : std_logic_vector(1 downto 0);
  signal forwardB : std_logic_vector(1 downto 0);
  signal muxA : std_logic_vector(31 downto 0);
  signal muxB : std_logic_vector(31 downto 0);
  -- Hazard detection unit
  signal Hazard : std_logic;
  signal IDWrite : std_logic;
  signal PCWrite : std_logic;

  
  begin

  PC_next <= Addr_Jump_dest when desition_Jump = '1' else PC_plus4;

  -- Program Counter
  PC_reg_proc: process(Clk, Reset)
  begin
    if Reset = '1' then
      PC_reg <= (22 => '1', others => '0'); -- 0040_0000
    elsif rising_edge(Clk) and PCWrite = '1' then
      PC_reg <= PC_next;
    end if;
  end process;

  PC_plus4    <= PC_reg + 4;
  IAddr       <= PC_reg;
  Instruction <= IDataIn;
  
  
  IF_ID_reg: process(clk,reset)
    begin
      if reset = '1' then
        Funct3      <= "000";
        Funct7      <= "0000000";
        RS1         <= "00000";
        RS2         <= "00000";
        RD          <= "00000";
        OPCode_ID <= "0000000";
	      Instruction_ID <= x"00000000";
        PC_ID       <= x"00000000";
	      PC4_ID  <= x"00000000";
      elsif rising_edge(clk) and IDWrite = '1' then
        Funct3      <= Instruction(14 downto 12); -- Campo "funct3" de la instruccion
        Funct7      <= Instruction(31 downto 25); -- Campo "funct7" de la instruccion
        RD          <= Instruction(11 downto 7);
        RS1         <= Instruction(19 downto 15);
        RS2         <= Instruction(24 downto 20);
	      OPCode_ID   <= Instruction(6 downto 0);
	      Instruction_ID <= Instruction;
        PC_ID       <= PC_reg;
	      PC4_ID <= PC_plus4;
      end if;
  end process;

  ID_EX_reg: process(clk,reset)
  begin
    if reset = '1' then
      WB_EX <= "000";
      M_EX <= "0000";
      CtrlALUOP_EX <= "000";
      CtrlALUsrc_EX <= '0';
      CtrlPcLui_EX <= "00";
      PC_EX <= x"00000000";
      RS_EX <=  x"00000000";
      RT_EX <=  x"00000000";
      Inmm_EX <= x"00000000";
      Funct3_EX <= "000";
      Funct7_EX <= "0000000";
      RD_ex <= "00000";
      PC_P4_ex  <= x"00000000";
      RD_EX <= "00000";
      RS1_EX <= "00000";
      RS2_EX <= "00000";
    elsif rising_edge(clk) then
      CtrlALUOP_EX <= Ctrl_aluOP;
      CtrlALUsrc_EX <= Ctrl_alusrc;
      CtrlPcLui_EX <= Ctrl_PcLui;
      Funct3_EX <= funct3;
      Funct7_EX <= funct7;
      Inmm_EX <= inm_ext;
      PC_EX <= PC_ID;
      WB_EX <= Ctrl_resSrc & Ctrl_RegWrite;
      M_EX <= Ctrl_jalr & Ctrl_Branch & ctrl_MemWrite & Ctrl_MemRead;
      PC_P4_ex <= PC4_ID;
      RD_ex <= rd;
      RT_EX <= reg_rt;
      RS_EX <= reg_rs;
      RD_EX <= RD;
      RS1_EX <= RS1;
      RS2_EX <= RS2;
    end if;
end process;  

EX_MEM_reg: process(clk,reset)
    begin
      if reset = '1' then
        ALUSign_MEMORY <= '0';
        ALUZero_MEMORY <= '0';
        ALURes_MEMORY <= x"00000000";
        MemRead_MEMORY <= '0';
        MemWrite_MEMORY <= '0';
        WB_MEMORY <= "000";
        Funct3_MEMORY <= "000";
        CtrlJalr_MEMORY <= '0';
        CtrlBranch_MEMORY <= '0';
        PC_P4_MEMORY  <= x"00000000";
        RegRT_MEMORY <= x"00000000";
        RD_MEMORY  <= "00000" ;
        RS1_MEMORY <= "00000" ;
        RS2_MEMORY <= "00000";
        elsif rising_edge(clk) then
        ALUSign_MEMORY <= alu_sign;
        ALUZero_MEMORY <= alu_zero;
        ALURes_MEMORY <= alu_res;
        MemRead_MEMORY <= M_EX(0);
        MemWrite_MEMORY <= M_EX(1);
        WB_MEMORY <= WB_EX;
	      Funct3_MEMORY <= Funct3_EX;
        CtrlJalr_MEMORY <= M_EX(3);
        CtrlBranch_MEMORY <= M_EX(2);
        AddrJalr_MEMORY <= addr_jalr;
        AddrBranch_MEMORY <= addr_branch;
	      PC_P4_MEMORY <= PC_P4_ex;
        RD_MEMORY <= RD_ex;
        RegRT_MEMORY <= RT_EX;
        RS1_MEMORY<= RS1_EX ;
        RS2_MEMORY <= RS2_EX;
      end if;
  end process;


  MEM_WB_reg: process(clk,reset)
  begin
    if reset = '1' then
      ALURes_WB <= x"00000000";
      CtrlRegWrite_WB <= '0';
      CtrlResSrc_WB <= "00";
      DataIN_WB <= x"00000000";
      PC_P4_WB  <= x"00000000";
      RD_WB <= "00000";
      RS1_WB <= "00000";
      RS2_WB <= "00000";
    elsif rising_edge(clk) then
      CtrlResSrc_WB <= WB_MEMORY(2) & WB_MEMORY(1);
      CtrlRegWrite_WB <= WB_MEMORY(0);
      ALURes_WB <= ALURes_MEMORY;
      DataIN_WB <= datain_mem;
      RD_WB <= RD_MEMORY;
      PC_P4_WB <= PC_P4_MEMORY;
      RD_WB <= RD_MEMORY;
      RS1_WB <= RS1_MEMORY;
      RS2_WB <= RS2_MEMORY;
    end if;
end process;

  

  RegsRISCV : reg_bank
  port map (
    Clk   => Clk,
    Reset => Reset,
    A1    => RS1, --Instruction(19 downto 15), --rs1
    Rd1   => reg_RS,
    A2    => RS2, --Instruction(24 downto 20), --rs2
    Rd2   => reg_RT,
    A3    => RD_WB, --Instruction(11 downto 7),,
    Wd3   => reg_RD_data,
    We3   => CtrlRegWrite_WB
  );

  UnidadControl : control_unit
  port map(
    OpCode   => OPCode_ID,
    -- Señales para el PC
    --Jump   => CONTROL_JUMP,
    Branch   => Ctrl_Branch,
    -- Señales para la memoria
    ResultSrc=> Ctrl_ResSrc,
    MemWrite => Ctrl_MemWrite,
    MemRead  => Ctrl_MemRead,
    -- Señales para la ALU
    ALUSrc   => Ctrl_ALUSrc,
    AuipcLui => Ctrl_PcLui,
    ALUOP    => Ctrl_ALUOP,
    -- señal generacion salto
    Ins_jalr => Ctrl_jalr, -- 0=any instrucion, 1=jalr
    -- Señales para el GPR
    RegWrite => Ctrl_RegWrite
  );

  inmed_op : Imm_Gen
  port map (
        instr    => Instruction_id,
        imm      => Inm_ext 
  );

  Addr_Branch    <= PC_EX + Inmm_EX;
  Addr_jalr      <= RS_EX + Inmm_EX;

  desition_Jump  <= CtrlJalr_MEMORY or (CtrlBranch_MEMORY and branch_true);
  branch_true    <= '1' when ( ((Funct3_MEMORY = BR_F3_BEQ) and (ALUZero_MEMORY = '1')) or
                               ((Funct3_MEMORY = BR_F3_BNE) and (ALUZero_MEMORY = '0')) or
                               ((Funct3_MEMORY = BR_F3_BLT) and (ALUSign_MEMORY = '1')) or
                               ((Funct3_MEMORY = BR_F3_BGT) and (ALUSign_MEMORY = '0')) ) else
                    '0';
 
Addr_Jump_dest <= AddrJalr_MEMORY   when CtrlJalr_MEMORY = '1' else
                    AddrBranch_MEMORY when CtrlBranch_MEMORY='1' else
                    (others =>'0');

  Alu_control_i: alu_control
  port map(
    -- Entradas:
    ALUOp  => CtrlALUOP_EX, -- Codigo de control desde la unidad de control
    Funct3  => Funct3_EX,    -- Campo "funct3" de la instruccion
    Funct7  => Funct7_EX,    -- Campo "funct7" de la instruccion
    -- Salida de control para la ALU:
    ALUControl => AluControl -- Define operacion a ejecutar por la ALU
    );


  Forwarding_unit: process(all)
  begin
    
    if ((WB_MEMORY(0) = '1') and (RD_MEMORY /= "00000") and (RD_MEMORY = RS1_EX)) then
      forwardA <= "10";
    elsif ((CtrlRegWrite_WB = '1') and (RD_WB /= "00000") and (RD_MEMORY /=  RS1_EX) and (RD_WB = RS1_EX) ) then
      forwardA <= "01";
    else
      forwardA <= "00";
    end if;    

    if ((WB_MEMORY(0) = '1') and(RD_MEMORY /= "00000") and (RD_MEMORY = RS2_EX)) then
      forwardB <= "10";
    elsif  ((CtrlRegWrite_WB = '1') and (RD_WB /= "00000") and (RD_MEMORY /= RS2_EX) and (RD_WB = RS2_EX)) then
      forwardB <= "01";
    else
      forwardB <= "00";
    end if;    


  end process;



  MUX_A: process(all)
  begin
  
	if forwardA = "00" then
		muxA <= RS_EX;

    elsif forwardA = "10" then
		muxA <= ALURes_MEMORY;
    elsif forwardA = "01" then
		muxA <= reg_RD_data;
    end if;
  
  end process;

  MUX_B: process(all)
  begin
	
	if forwardB = "00" then
      muxB <= RT_EX;
	
    elsif forwardB = "10" then
      muxB <= ALURes_MEMORY;

    elsif forwardB = "01" then
      muxB <= reg_RD_data;
    end if;

  end process;
  
  
  HazardDetection_unit: process(all)
  begin
	if (M_EX(0) = '1' and ((RD_EX = RS1) or (RD_EX = RS2))) then 
		Hazard <= '1';
	else
		Hazard <= '0';
	end if;
  end process;
  
  
  PCWrite <= not(Hazard);
  
  IDWrite <= ((not(Hazard)));

    
  Alu_RISCV : alu_RV
  port map (
    OpA      => Alu_Op1,
    OpB      => Alu_Op2,
    Control  => AluControl,
    Result   => Alu_Res,
    Signflag => Alu_SIGN,
    carryOut => open,
    Zflag    => Alu_ZERO
  );

  Alu_Op1    <= PC_ex           when CtrlPcLui_EX = "00" else
                (others => '0')  when CtrlPcLui_EX = "01" else
                muxA; -- any other 
  Alu_Op2    <= muxB when CtrlALUsrc_EX = '0' else Inmm_EX;


  DAddr      <= ALURes_MEMORY;
  DDataOut   <= RegRT_MEMORY;
  DWrEn      <= MemWrite_MEMORY;
  dRdEn      <= MemRead_MEMORY;
  dataIn_Mem <= DDataIn;

  reg_RD_data <= DataIN_WB when CtrlResSrc_WB = "01" else
    PC_P4_WB   when CtrlResSrc_WB = "10" else 
      ALURes_WB; -- When 00


      
end architecture;
