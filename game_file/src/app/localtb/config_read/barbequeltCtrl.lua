local ltBase = include("ltBase")
local barbequeltCtrl = class("barbequeltCtrl", ltBase, include("aAReadClass").new())
local isInited = false
function barbequeltCtrl:ctor()
	barbequeltCtrl.super.ctor(self)
	self:init()
end
function barbequeltCtrl:init()
	if isInited then
		return
	end
	_UPVALUE2_ = nil
	;(nil)[1] = "bbq_challenge_exchange"
	;(nil)[2] = true
	self:defineValue("exchangeData", nil)
	_UPVALUE2_ = nil
	;(nil)[1] = "bbq_challenge_info_config"
	;(nil)[2] = true
	self:defineValue("infoConfig", nil)
	_ENV = nil
	;(nil)[1] = "bbq_challenge_info_view"
	self:defineValue("taskDes", nil)
	_ENV = nil
	;(nil)[1] = "bbq_challenge_type_view"
	self:defineValue("typeData", nil)
	self:defineValue("taskConfig", function()
		local _ENV, taskConfig
		for k, v in ipairs(infoConfig) do
			taskConfig[v.taskID] = v
		end
		return taskConfig
	end)
	local createData = function(name)
		self.useItemExchangeList, self, self.exchangeList, self, self.exchangeConfig = requrie_data("bbq_challenge_exchange", true, true).data, requrie_data("bbq_challenge_exchange", true, true).data, requrie_data("bbq_challenge_exchange", true, true).data, requrie_data("bbq_challenge_exchange", true, true).data, requrie_data("bbq_challenge_exchange", true, true).data
		for i, v in ipairs(self.exchangeConfig) do
			local exchangeID = v.exchangeID
			self.exchangeList[exchangeID] = v
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.useItem = serviceFunctions.tableFormat(v.useItem, nil)
			_UPVALUE2_ = nil
			;(nil)[1] = "id"
			;(nil)[2] = "count"
			v.result = serviceFunctions.tableFormat(v.result, nil)
			for k, item in ipairs(v.useItem) do
				if not self.useItemExchangeList[item.id] then
					self = self.useItemExchangeList[item.id]
				end
				self.useItemExchangeList[item.id] = self.useItemExchangeList[item.id]
				table.insert(self.useItemExchangeList[item.id], v)
			end
		end
		return self[name]
	end
	self:defineValue("exchangeConfig", createData)
	self:defineValue("exchangeList", createData)
	self:defineValue("useItemExchangeList", createData)
end
function barbequeltCtrl:getExchangeConfig()
	return self.exchangeList, self.useItemExchangeList
end
function barbequeltCtrl:getDayByTaskID(taskID)
	return self.taskConfig[taskID].day
end
function barbequeltCtrl:getTaskSetByTaskID(taskID)
	return self.taskConfig[taskID].taskSet
end
function barbequeltCtrl:getTaskRewardByTaskID(taskID)
	return self.taskConfig[taskID].rewards
end
function barbequeltCtrl:getTaskDesByTaskID(taskID)
	return self.taskDes[taskID].taskDes
end
function barbequeltCtrl:getGuideIdByTaskID(taskID)
	return self.taskDes[taskID].guideId
end
function barbequeltCtrl:getTaskTargetByTaskID(taskID)
	return self.taskConfig[taskID].conditionnum
end
function barbequeltCtrl:getTaskSettByTaskID(taskSet)
	return self.typeData[taskSet].taskDes
end
return barbequeltCtrl
