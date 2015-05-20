-- Copyright 2015 Boundary, Inc.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--    http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- @author Gabriel Nicolas Avellaneda <avellaneda.gabriel@gmail.com>
-- @copyright 2015 Boundary, Inc

local framework = require('framework')
local Plugin = framework.Plugin
local DataSource = framework.DataSource
local notEmpty = framework.string.notEmpty
local math = require('math')

local params = framework.params
params.name = 'Boundary Plugin Events'
params.version = '1.0'
params.tags = 'events'
params.pollInterval = notEmpty(params.pollInterval, 5000)

local randomEvent = (function ()
  local events = {
    'info', 'warn', 'error', 'critical'
  }
  return function () 
    local idx = math.random(1, #events) 
    return events[idx]
  end
end)()

local ds = DataSource:new(randomEvent)

local plugin = Plugin:new(params, ds)
function plugin:onParseValues(data)
  self:emitEvent(data, data:upper() .. ' event fired!.')
end

plugin:run()
