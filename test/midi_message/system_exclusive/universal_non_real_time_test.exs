defmodule MidiMessage.SystemExclusive.UniversalNonRealTimeTest do
  use ExUnit.Case
  use Faker.Random

  alias MidiMessage.SystemExclusive.UniversalNonRealTime

  alias UniversalNonRealTime.{
    IdentityRequest,
    IdentityReply
  }

  describe "decode / encode Universal Non Real Time Messages" do
    test "Identity Request" do
      channel = random_between(0, 0x7F)

      bytes = <<0xF0, 0x7E, channel, 0x06, 0x01, 0xF7>>
      message = %IdentityRequest{channel: channel}

      assert message ==
               MidiMessage.decode(bytes, system_exclusive_decoders: [UniversalNonRealTime])

      assert bytes == MidiMessage.encode(message)
    end

    test "Identity Reply" do
      channel = random_between(0, 0x7F)

      id = <<
        random_between(0, 0x7F),
        random_between(0, 0x7F),
        random_between(0, 0x7F),
        random_between(0, 0x7F),
        random_between(0, 0x7F),
        random_between(0, 0x7F),
        random_between(0, 0x7F),
        random_between(0, 0x7F),
        random_between(0, 0x7F)
      >>

      bytes = <<0xF0, 0x7E, channel, 0x06, 0x02>> <> id <> <<0xF7>>
      message = %IdentityReply{channel: channel, id: id}

      assert message ==
               MidiMessage.decode(bytes, system_exclusive_decoders: [UniversalNonRealTime])

      assert bytes == MidiMessage.encode(message)
    end
  end
end
