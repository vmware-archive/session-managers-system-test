# Encoding: utf-8
# Copyright 2014 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'
require 'redis'
require 'redis_helper'
require 'session_helper'
require 'scrub_rb'
require 'tomcat_helper'

describe 'Configuration' do
  include_context 'redis_helper'
  include_context 'session_helper'
  include_context 'tomcat_helper'

  context nil, ignore_startup_failure: true do

    it 'causes Tomcat to fail to start with incorrect Redis host',
       fixture: 'configure-host-negative' do
      expect(log_content).to match('redis.clients.jedis.exceptions.JedisConnectionException: Could not get a resource from the pool')
    end

    it 'causes Tomcat to fail to start with incorrect Redis password',
       fixture: 'configure-password-negative' do
      expect(log_content).to match('ERR Client sent AUTH, but no password is set')
    end

    it 'causes Tomcat to fail to start with incorrect Redis port',
       fixture: 'configure-port-negative' do
      expect(log_content).to match('redis.clients.jedis.exceptions.JedisConnectionException: Could not get a resource from the pool')
    end

    it 'causes Tomcat to fail to start with incorrect Redis URI',
       fixture: 'configure-uri-negative' do
      expect(log_content).to match('ERR Client sent AUTH, but no password is set')
    end

    it 'causes Tomcat to fail to start with incorrect database timeout',
       fixture: 'configure-timeout-negative' do
      expect(log_content).to match('java.lang.IllegalArgumentException: connect: timeout can\'t be negative')
    end

  end

  it 'causes data to be stored using a correctly configured uri',
     fixture:        'configure-uri',
     redis_database: 3 do
    expect(redis.get(session_id).scrub).to match(session_data)
  end

  it 'causes data to be stored in a non-default database',
     fixture:        'configure-database',
     redis_database: 3 do
    expect(redis.get(session_id).scrub).to match(session_data)
  end

  it 'causes a Redis Manager usage message to be logged',
     fixture: 'default' do
    expect(log_content).to match('Sessions will be persisted to Redis using a com.gopivotal.manager.redis.RedisStore')
  end

end
