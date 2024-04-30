while (true) do
  msg_length_bytes = STDIN.read(4)
  msg_length = msg_length_bytes.unpack("L>*")
  msg = STDIN.read(msg_length.first)
  
  response = msg + " PONG!"
  response_size_bytes = [response.bytesize].pack("L>*")
  STDOUT.write(response_size_bytes)
  STDOUT.flush
  STDOUT.write(response)
  STDOUT.flush
end