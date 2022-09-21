library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity example_and is
    port (
        i_a : in std_logic;
        i_b : in  std_logic;
        o_res : out  std_logic
    );
end entity example_and;

architecture rtl of example_and is
begin

    o_res <= i_a and i_b;

end architecture;
