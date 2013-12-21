# encoding: utf-8

class LoadRunner < Adhearsion::CallController

  def run
    answer
    logger.info "Call to #{call.to} received"
    case call.to
    when /wait/
      logger.info "Waiting..."
      sleep 60
    when /invoke/
      logger.info "Invoking..."
      invoke HandOffController
    when /pass/
      logger.info "Passing..."
      pass HandOffController
    when /play/
      logger.info "Playing..."
      play_audio_test
    when /dial/
      logger.info "Dialing..."
      dial_outbound
    when /originate/
      logger.info "Originating..."
      originate_call
    when /menu/
      logger.info "Menuing..."
      hop_menu
    else
      force_call_failure
    end
    logger.info "Test call #{call.id} has completed normally"
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
    play notification_audio
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
    "file:///vagrant/adhearsion-versus/audio/standard_greeting.wav"
  end

  def notification_audio
    "file:///vagrant/adhearsion-versus/audio/notification_audio.wav"
  end

  def all_systems_go
    "file:///vagrant/adhearsion-versus/audio/audio_check.wav"
  end

  def hop_audio
    "file:///vagrant/adhearsion-versus/audio/hop_audio.wav"
  end

  def force_call_failure
    sleep 20
    reject :error
  end
end
