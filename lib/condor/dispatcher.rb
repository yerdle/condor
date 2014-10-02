module Condor
  class Dispatcher
    attr_reader :event_list
    attr_reader :relays

    def initialize(event_list, relays)
      @event_list = event_list
      @relays     = relays
    end

    def dispatch(event, **context)
      event = event_list[event]

      # This could probably be easily moved into the registry classes for less
      # nested complexity.
      event_data = event.inject({}) do |event_data, (domain, loggables)|
        loggables_data = loggables.inject({}) do |loggables_data, (loggable, d)|
          args = d.block.parameters.inject([]) do |args, (t, n)|
            args << n.to_sym if t === :keyreq
            args
          end
          loggables_data[loggable] = d.block.call(**context.slice(*args))
          loggables_data
        end
        event_data[domain] = loggables_data
        event_data
      end

      relays.each { |relay| relay.publish(event_data) }
    end
  end
end
