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
			Datadog::Tracer.debug_logging=true
  		Datadog::Tracer.log.debug("/////IN BEFORE_PERF")
			@tracer.trace('resque.job', start_time: Time.now, service: 'resque.job') do |span| 
    	span.resource = 'foobar'
    	span.span_type = Ext::AppTypes::WEB
    	span.set_tag('resque.queue', 'bonjourhello')
    	span.set_tag('resque.job', self)
    	yield  
			Datadog::Tracer.log.debug("/////// DONE JOB")
			end
		end	
		
	#		def before_perform(*args)
	#			rails_config = ::Rails.configuration.datadog_trace
	#			Datadog::Tracer.log.debug("///////INIT RESQJOB")
  #      base_config = DEFAULT_CONFIG.merge(rails_config)
	#			@tracer = Datadog.tracer
	#			Datadog::Tracer.log.debug("/////IN BEFORE_PERF")
	#			span = @tracer.trace('resque.job', service: 'resque.job') 
	#			span.resource = 'foobar'
	#			span.span_type = Ext::AppTypes::WEB
	#			span.set_tag('resque.queue', 'self.queue')
	#			span.set_tag('resque.job', self)
	#			span.finish()

	#		end
#			def after_perform(*args)
#				Datadog::Tracer.log.debug("///// AFTER PERFORM")
#			end
		end
  end
end

