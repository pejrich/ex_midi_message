defmodule MidiMessage do
  @moduledoc """
  Documentation for `MidiMessage`.
  """
  import Bitwise

  alias __MODULE__.Channel.{
    NoteOff,
    NoteOn,
    PolyphonicKeyPressure,
    ControlChange,
    ProgramChange,
    ChannelPressure,
    PitchBend
  }

  alias __MODULE__.{SystemCommon, SystemRealTime, SystemExclusive}

  defmodule InvalidMessage do
    defexception([:bytes, :reason])

    def message(%__MODULE__{bytes: bytes, reason: nil}) do
      "Invalid Message: #{for(<<a, b <- Base.encode16(bytes)>>, do: <<a, b>>) |> Enum.join(" ")}"
    end

    def message(%__MODULE__{bytes: bytes, reason: reason}) do
      "Invalid Message: #{for(<<a, b <- Base.encode16(bytes)>>, do: <<a, b>>) |> Enum.join(" ")}. #{reason}"
    end
  end

  defprotocol Encoding do
    @spec encode(t) :: BitString.t()
    def encode(message)
  end

  defimpl Encoding, for: Any do
    def encode(%{bytes: <<bytes::binary>>}), do: bytes
  end

  defmodule UnknownMessage, do: defstruct([:bytes])

  @doc ~S"""
  Decodes the given binary into a message struct.

  ## Examples
      iex> note_number = 60
      iex> MidiMessage.decode(<<0x91, note_number, 0x40>>)
      %MidiMessage.Channel.NoteOn{channel: 1, number: 60, velocity: 64}
      iex> MidiMessage.decode(<<0x81, note_number, 0x20>>)
      %MidiMessage.Channel.NoteOff{channel: 1, number: 60, velocity: 32}

  Can handle control "channel mode" messages.
  Set channel_mode_messages to `false` to disable.

  ## Examples
      iex> bytes = <<0xB0, 0x78, 0x00>>
      iex> MidiMessage.decode(bytes)
      %MidiMessage.Channel.ControlChange.AllSoundOff{channel: 0}
      iex> MidiMessage.decode(bytes, channel_mode_messages: false)
      %MidiMessage.Channel.ControlChange{channel: 0, number: 120, value: 0}

  System Common Messages
  Messages beginning with 0xF1 - 0xF7 are system common messages.

  ## Examples
      iex> MidiMessage.decode(<<0xF2, 0x39, 0x60>>)
      %MidiMessage.SystemCommon.SongPositionPointer{beats: 12345}

  System RealTime Messages
  Messages beginning with 0xF8 - 0xFF are system real time messages.
  They are also only one byte in length.

  ## Examples
      iex> MidiMessage.decode(<<0xF8>>)
      %MidiMessage.SystemRealTime.TimingClock{}

  System Exclusive (sysex) messages always begin with 0xF0.
  Some system exclusive messages are included in the MIDI standard, under the name `Universal`.

  Not many System Exclusive Decoders will be included in this package,
  however you may define your own. Decoders must be manually specified.

      iex> channel = 0x7F
      iex> bytes = <<0xF0, 0x7E, channel, 0x06, 0x01, 0xF7>>
      iex> MidiMessage.decode(bytes)
      %MidiMessage.SystemExclusive.Unknown{bytes: bytes}
      iex> MidiMessage.decode(bytes, system_exclusive_decoders: [MidiMessage.SystemExclusive.Universal])
      %MidiMessage.SystemExclusive.Universal.NonRealTime.IdentityRequest{channel: channel}
  """
  def decode(message, options \\ [])

  def decode(<<0x8::4, channel::4, 0::1, number::7, 0::1, velocity::7>>, _options),
    do: %NoteOff{channel: channel, number: number, velocity: velocity}

  def decode(<<0x8::4, _>> = bytes, _), do: raise(%InvalidMessage{bytes: bytes})

  def decode(<<0x9::4, channel::4, 0::1, number::7, 0::1, velocity::7>>, _options),
    do: %NoteOn{channel: channel, number: number, velocity: velocity}

  def decode(<<0x9::4, _>> = bytes, _), do: raise(%InvalidMessage{bytes: bytes})

  def decode(<<0xA::4, channel::4, 0::1, number::7, 0::1, pressure::7>>, _options),
    do: %PolyphonicKeyPressure{channel: channel, number: number, pressure: pressure}

  def decode(<<0xA::4, _>> = bytes, _), do: raise(%InvalidMessage{bytes: bytes})

  def decode(<<0xB::4, _channel::4, _rest::binary>> = message, options) do
    {channel_mode_messages, _} = Keyword.pop(options, :channel_mode_messages, true)
    decode_control(message, %{channel_mode_messages: channel_mode_messages})
  end

  def decode(<<0xB::4, _>> = bytes, _), do: raise(%InvalidMessage{bytes: bytes})

  def decode(<<0xC::4, channel::4, 0::1, number::7>>, _options),
    do: %ProgramChange{channel: channel, number: number}

  def decode(<<0xC::4, _>> = bytes, _), do: raise(%InvalidMessage{bytes: bytes})

  def decode(<<0xD::4, channel::4, 0::1, pressure::7>>, _options),
    do: %ChannelPressure{channel: channel, pressure: pressure}

  def decode(<<0xD::4, _>> = bytes, _), do: raise(%InvalidMessage{bytes: bytes})

  def decode(<<0xE::4, channel::4, 0::1, lsb::7, 0::1, msb::7>>, _options),
    do: %PitchBend{channel: channel, value: msb <<< 7 ||| lsb}

  def decode(<<0xE::4, _>> = bytes, _), do: raise(%InvalidMessage{bytes: bytes})

  def decode(<<0xF1, 0b0::1, message_type::3, values::4>>, _options),
    do: %SystemCommon.MIDITimeCodeQuarterFrame{message_type: message_type, values: values}

  def decode(<<0xF2, 0b0::1, beats_lsb::7, 0::1, beats_msb::7>>, _options),
    do: %SystemCommon.SongPositionPointer{beats: beats_msb <<< 7 ||| beats_lsb}

  def decode(<<0xF3, 0b0::1, value::7>>, _options),
    do: %SystemCommon.SongSelect{value: value}

  def decode(<<0xF6>>, _options), do: %SystemCommon.TuneRequest{}

  def decode(<<0xF::4, 0b1::1, 0b000::3>>, _options), do: %SystemRealTime.TimingClock{}
  def decode(<<0xF::4, 0b1::1, 0b010::3>>, _options), do: %SystemRealTime.Start{}
  def decode(<<0xF::4, 0b1::1, 0b011::3>>, _options), do: %SystemRealTime.Continue{}
  def decode(<<0xF::4, 0b1::1, 0b100::3>>, _options), do: %SystemRealTime.Stop{}
  def decode(<<0xF::4, 0b1::1, 0b110::3>>, _options), do: %SystemRealTime.ActiveSensing{}
  def decode(<<0xF::4, 0b1::1, 0b111::3>>, _options), do: %SystemRealTime.Reset{}

  def decode(<<0xF::4, 0b0::1, 0b000::3, _rest::binary>> = bytes, options) do
    {verify_system_exclusive_end_byte, _} =
      Keyword.pop(options, :verify_system_exclusive_end_byte, true)

    if verify_system_exclusive_end_byte do
      total_bytes = byte_size(bytes)
      <<_start::binary-size(total_bytes - 1), last_byte::binary-size(1)>> = bytes

      if last_byte != <<0xF7>> do
        raise %InvalidMessage{bytes: bytes}
      end
    end

    {system_exclusive_decoders, _} =
      Keyword.pop(options, :system_exclusive_decoders, [])

    messages =
      Enum.flat_map(
        system_exclusive_decoders,
        fn decoder ->
          try do
            case decoder do
              {module, args} when is_atom(module) -> [module.decode(bytes, args)]
              module when is_atom(module) -> [module.decode(bytes)]
            end
          rescue
            e ->
              IO.inspect(e)
              []
          end
        end
      )

    case messages do
      [] -> %SystemExclusive.Unknown{bytes: bytes}
      [h] -> h
      x -> x
    end
  end

  def decode(<<_::binary>> = message, _options), do: %UnknownMessage{bytes: message}

  defp decode_control(<<0xB::4, channel::4, 0b01111::5, number_3::3, 0::1, value::7>>, %{
         channel_mode_messages: false
       }) do
    %ControlChange{channel: channel, number: 0b1111000 ||| number_3, value: value}
  end

  defp decode_control(<<0xB::4, channel::4, 0b01111::5, 0::3, 0::1, 0::7>>, _options),
    do: %ControlChange.AllSoundOff{channel: channel}

  defp decode_control(<<0xB::4, channel::4, 0b01111::5, 1::3, 0::1, value::7>>, _options),
    do: %ControlChange.ResetAllControllers{channel: channel, value: value}

  defp decode_control(<<0xB::4, channel::4, 0b01111::5, 2::3, 0::1, 0::7>>, _options),
    do: %ControlChange.LocalControl{channel: channel, on: false}

  defp decode_control(<<0xB::4, channel::4, 0b01111::5, 2::3, 0::1, 127::7>>, _options),
    do: %ControlChange.LocalControl{channel: channel, on: true}

  defp decode_control(<<0xB::4, channel::4, 0b01111::5, 3::3, 0::1, 0::7>>, _options),
    do: %ControlChange.AllNotesOff{channel: channel}

  defp decode_control(<<0xB::4, channel::4, 0b01111::5, 4::3, 0::1, 0::7>>, _options),
    do: %ControlChange.OmniModeOff{channel: channel}

  defp decode_control(<<0xB::4, channel::4, 0b01111::5, 5::3, 0::1, 0::7>>, _options),
    do: %ControlChange.OmniModeOn{channel: channel}

  defp decode_control(<<0xB::4, channel::4, 0b01111::5, 6::3, 0::1, channels::7>>, _options),
    do: %ControlChange.MonoModeOn{channel: channel, channels: channels}

  defp decode_control(<<0xB::4, channel::4, 0b01111::5, 7::3, 0::1, 0::7>>, _options),
    do: %ControlChange.PolyModeOn{channel: channel}

  defp decode_control(<<0xB::4, channel::4, 0::1, number::7, 0::1, value::7>>, _options),
    do: %ControlChange{channel: channel, number: number, value: value}

  def encode(%NoteOff{channel: channel, number: number, velocity: velocity}),
    do: <<0x8::4, channel::4, 0::1, number::7, 0::1, velocity::7>>

  def encode(%NoteOn{channel: channel, number: number, velocity: velocity}),
    do: <<0x9::4, channel::4, 0::1, number::7, 0::1, velocity::7>>

  def encode(%PolyphonicKeyPressure{channel: channel, number: number, pressure: pressure}),
    do: <<0xA::4, channel::4, 0::1, number::7, 0::1, pressure::7>>

  def encode(%ControlChange{channel: channel, number: number, value: value}),
    do: <<0xB::4, channel::4, 0::1, number::7, 0::1, value::7>>

  def encode(%ProgramChange{channel: channel, number: number}),
    do: <<0xC::4, channel::4, 0::1, number::7>>

  def encode(%ChannelPressure{channel: channel, pressure: pressure}),
    do: <<0xD::4, channel::4, 0::1, pressure::7>>

  def encode(%PitchBend{channel: channel, value: value}),
    do: <<0xE::4, channel::4, 0::1, value &&& 0b1111111::7, 0::1, value >>> 7::7>>

  def encode(%ControlChange.AllSoundOff{} = message) do
    message
    |> ControlChange.as_control_change_message()
    |> encode()
  end

  def encode(%ControlChange.ResetAllControllers{} = message) do
    message
    |> ControlChange.as_control_change_message()
    |> encode()
  end

  def encode(%ControlChange.LocalControl{} = message) do
    message
    |> ControlChange.as_control_change_message()
    |> encode()
  end

  def encode(%ControlChange.AllNotesOff{} = message) do
    message
    |> ControlChange.as_control_change_message()
    |> encode()
  end

  def encode(%ControlChange.OmniModeOff{} = message) do
    message
    |> ControlChange.as_control_change_message()
    |> encode()
  end

  def encode(%ControlChange.OmniModeOn{} = message) do
    message
    |> ControlChange.as_control_change_message()
    |> encode()
  end

  def encode(%ControlChange.MonoModeOn{} = message) do
    message
    |> ControlChange.as_control_change_message()
    |> encode()
  end

  def encode(%ControlChange.PolyModeOn{} = message) do
    message
    |> ControlChange.as_control_change_message()
    |> encode()
  end

  def encode(%SystemCommon.MIDITimeCodeQuarterFrame{
        message_type: message_type,
        values: values
      }),
      do: <<0xF1, 0::1, message_type::3, values::4>>

  def encode(%SystemCommon.SongPositionPointer{beats: beats}) do
    beats_lsb = beats &&& 0b1111111
    beats_msb = beats >>> 7

    <<0xF2, 0::1, beats_lsb::7, 0::1, beats_msb::7>>
  end

  def encode(%SystemCommon.SongSelect{value: value}), do: <<0xF3, 0::1, value::7>>
  def encode(%SystemCommon.TuneRequest{}), do: <<0xF6>>

  def encode(%SystemRealTime.TimingClock{}), do: <<0xF8>>
  def encode(%SystemRealTime.Start{}), do: <<0xFA>>
  def encode(%SystemRealTime.Continue{}), do: <<0xFB>>
  def encode(%SystemRealTime.Stop{}), do: <<0xFC>>
  def encode(%SystemRealTime.ActiveSensing{}), do: <<0xFE>>
  def encode(%SystemRealTime.Reset{}), do: <<0xFF>>

  def encode(%SystemExclusive.Unknown{bytes: bytes}), do: bytes

  def encode(message), do: Encoding.encode(message)
end
