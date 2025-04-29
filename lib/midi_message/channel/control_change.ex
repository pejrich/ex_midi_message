defmodule MidiMessage.Channel.ControlChange do
  defstruct [:channel, :number, :value, :name, :desc]

  @data [
    {0x00, 0, "Bank select (coarse)", 0..127},
    {0x01, 1, "Modulation wheel (coarse)", 0..127},
    {0x02, 2, "Breath controller (coarse)", 0..127},
    {0x04, 4, "Foot controller (coarse)", 0..127},
    {0x05, 5, "Portamento time (coarse)", 0..127},
    {0x06, 6, "Data entry (coarse)", 0..127},
    {0x07, 7, "Channel volume (coarse) (formerly main volume)", 0..127},
    {0x08, 8, "Balance (coarse)", 0..127},
    {0x09, 9, "Undefined", 0..127},
    {0x0A, 10, "Pan (coarse)", 0..127},
    {0x0B, 11, "Expression (coarse)2", 0..127},
    {0x0C, 12, "Effect control 1 (coarse)", 0..127},
    {0x0D, 13, "Effect control 2 (coarse)", 0..127},
    {0x10, 16, "General purpose controller 1 (coarse)", 0..127},
    {0x11, 17, "General purpose controller 2 (coarse)", 0..127},
    {0x12, 18, "General purpose controller 3 (coarse)", 0..127},
    {0x13, 19, "General purpose controller 4 (coarse)", 0..127},
    {0x14, 20, "Undefined", 0..127},
    {0x15, 21, "Undefined", 0..127},
    {0x16, 22, "Undefined", 0..127},
    {0x17, 23, "Undefined", 0..127},
    {0x18, 24, "Undefined", 0..127},
    {0x19, 25, "Undefined", 0..127},
    {0x1A, 26, "Undefined", 0..127},
    {0x1B, 27, "Undefined", 0..127},
    {0x1C, 28, "Undefined", 0..127},
    {0x1D, 29, "Undefined", 0..127},
    {0x1E, 30, "Undefined", 0..127},
    {0x1F, 31, "Undefined", 0..127},
    {0x20, 32, "Bank select (fine)", 0..127},
    {0x21, 33, "Modulation wheel (fine)", 0..127},
    {0x22, 34, "Breath controller (fine)", 0..127},
    {0x24, 36, "Foot controller (fine)", 0..127},
    {0x25, 37, "Portamento time (fine)", 0..127},
    {0x26, 38, "Data entry (fine)", 0..127},
    {0x27, 39, "Channel volume (fine) (formerly main volume)", 0..127},
    {0x28, 40, "Balance (fine)", 0..127},
    {0x29, 41, "Undefined", 0..127},
    {0x2A, 42, "Pan (fine)", 0..127},
    {0x2B, 43, "Expression (fine)2", 0..127},
    {0x2C, 44, "Effect control 1 (fine)", 0..127},
    {0x2D, 45, "Effect control 2 (fine)", 0..127},
    {0x2E, 46, "LSB Controller", 0..127},
    {0x2F, 47, "LSB Controller", 0..127},
    {0x30, 48, "LSB Controller", 0..127},
    {0x31, 49, "LSB Controller", 0..127},
    {0x32, 50, "LSB Controller", 0..127},
    {0x33, 51, "LSB Controller", 0..127},
    {0x34, 52, "LSB Controller", 0..127},
    {0x35, 53, "LSB Controller", 0..127},
    {0x36, 54, "LSB Controller", 0..127},
    {0x37, 55, "LSB Controller", 0..127},
    {0x38, 56, "LSB Controller", 0..127},
    {0x39, 57, "LSB Controller", 0..127},
    {0x3A, 58, "LSB Controller", 0..127},
    {0x3B, 59, "LSB Controller", 0..127},
    {0x3C, 60, "LSB Controller", 0..127},
    {0x3D, 61, "LSB Controller", 0..127},
    {0x3E, 62, "LSB Controller", 0..127},
    {0x3F, 63, "LSB Controller", 0..127},
    {0x40, 64, "Hold (damper, sustain) pedal 1 (on/off)", [{0..62, :off}, {63..127, :on}]},
    {0x41, 65, "Portamento pedal (on/off)", [{0..62, :off}, {63..127, :on}]},
    {0x42, 66, "Sostenuto pedal (on/off)", [{0..62, :off}, {63..127, :on}]},
    {0x43, 67, "Soft pedal (on/off)", [{0..62, :off}, {63..127, :on}]},
    {0x44, 68, "legato pedal (on/off)", [{0..62, :off}, {63..127, :on}]},
    {0x45, 69, "Hold pedal 2 (on//off)", [{0..62, :off}, {63..127, :on}]},
    {0x46, 70, "Sound controller 1 (default is sound variation)", 0..127},
    {0x47, 71, "Sound controller 2 (default is timbre / harmonic intensity / filter resonance)",
     0..127},
    {0x48, 72, "Sound controller 3 (default is release time)", 0..127},
    {0x49, 73, "Sound controller 4 (default is attack time)", 0..127},
    {0x4A, 74, "Sound controller 5 (default is brightness or cutoff frequency)", 0..127},
    {0x4B, 75, "Sound controller 6 (default is decay time)", 0..127},
    {0x4C, 76, "Sound controller 7 (default is vibrato rate)", 0..127},
    {0x4D, 77, "Sound controller 8 (default is vibrato depth)", 0..127},
    {0x4E, 78, "Sound controller 9 (default is vibrato delay)", 0..127},
    {0x4F, 79, "Sound controller 10 (default is undefined)", 0..127},
    {0x50, 80, "General purpose controller 5", 0..127},
    {0x51, 81, "General purpose controller 6", 0..127},
    {0x52, 82, "General purpose controller 7", 0..127},
    {0x53, 83, "General purpose controller 8", 0..127},
    {0x54, 84, "Portamento control", 0..127},
    {0x58, 88, "High resolution velocity prefix", 0..127},
    {0x59, 89, "Undefined", 0..127},
    {0x5A, 90, "Undefined", 0..127},
    {0x5B, 91, "Effect 1 depth (default is reverb send level, formerly external effect depth)",
     0..127},
    {0x5C, 92, "Effect 2 depth (formerly tremolo depth)", 0..127},
    {0x5D, 93, "Effect 3 depth (default is chorus send level, formerly chorus depth)", 0..127},
    {0x5E, 94, "Effect 4 depth (formerly celeste depth)", 0..127},
    {0x5F, 95, "Effect 5 depth (formerly phaser level)", 0..127},
    {0x60, 96, "Data button increment", nil},
    {0x61, 97, "Data button decrement", nil},
    {0x62, 98, "Non-registered parameter (coarse)", 0..127},
    {0x63, 99, "Non-registered parameter (fine)", 0..127},
    {0x64, 100, "Registered parameter (coarse)", 0..127},
    {0x65, 101, "Registered parameter (fine)", 0..127},
    {0x66, 102, "Undefined", 0..127},
    {0x67, 103, "Undefined", 0..127},
    {0x68, 104, "Undefined", 0..127},
    {0x69, 105, "Undefined", 0..127},
    {0x6A, 106, "Undefined", 0..127},
    {0x6B, 107, "Undefined", 0..127},
    {0x6C, 108, "Undefined", 0..127},
    {0x6D, 109, "Undefined", 0..127},
    {0x6E, 110, "Undefined", 0..127},
    {0x6F, 111, "Undefined", 0..127},
    {0x70, 112, "Undefined", 0..127},
    {0x71, 113, "Undefined", 0..127},
    {0x72, 114, "Undefined", 0..127},
    {0x73, 115, "Undefined", 0..127},
    {0x74, 116, "Undefined", 0..127},
    {0x75, 117, "Undefined", 0..127},
    {0x76, 118, "Undefined", 0..127},
    {0x77, 119, "Undefined", 0..127},
    {0x78, 120, "All sound off", 0},
    {0x79, 121, "All controllers off", 0},
    {0x7A, 122, "Local control (on/off)", [{0..0, :off}, {127..127, :on}]},
    {0x7B, 123, "All notes off", 0},
    {0x7C, 124, "Omni mode off", 0},
    {0x7D, 125, "Omni mode on", 0},
    {0x7E, 126, "Mono operation and all notes off", nil},
    {0x7F, 127, "Poly operation and all notes off", 0}
  ]

  Enum.each(@data, fn
    {_hex, number, name, _.._//1 = values} ->
      def decode(<<0xB::4, channel::4, unquote(number), value>>)
          when value in unquote(Macro.escape(values)),
          do: %__MODULE__{
            channel: channel,
            number: unquote(number),
            value: value,
            name: unquote(name)
          }

    {_hex, number, name, [_ | _] = values} ->
      Enum.each(values, fn {range, desc} ->
        def decode(<<0xB::4, channel::4, unquote(number), value>>)
            when value in unquote(Macro.escape(range)),
            do: %__MODULE__{
              channel: channel,
              number: unquote(number),
              value: value,
              name: unquote(name),
              desc: unquote(desc)
            }
      end)

    {_hex, number, name, _values} ->
      def decode(<<0xB::4, channel::4, unquote(number), value>>),
        do: %__MODULE__{
          channel: channel,
          number: unquote(number),
          value: value,
          name: unquote(name)
        }
  end)

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
