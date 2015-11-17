module Condor
  class Extractor
    class InvalidInput < RuntimeError; end

    attr_reader :event, :context

    def initialize(event, **context)
      @event   = event
      @context = context
    end

    def run
      event.inject({}) do |event_data, (domain, loggables)|
        loggables_data = loggables.inject({}) do |loggables_data, (loggable, d)|
          args = d.block.parameters.inject([]) do |args, (t, n)|
            args << n.to_sym if t === :keyreq
            args
          end
          begin
            loggables_data[loggable] = d.block.call(context.slice(*args))
          rescue StandardError => e
            raise InvalidInput, "bad '#{loggable}': #{e.message}"
          end
          loggables_data
        end
        event_data[domain] = loggables_data
        event_data
      end
    end
  end
end

