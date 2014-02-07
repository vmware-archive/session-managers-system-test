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

require 'spec_helper'
require 'tomcat_helper'

describe 'Deploy' do
  include_context 'tomcat_helper'

  it 'expects session data to be stored and retrieved from a single instance',
     fixture: 'server' do
    session_data = 'Session data stored in Tomcat'
    location     = "http://localhost:#{tomcat_metadata[:http_port]}/session"
    response     = RestClient.post location, session_data, content_type: 'text/plain'
    cookies      = response.cookies
    expect(RestClient.get location, cookies: cookies).to eq(session_data)
  end
end
