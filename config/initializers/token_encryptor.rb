require_relative '../../lib/encryptor.rb'

TokenEncryptor = Encryptor.new(key: ENVied.ENCRYPTION_KEY)
