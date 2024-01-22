defmodule MidiMessage.SystemExclusive.UniversalTest do
  use ExUnit.Case, async: true
  use Faker.Random

  alias MidiMessage.SystemExclusive.Universal

  describe "decode/1" do
    test "decodes NonRealTime" do
      channel = random_between(0x00, 0x7F)

      bytes = <<0xF0, 0x7E, channel, 0x00, 0x00, 0xF7>>

      message = %Universal.NonRealTime.Unknown{
        bytes: bytes,
        channel: channel,
        sub_id_1: 0x00,
        sub_id_2: 0x00
      }

      assert Universal.decode(bytes) == message
      assert MidiMessage.decode(bytes, system_exclusive_decoders: [Universal]) == message
      assert MidiMessage.encode(message) == bytes
    end

    test "decodes RealTime" do
      channel = random_between(0x00, 0x7F)

      bytes = <<0xF0, 0x7F, channel, 0x00, 0x00, 0xF7>>

      message = %Universal.RealTime.Unknown{
        bytes: bytes,
        channel: channel,
        sub_id_1: 0x00,
        sub_id_2: 0x00
      }

      assert Universal.decode(bytes) == message
      assert MidiMessage.decode(bytes, system_exclusive_decoders: [Universal]) == message
      assert MidiMessage.encode(message) == bytes
    end
  end
end
