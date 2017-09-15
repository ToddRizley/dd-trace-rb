require 'ddtrace/ext/app_types'

module Datadog
  module Contrib
    module ResqueJob
      DEFAULT_CONFIG = {
        resque_service: 'resque',
        tracer: Datadog.tracer,
      }.freeze

			def before_perform(*args)
				rails_config = ::Rails.configuration.datadog_trace
				Datadog::Tracer.log.debug("///////INIT RESQJOB")
        base_config = DEFAULT_CONFIG.merge(rails_config)
				@tracer = Datadog.tracer
				Datadog::Tracer.log.debug("/////IN BEFORE_PERF")
				@tracer.trace('resque.job') do |span|
					span.resource = 'foobar'
					span.service = 'resque.job'
					span.span_type = Ext::AppTypes::WEB
					span.set_tag('resque.queue', 'bonjour hello')
				end		
			end	
		end
  end
end

