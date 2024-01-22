defmodule MidiMessage.SystemExclusive.Universal.RealTimeTest do
  use ExUnit.Case, async: true
  use Faker.Random

  alias MidiMessage.SystemExclusive.Universal.RealTime

  describe "decode/1" do
    test "Unknown" do
      channel = random_between(0x00, 0x7F)

      bytes = <<0xF0, 0x7F, channel, 0x00, 0x00, 0xF7>>

      message = %RealTime.Unknown{
        bytes: bytes,
        channel: channel,
        sub_id_1: 0x00,
        sub_id_2: 0x00
      }

      assert RealTime.decode(bytes) == message

      assert MidiMessage.decode(bytes,
               system_exclusive_decoders: [MidiMessage.SystemExclusive.Universal]
             ) == message

      assert MidiMessage.encode(message) == bytes
    end
  end
end
