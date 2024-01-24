defmodule MidiMessage.SystemExclusive.Universal.RealTime do
  defmodule Unknown, do: defstruct([:bytes, :channel])

  def decode(<<0xF0, 0x7F, channel, _::binary>> = bytes) do
    %Unknown{bytes: bytes, channel: channel}
  end
end
