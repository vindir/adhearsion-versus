# encoding: utf-8

class HandOffController < Adhearsion::CallController
  def run
    answer
    logger.info "Test call #{call.id} has entered the HandOffController"
    handoff_menu
  end

  def handoff_menu
    menu handoff_audio, timeout: 5.seconds, tries: 3 do
      match(1) { main_menu }
      match(2) {} #Exit menu
      timeout { menu_error :input_timeout }
      invalid { menu_error :invalid_input }
      failure { menu_error :too_many_attempts }
    end
  end

  def main_menu
    pass LoadRunner
  end

  def menu_error(reason)
    logger.error "Test call #{call.id} has failed: #{reason.to_s}"
    force_call_failure
    hangup
  end

  def force_call_failure
    sleep 20
    reject :error
  end

  def handoff_audio
    "file:///vagrant/adhearsion-versus/audio/hop_audio.wav"
  end
end
