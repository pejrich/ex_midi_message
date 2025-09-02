defmodule MidiMessage.Channel do
  defmodule NoteOff,
    do: defstruct([:channel, :number, :velocity])

  defmodule KeySignature, do: defstruct([:pitch, :mode])
  defmodule TimeSignature, do: defstruct([:numerator, :denominator])

  defmodule NoteOn,
    do: defstruct([:channel, :number, :velocity])

  defmodule PolyphonicKeyPressure,
    do: defstruct([:channel, :number, :pressure])

  defmodule ChannelPressure,
    do: defstruct([:channel, :pressure])

  defmodule PitchBend,
    do: defstruct([:channel, value: 8192])
end
