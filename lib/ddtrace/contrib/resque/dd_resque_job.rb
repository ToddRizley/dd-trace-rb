require 'ddtrace/ext/app_types'

module Datadog
  module Contrib
    module DdResqueJob
      DEFAULT_CONFIG = {
        enabled: true,
        resque_service: 'resque',
        tracer: Datadog.tracer,
        debug: false,
        trace_agent_hostname: Datadog::Writer::HOSTNAME,
        trace_agent_port: Datadog::Writer::PORT
      }.freeze
        def initialize(options = {})
          # check if Rails configuration is available and use it to override
          rails_config = ::Rails.configuration.datadog_trace rescue {}
					Datadog::Tracer.log.debug("///////INIT RESQJOB")
					base_config = DEFAULT_CONFIG.merge(rails_config)
          user_config = base_config.merge(options)
          @tracer = user_config[:tracer]
          @resque_service = user_config[:resque_service]

          # set Tracer status
          @tracer.enabled = user_config[:enabled]
          Datadog::Tracer.debug_logging = user_config[:debug]

          # configure the Tracer instance
          @tracer.configure(
            hostname: user_config[:trace_agent_hostname],
            port: user_config[:trace_agent_port]
          )
        end

				def around_perform(*args)
					@tracer.trace('resque.job', service: 'helohello', span_type: 'job') do |span|
						span.set_tag('resque.queue', 'bonjour')
					yield 	
					end		
				end	

        private

        # rubocop:disable Lint/HandleExceptions
        def resource_worker(resource)
          Object.const_get(resource)
        rescue NameError
        end

        def worker_config(worker)
          if worker.respond_to?(:datadog_tracer_config)
            worker.datadog_tracer_config
          else
            {}
          end
        end

        def sidekiq_service(resource)
          worker_config(resource).fetch(:service, @sidekiq_service)
        end

        def set_service_info(service)

					Datadog::Tracer.log.debug("SET SERVICE FOR RESQ")
          return if @tracer.services[service]
          @tracer.set_service_info(
            service,
            'resque',
            Datadog::Ext::AppTypes::WORKER
          )
        end
      end
    end
  end
