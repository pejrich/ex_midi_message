defmodule MidiMessage.SystemExclusive.Universal.RealTime do
  alias MidiMessage.Encoding

  defmodule Unknown do
    defstruct([:bytes, :channel, :sub_id_1, :sub_id_2])

    defimpl Encoding do
      def encode(%Unknown{bytes: bytes}), do: bytes
    end
  end

  def decode(<<0xF0, 0x7F, channel, sub_id_1, sub_id_2, _::binary>> = bytes) do
    %Unknown{bytes: bytes, channel: channel, sub_id_1: sub_id_1, sub_id_2: sub_id_2}
  end
end
