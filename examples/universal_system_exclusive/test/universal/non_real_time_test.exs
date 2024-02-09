defmodule MidiMessage.SystemExclusive.Universal.NonRealTimeTest do
  use ExUnit.Case, async: true
  use Faker.Random

  alias MidiMessage.SystemExclusive.Universal
  alias Universal.NonRealTime

  describe "decode/1" do
    test "Unknown" do
      channel = random_between(0x00, 0x7F)

      bytes = <<0xF0, 0x7E, channel, 0x00, 0x00, 0xF7>>

      message = %NonRealTime.Unknown{
        bytes: bytes,
        channel: channel
      }

      assert NonRealTime.decode(bytes) == message

      assert MidiMessage.decode(bytes, system_exclusive_decoders: [Universal]) == message

      assert MidiMessage.encode(message) == bytes
    end

    test "IdentityRequest" do
      channel = random_between(0x00, 0x7F)

      bytes = <<0xF0, 0x7E, channel, 0x06, 0x01, 0xF7>>
      message = %NonRealTime.IdentityRequest{channel: channel}

      assert NonRealTime.decode(bytes) == message

      assert MidiMessage.decode(bytes, system_exclusive_decoders: [Universal]) == message

      assert MidiMessage.encode(message) == bytes
    end

    test "IdentityReply" do
      channel = random_between(0x00, 0x7F)
      id = <<0x00>>

      bytes = <<0xF0, 0x7E, channel, 0x06, 0x02>> <> id <> <<0xF7>>
      message = %NonRealTime.IdentityReply{channel: channel, id: id}

      assert NonRealTime.decode(bytes) == message

      assert MidiMessage.decode(bytes, system_exclusive_decoders: [Universal]) == message
      assert MidiMessage.encode(message) == bytes

      # Moog Slim Phatty
      channel = 0x7F
      id = <<0x04, 0x00, 0x05, 0x00, 0x02, 0x00, 0x00, 0x32, 0x5>>

      bytes = <<0xF0, 0x7E, channel, 0x06, 0x02>> <> id <> <<0xF7>>
      message = %NonRealTime.IdentityReply{channel: channel, id: id}

      assert NonRealTime.decode(bytes) == message

      assert MidiMessage.decode(bytes, system_exclusive_decoders: [Universal]) == message
      assert MidiMessage.encode(message) == bytes

      # AKAI MPK Mini Play
      channel = random_between(0x00, 0x7F)

      id =
        <<0x47, 0x44, 0x00, 0x19, 0x00, 0x00, 0x03, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
          0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
          0x00>>

      bytes = <<0xF0, 0x7E, channel, 0x06, 0x02>> <> id <> <<0xF7>>
      message = %NonRealTime.IdentityReply{channel: channel, id: id}

      assert NonRealTime.decode(bytes) == message

      assert MidiMessage.decode(bytes, system_exclusive_decoders: [Universal]) == message
      assert MidiMessage.encode(message) == bytes
    end
  end
end
