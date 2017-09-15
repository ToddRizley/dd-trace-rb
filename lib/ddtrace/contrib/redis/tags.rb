require 'ddtrace/ext/net'
require 'ddtrace/ext/redis'

module Datadog
  module Contrib
    module Redis
      # Tags handles generic common tags assignment.
      module Tags
        module_function

        def set_common_tags(client, span, raw_command)
          span.set_tag Datadog::Ext::NET::TARGET_HOST, client.host
          span.set_tag Datadog::Ext::NET::TARGET_PORT, client.port
          span.set_tag Datadog::Ext::Redis::DB, client.db
          span.set_tag Datadog::Ext::Redis::RAW_COMMAND, raw_command 
        end
      end
    end
  end
end
