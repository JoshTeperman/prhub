class Encryptor
  attr_reader :crypt

  def initialize(key:)
    @key = key
    @crypt = ActiveSupport::MessageEncryptor.new(key)
  end

  def encrypt(string)
    crypt.encrypt_and_sign(string)
  end

  def decrypt(string)
    crypt.decrypt_and_verify(string)
  end
end
