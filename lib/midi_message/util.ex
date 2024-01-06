defmodule MidiMessage.Util do
  import Bitwise

  def split_14_bit(n) do
    {n >>> 7 &&& 0b1111111, n &&& 0b1111111}
  end

  def join_14_bit(msb, lsb) do
    msb <<< 7 ||| (lsb &&& 0b1111111)
  end
end
