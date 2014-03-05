# Copyright 2014 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'redis_helper'
require 'session_helper'
require 'spec_helper'
require 'tomcat_helper'

describe 'Redis' do
  include_context 'redis_helper'
  include_context 'session_helper'
  include_context 'tomcat_helper'

  it 'stores session data from Tomcat',
     fixture: 'default' do
    expect(redis.get(session_id).scrub).to match(session_data)
  end

  it 'caches session data in Tomcat',
     fixture: 'default' do
    expect(redis.get(session_id).scrub).to match(session_data)
    redis.del session_id
    expect(RestClient.get(location, cookies: {'JSESSIONID' => session_id})).to match(session_data)
  end

end
