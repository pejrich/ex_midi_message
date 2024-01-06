defmodule MidiMessage.Channel do
  defmodule NoteOff,
    do: defstruct([:channel, :number, :velocity])

  defmodule NoteOn,
    do: defstruct([:channel, :number, :velocity])

  defmodule PolyphonicKeyPressure,
    do: defstruct([:channel, :number, :pressure])

  defmodule ControlChange do
    defstruct channel: nil, number: nil, value: nil

    defmodule AllSoundOff, do: defstruct([:channel])
    defmodule ResetAllControllers, do: defstruct([:channel, value: 0])
    defmodule LocalControl, do: defstruct([:channel, :on])
    defmodule AllNotesOff, do: defstruct([:channel])
    defmodule OmniModeOff, do: defstruct([:channel])
    defmodule OmniModeOn, do: defstruct([:channel])
    defmodule MonoModeOn, do: defstruct([:channel, :channels])
    defmodule PolyModeOn, do: defstruct([:channel])

    def as_control_change_message(%AllSoundOff{channel: channel}),
      do: %__MODULE__{channel: channel, number: 120, value: 0}

    def as_control_change_message(%ResetAllControllers{channel: channel, value: value}),
      do: %__MODULE__{channel: channel, number: 121, value: value}

    def as_control_change_message(%LocalControl{channel: channel, on: false}),
      do: %__MODULE__{channel: channel, number: 122, value: 0}

    def as_control_change_message(%LocalControl{channel: channel, on: true}),
      do: %__MODULE__{channel: channel, number: 122, value: 127}

    def as_control_change_message(%AllNotesOff{channel: channel}),
      do: %__MODULE__{channel: channel, number: 123, value: 0}

    def as_control_change_message(%OmniModeOff{channel: channel}),
      do: %__MODULE__{channel: channel, number: 124, value: 0}

    def as_control_change_message(%OmniModeOn{channel: channel}),
      do: %__MODULE__{channel: channel, number: 125, value: 0}

    def as_control_change_message(%MonoModeOn{channel: channel, channels: channels}),
      do: %__MODULE__{channel: channel, number: 126, value: channels}

    def as_control_change_message(%PolyModeOn{channel: channel}),
      do: %__MODULE__{channel: channel, number: 127, value: 0}

    def as_control_change_message(%__MODULE__{} = message), do: message
  end

  defmodule ProgramChange,
    do: defstruct([:channel, :number])

  defmodule ChannelPressure,
    do: defstruct([:channel, :pressure])

  defmodule PitchBend,
    do: defstruct([:channel, value: 8192])
end
