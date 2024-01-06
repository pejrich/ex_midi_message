defmodule MidiMessage.SystemExclusive.UniversalNonRealTime do
  # TODO: Fill this out.
  # Information: https://www.midi.org/specifications-old/item/table-4-universal-system-exclusive-messages
  defmodule IdentityRequest do
    defstruct [:channel]

    defimpl MidiMessage.Encoding do
      def encode(%IdentityRequest{channel: channel}),
        do: <<0xF0, 0x7E, channel, 0x06, 0x01, 0xF7>>
    end
  end

  defmodule IdentityReply do
    defstruct([:channel, :id])

    defimpl MidiMessage.Encoding do
      def encode(%IdentityReply{channel: channel, id: id}) do
        <<0xF0, 0x7E, channel, 0x06, 0x02>> <> id <> <<0xF7>>
      end
    end
  end

  defmodule Unknown, do: defstruct([:bytes])

  def decode(<<0xF0, 0x7E, channel, 0x06, 0x01, 0xF7>>), do: %IdentityRequest{channel: channel}

  def decode(<<0xF0, 0x7E, channel, 0x06, 0x02, rest::binary>>) do
    data_bytes = byte_size(rest) - 1
    <<id::binary-size(data_bytes), _::binary-size(1)>> = rest
    %IdentityReply{channel: channel, id: id}
  end

  def decode(<<0xF0, 0x7E, _rest::binary>> = bytes), do: %Unknown{bytes: bytes}
end
