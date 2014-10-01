module Condor
  class Dispatcher
    attr_reader :event_list
    attr_reader :relays

    def initialize(event_list, relays)
      @event_list = event_list
      @relays     = relays
    end

    def dispatch(event, **context)
      # WIP
    end
  end
end
