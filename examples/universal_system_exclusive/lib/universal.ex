defmodule MidiMessage.SystemExclusive.Universal do
  alias __MODULE__.{RealTime, NonRealTime}

  def decode(<<0xF0, 0x7E, _::binary>> = bytes), do: NonRealTime.decode(bytes)
  def decode(<<0xF0, 0x7F, _::binary>> = bytes), do: RealTime.decode(bytes)
end
