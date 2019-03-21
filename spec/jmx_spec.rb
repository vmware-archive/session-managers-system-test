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
require 'jmx4r'
require 'tomcat_helper'

describe 'JMX' do
  include_context 'tomcat_helper'

  before do
    JMX::MBean.establish_connection host: 'localhost', port: jmx_port
  end

  after do
    JMX::MBean.remove_connection host: 'localhost', port: jmx_port
  end

  it 'has an mbean for the session flush valve',
     fixture: 'default' do
    expect(JMX::MBean.find_by_name 'Catalina:type=Valve,context=/,host=localhost,name=SessionFlushValve').to be
  end

  it 'has an mbean for the Redis Store with accessible attributes',
     fixture: 'default' do
    store = JMX::MBean.find_by_name 'Catalina:type=Store,context=/,host=localhost,name=RedisStore'
    expect(store.connection_pool_size).to eq(-1)
    expect(store.database).to eq(0)
    expect(store.host).to eq('localhost')
    expect(store.password).to be_nil
    expect(store.port).to eq(6379)
    expect(store.timeout).to eq(2000)
    expect(store.uri).to eq('redis://localhost:6379/0')
  end
end
