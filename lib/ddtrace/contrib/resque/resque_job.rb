require 'ddtrace/ext/app_types'

module Datadog
  module Contrib
    module ResqueJob
      DEFAULT_CONFIG = {
        resque_service: 'resque',
        tracer: Datadog.tracer,
      }.freeze

			def around_perform(*args)
				rails_config = ::Rails.configuration.datadog_trace
				Datadog::Tracer.log.debug("///////INIT RESQJOB")
        base_config = DEFAULT_CONFIG.merge(rails_config)
				@tracer = Datadog.tracer
res = nil
				Datadog::Tracer.log.debug("/////IN AROUND_PERF")
				@tracer.trace('resque.job') do |span|
					span.resource = 'foobar'
					span.service = 'resque.job'
					span.span_type = Ext::AppTypes::WEB
					span.set_tag('resque.queue', 'bonjour')
					yield
				end		
			end	
		end
  end
end

