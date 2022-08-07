library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library unisim;
use unisim.vcomponents.ALL;

entity example_top is
    generic (
        G_VALUE0 : std_logic := '0';
        G_VALUE1 : std_logic := '1'
    );
    port (
        i_uart_rx: in  std_logic;  -- xil mblaze BD uart 
        o_uart_tx: out std_logic; -- xil mblaze BD uart 

        i_sw0 : in std_logic;
        i_sw1 : in std_logic;

        o_led0: out std_logic; -- xil IP and
        o_led1: out std_logic; -- xil IP xor
        o_led2: out std_logic; -- xil BD or
        o_led3: out std_logic; -- my IP cntr

        i_rst   : in std_logic;
        i_clk   : in std_logic
    );
end entity example_top;


architecture rtl of example_top is
    component mblaze_bd is
        port (
            i_clk : in std_logic;
            i_uart_rx : in std_logic;
            o_uart_tx : out std_logic;
            i_ext_rst : in std_logic; 
            clk_pl_o : out std_logic
        );
    end component mblaze_bd;

    component or_bd is
        port (
            a_i : in std_logic_vector ( 0 to 0 );
            b_i : in std_logic_vector ( 0 to 0 );
            result_o : out std_logic_vector ( 0 to 0 )
        );
    end component or_bd;

    component c_counter_binary_0
        port (
            CLK : in std_logic;
            CE : in std_logic;
            Q : out std_logic_vector(27 downto 0) 
        );
    end component;

    component c_counter_binary_1
        port (
            CLK : in std_logic;
            CE : in std_logic;
            Q : out std_logic_vector(28 downto 0) 
        );
    end component;

    component c_addsub_0
        port (
            A : in std_logic_vector(3 DOWNTO 0);
            B : in std_logic_vector(3 DOWNTO 0);
            CLK : in std_logic;
            CE : in std_logic;
            S : out std_logic_vector(3 DOWNTO 0) 
        );
    end component;

    signal clk_pl  : std_logic;
    signal cnt0    : std_logic_vector(27 downto 0);
    signal cnt1    : std_logic_vector(28 downto 0);
    signal add_opa : std_logic_vector(3 downto 0);
    signal add_opb : std_logic_vector(3 downto 0);
    signal add_sum : std_logic_vector(3 downto 0);

begin
    o_led0 <= cnt0(27) and G_VALUE1;
    o_led1 <= cnt1(28) or G_VALUE0;

    -- Block Design w/ a microblaze and uart - Imported from tcl
    u_mblaze_bd : mblaze_bd
    port map (
        i_clk => i_clk,
        i_ext_rst => i_rst,
        i_uart_rx => i_uart_rx,
        o_uart_tx => o_uart_tx,
        clk_pl_o => clk_pl
    );

    -- Block design with an or gate  - Imported from tcl
    u_or_bd : or_bd
    port map (
        a_i(0) => i_sw0,
        b_i(0) => i_sw1,
        result_o(0) => o_led2
    );

    -- Xilinx IP Counter (fabric) - Imported from xci
    u_counter0 : c_counter_binary_0
    port map (
        CLK => clk_pl,
        CE => i_sw0,
        Q => cnt0
    );

    -- Xilinx IP Counter (dsp48) - Imported from xci
    u_counter1 : c_counter_binary_1
    port map (
        CLK => clk_pl,
        CE => i_sw0,
        Q => cnt1
    );

    -- VHDL module
    u_and : entity work.example_and(rtl)
    port map (
        i_a => i_sw0,
        i_b => i_sw1,
        o_res => o_led3
    );

    -- Xilinx IP adder - Imported from tcl
    add_opa <= X"3";
    add_opb <= X"5";
    u_adder : c_addsub_0
    port map (
        A => add_opa,
        B => add_opb,
        CLK => clk_pl,
        CE => '1',
        S => add_sum
    );

end architecture;