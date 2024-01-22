defmodule MidiMessage.SystemExclusive.Universal.NonRealTimeTest do
  use ExUnit.Case, async: true
  use Faker.Random

  alias MidiMessage.SystemExclusive.Universal.NonRealTime

  describe "decode/1" do
    test "Unknown" do
      channel = random_between(0x00, 0x7F)

      bytes = <<0xF0, 0x7E, channel, 0x00, 0x00, 0xF7>>

      message = %NonRealTime.Unknown{
        bytes: bytes,
        channel: channel,
        sub_id_1: 0x00,
        sub_id_2: 0x00
      }

      assert NonRealTime.decode(bytes) == message

      assert MidiMessage.decode(bytes,
               system_exclusive_decoders: [MidiMessage.SystemExclusive.Universal]
             ) == message

      assert MidiMessage.encode(message) == bytes
    end

    test "IdentityRequest" do
      channel = random_between(0x00, 0x7F)

      bytes = <<0xF0, 0x7E, channel, 0x06, 0x01, 0xF7>>
      message = %NonRealTime.IdentityRequest{channel: channel}

      assert NonRealTime.decode(bytes) == message

      assert MidiMessage.decode(bytes,
               system_exclusive_decoders: [MidiMessage.SystemExclusive.Universal]
             ) == message

      assert MidiMessage.encode(message) == bytes
    end

    test "IdentityReply" do
      channel = random_between(0x00, 0x7F)
      id = <<0x00>>

      bytes = <<0xF0, 0x7E, channel, 0x06, 0x02>> <> id <> <<0xF7>>
      message = %NonRealTime.IdentityReply{channel: channel, id: id}

      assert NonRealTime.decode(bytes) == message

      assert MidiMessage.decode(bytes,
               system_exclusive_decoders: [MidiMessage.SystemExclusive.Universal]
             ) == message

      assert MidiMessage.encode(message) == bytes
    end
  end
end
