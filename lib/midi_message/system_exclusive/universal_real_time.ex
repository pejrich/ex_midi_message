defmodule MidiMessage.SystemExclusive.UniversalRealTime do
  # TODO: Fill this out.
  # Information: https://www.midi.org/specifications-old/item/table-4-universal-system-exclusive-messages
  defmodule Unknown, do: defstruct([:bytes])
  def decode(<<0xF0, 0x7F, _rest::binary>> = bytes), do: %Unknown{bytes: bytes}
end
