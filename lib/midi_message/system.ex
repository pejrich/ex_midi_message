defmodule MidiMessage.SystemCommon do
  defmodule MIDITimeCodeQuarterFrame, do: defstruct([:message_type, :values])
  defmodule SongPositionPointer, do: defstruct([:beats])
  defmodule SongSelect, do: defstruct([:value])
  defmodule TuneRequest, do: defstruct([])
end

defmodule MidiMessage.SystemRealTime do
  defmodule TimingClock, do: defstruct([])
  defmodule Start, do: defstruct([])
  defmodule Continue, do: defstruct([])
  defmodule Stop, do: defstruct([])
  defmodule ActiveSensing, do: defstruct([])
  defmodule Reset, do: defstruct([])
end

defmodule MidiMessage.SystemExclusive do
  defmodule Unknown, do: defstruct([:bytes])
end
