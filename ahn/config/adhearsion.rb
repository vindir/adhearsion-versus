# encoding: utf-8

Adhearsion.config do |config|

  config.development do |dev|
    dev.platform.logging.level = :info
  end

  config.platform do
    dial_target "SIP/userb", :desc => 'Target for Dial and Originate Tests'
  end

#  config.punchblock.username = "usera@freeswitch.local-dev.mojolingo.com"
#  config.punchblock.password = "1"

#  config.punchblock.platform = :asterisk # Use Asterisk
#  config.punchblock.username = "manager" # Your AMI username
#  config.punchblock.password = "password" # Your AMI password
#  config.punchblock.host = "asterisk.local-dev.mojolingo.com" # Your AMI host

end

Adhearsion::Events.draw do
end

Adhearsion.router do
  route 'default', LoadRunner
end
