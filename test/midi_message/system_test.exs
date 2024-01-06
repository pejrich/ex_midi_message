defmodule MidiMessage.SystemTest do
  import Bitwise
  use ExUnit.Case
  use Faker.Random

  alias MidiMessage.SystemExclusive

  alias MidiMessage.{
    SystemCommon,
    SystemRealTime
  }

  describe "decode / encdoe System Common Messages" do
    test "MIDITimeCodeQuarterFrame" do
      message_type = random_between(0, 7)
      values = random_between(0, 15)

      bytes = <<0xF1, 0::1, message_type::3, values::4>>
      message = %SystemCommon.MIDITimeCodeQuarterFrame{message_type: message_type, values: values}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "SongPositionPointer" do
      beats = random_between(0, 16383)

      beats_lsb = beats &&& 0b1111111
      beats_msb = beats >>> 7

      bytes = <<0xF2, 0::1, beats_lsb::7, 0::1, beats_msb::7>>
      message = %SystemCommon.SongPositionPointer{beats: beats}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "SongSelect" do
      value = random_between(0, 127)

      bytes = <<0xF3, 0::1, value::7>>
      message = %SystemCommon.SongSelect{value: value}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "TuneRequest" do
      bytes = <<0xF6>>
      message = %SystemCommon.TuneRequest{}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end
  end

  describe "decode / encode System Real Time Messages" do
    test "TimingClock" do
      bytes = <<0xF::4, 1::1, 0::3>>
      message = %SystemRealTime.TimingClock{}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "Start" do
      bytes = <<0xF::4, 1::1, 2::3>>
      message = %SystemRealTime.Start{}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "Continue" do
      bytes = <<0xF::4, 1::1, 3::3>>
      message = %SystemRealTime.Continue{}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "Stop" do
      bytes = <<0xF::4, 1::1, 4::3>>
      message = %SystemRealTime.Stop{}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "ActiveSensing" do
      bytes = <<0xF::4, 1::1, 6::3>>
      message = %SystemRealTime.ActiveSensing{}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "Reset" do
      bytes = <<0xF::4, 1::1, 7::3>>
      message = %SystemRealTime.Reset{}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end
  end

  describe "decode / encode System Exclusive Messages" do
    test "Valid Empty Message" do
      bytes = <<0xF0, 0xF7>>
      message = %SystemExclusive.Unknown{bytes: bytes}
      assert message == MidiMessage.decode(bytes)
      assert bytes == MidiMessage.encode(message)
    end

    test "Invalid Empty Message" do
      bytes = <<0xF0, 0x00>>
      assert_raise MidiMessage.InvalidMessage, fn -> MidiMessage.decode(bytes) end
    end
  end
end
