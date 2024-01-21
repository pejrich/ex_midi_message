defmodule MidiMessage.CommonTest do
  use ExUnit.Case, async: true
  use Faker.Random
  doctest MidiMessage

  alias MidiMessage.Channel.{
    NoteOff,
    NoteOn,
    PolyphonicKeyPressure,
    ControlChange,
    ProgramChange,
    ChannelPressure,
    PitchBend
  }

  describe "decode / encode Channel Messages" do
    test "NoteOff" do
      channel = random_between(0, 15)
      number = random_between(0, 127)
      velocity = random_between(0, 127)

      bytes = <<0x8::4, channel::4, number, velocity>>
      message = %NoteOff{channel: channel, number: number, velocity: velocity}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "NoteOn" do
      channel = random_between(0, 15)
      number = random_between(0, 127)
      velocity = random_between(1, 127)

      bytes = <<0x9::4, channel::4, number, velocity>>
      message = %NoteOn{channel: channel, number: number, velocity: velocity}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "PolyphonicKeyPressure" do
      channel = random_between(0, 15)
      number = random_between(0, 127)
      pressure = random_between(0, 127)

      bytes = <<0xA::4, channel::4, number, pressure>>
      message = %PolyphonicKeyPressure{channel: channel, number: number, pressure: pressure}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "ControlChange" do
      channel = random_between(0, 15)
      number = random_between(0, 119)
      value = random_between(0, 127)

      bytes = <<0xB::4, channel::4, number, value>>
      message = %ControlChange{channel: channel, number: number, value: value}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "ProgramChange" do
      channel = random_between(0, 15)
      number = random_between(0, 127)

      bytes = <<0xC::4, channel::4, number>>
      message = %ProgramChange{channel: channel, number: number}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "ChannelPressure" do
      channel = random_between(0, 15)
      pressure = random_between(0, 127)

      bytes = <<0xD::4, channel::4, pressure>>
      message = %ChannelPressure{channel: channel, pressure: pressure}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "PitchBend" do
      channel = random_between(0, 15)
      value = random_between(0, 16383)

      <<value_msb::7, value_lsb::7>> = <<value::14>>

      bytes = <<0xE::4, channel::4, 0::1, value_lsb::7, 0::1, value_msb::7>>
      message = %PitchBend{channel: channel, value: value}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "AllSoundOff" do
      channel = random_between(0, 15)
      number = 120
      value = 0

      bytes = <<0xB::4, channel::4, number, value>>

      message = %ControlChange{channel: channel, number: number, value: value}
      assert message == MidiMessage.decode(bytes, channel_mode_messages: false)

      message = %ControlChange.AllSoundOff{channel: channel}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "ResetAllControllers" do
      channel = random_between(0, 15)
      number = 121
      value = random_between(0, 127)

      bytes = <<0xB::4, channel::4, number, value>>

      message = %ControlChange{channel: channel, number: number, value: value}
      assert message == MidiMessage.decode(bytes, channel_mode_messages: false)

      message = %ControlChange.ResetAllControllers{channel: channel, value: value}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "LocalControl" do
      channel = random_between(0, 15)
      number = 122

      value = 127
      bytes = <<0xB::4, channel::4, number, 0::1, value::7>>

      message = %ControlChange{channel: channel, number: number, value: value}
      assert message == MidiMessage.decode(bytes, channel_mode_messages: false)

      message = %ControlChange.LocalControl{channel: channel, on: true}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)

      value = 0
      bytes = <<0xB::4, channel::4, number, 0::1, value::7>>

      message = %ControlChange{channel: channel, number: number, value: value}
      assert message == MidiMessage.decode(bytes, channel_mode_messages: false)

      message = %ControlChange.LocalControl{channel: channel, on: false}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "AllNotesOff" do
      channel = random_between(0, 15)
      number = 123
      value = 0

      bytes = <<0xB::4, channel::4, number, value>>

      message = %ControlChange{channel: channel, number: number, value: value}
      assert message == MidiMessage.decode(bytes, channel_mode_messages: false)

      message = %ControlChange.AllNotesOff{channel: channel}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "OmniModeOff" do
      channel = random_between(0, 15)
      number = 124
      value = 0

      bytes = <<0xB::4, channel::4, number, value>>

      message = %ControlChange{channel: channel, number: number, value: value}
      assert message == MidiMessage.decode(bytes, channel_mode_messages: false)

      message = %ControlChange.OmniModeOff{channel: channel}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "OmniModeOn" do
      channel = random_between(0, 15)
      number = 125
      value = 0

      bytes = <<0xB::4, channel::4, number, value>>

      message = %ControlChange{channel: channel, number: number, value: value}
      assert message == MidiMessage.decode(bytes, channel_mode_messages: false)

      message = %ControlChange.OmniModeOn{channel: channel}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "MonoModeOn" do
      channel = random_between(0, 15)
      number = 126
      channels = random_between(0, 127)

      bytes = <<0xB::4, channel::4, number, channels>>

      message = %ControlChange{channel: channel, number: number, value: channels}
      assert message == MidiMessage.decode(bytes, channel_mode_messages: false)

      message = %ControlChange.MonoModeOn{channel: channel, channels: channels}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "PolyModeOn" do
      channel = random_between(0, 15)
      number = 127
      value = 0

      bytes = <<0xB::4, channel::4, number, value>>

      message = %ControlChange{channel: channel, number: number, value: value}
      assert message == MidiMessage.decode(bytes, channel_mode_messages: false)

      message = %ControlChange.PolyModeOn{channel: channel}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end
  end
end
