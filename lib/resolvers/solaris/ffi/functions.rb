# frozen_string_literal: true

module Facter
  module Resolvers
    module Solaris
      module FFI
        module Socket
          extend ::FFI::Library
          ffi_lib '/usr/lib/libsocket.so'
          attach_function :open, :socket, %i[int int int], :int
          attach_function :close, [:int], :int
          attach_function :inet_ntop, %i[int pointer pointer uint], :string
        end

        module Ioctl
          extend ::FFI::Library
          ffi_lib ::FFI::Library::LIBC
          attach_function :ioctl_base, :ioctl, %i[int int pointer], :int

          def self.ioctl(call_const, pointer, address_family = AF_INET)
            fd = Socket.open(address_family, SOCK_DGRAM, 0)
            result = ioctl_base(fd, call_const, pointer)
            Socket.close(fd)
            result
          end
        end
      end
    end
  end
end
