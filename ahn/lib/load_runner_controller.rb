# encoding: utf-8

class LoadRunner < Adhearsion::CallController

  def run
    answer
    main_menu
    logger.info "Test call #{call.id} has completed normally"
  end

  def main_menu
    menu standard_greeting, timeout: 5.seconds, tries: 3 do
      match 1, HandOffController
      match(2) { pass HandOffController }
      match(3) { play_audio_test }
      match(4) { dial_outbound }
      match(5) { originate_call }
      match(6) { hop_menu }
      match(7) { } #exit menu

      timeout { menu_error :input_timeout }
      invalid { menu_error :invalid_input }
      failure { menu_error :too_many_attempts }
    end
    logger.info "Completed main menu.  Exiting"
  end

  def hop_menu
    menu hop_audio, timeout: 5.seconds, tries: 3 do
      match(1) { logger.info "Handed off to hop_menu sucessfully" }
      timeout { menu_error :input_timeout }
      invalid { menu_error :invalid_input }
      failure { menu_error :too_many_attempts }
    end
  end

  def menu_error(reason)
    logger.error "Test call #{call.id} has failed: #{reason.to_s}"
    force_call_failure
    hangup
  end

  def play_audio_test
    play all_systems_go
  end

  def dial_outbound
    status = dial outbound_target, for: 30.seconds
    case status.result
    when :answer
      logger.info "Dial was answered successfully"
    when :error, :timeout
      force_call_failure
    when :no_answer
      force_call_failure
    end
  end

  def originate_call
    logger.info "Triggering outbound call for call: #{call.id}"
    Adhearsion::OutboundCall.originate outbound_target do
      answer
      play notification_audio
    end
  end

  def outbound_target
    target = ENV['OUTBOUND_TARGET'] || Adhearsion.config.platform.dial_target
    logger.info "Outbound target invoked as sip:#{target}"
    target
  end

  def standard_greeting
    "file:///vagrant/sounds/standard_greeting.wav"
  end

  def notification_audio
    "file:///vagrant/sounds/notification_audio.wav"
  end

  def all_systems_go
    "file:///vagrant/sounds/audio_check.wav"
  end

  def hop_audio
    "file:///vagrant/sounds/hop_audio.wav"
  end

  def force_call_failure
    sleep 20
    reject :error
  end
end
