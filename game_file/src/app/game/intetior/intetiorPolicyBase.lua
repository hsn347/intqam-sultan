local intetiorPolicyBase = class("intetiorPolicyBase")
local officialInfoRead = include("officialInfoRead")
local ID_GOLDBAR = tostring(gIDDef.GOLDBAR)
function intetiorPolicyBase:ctor(info)
	if not info.config then
		_UPVALUE0_ = info.config
	end
	self.config = info.config
	if not info.configView then
		_UPVALUE0_ = info.configView
	end
	self.configView = info.configView
end
function intetiorPolicyBase:getSkillID()
	return self.config.type
end
function intetiorPolicyBase:getSkillIcon()
	return self.configView.img or ""
end
function intetiorPolicyBase:getSkillName()
	return self.configView.typeName and i18n(self.configView.typeName) or ""
end
function intetiorPolicyBase:getSkillDes()
	return self.configView.text and i18n(self.configView.text) or ""
end
function intetiorPolicyBase:getSkillCDLastTime()
	return self.config.buffCD or 0
end
function intetiorPolicyBase:getSkillCDLastTime_Show()
	return math.min(self:getSkillCDLastTime() - self:getSkillEffectLastTime(), 0)
end
function intetiorPolicyBase:getSkillEffectLastTime()
	return self.config.buffTime or 0
end
function intetiorPolicyBase:getSkillCost()
	return self.config.buffCost or 0
end
function intetiorPolicyBase:getSkillIdentity()
	if not self.config.position then
		_UPVALUE1_ = self.config.position
		self.config.position[1] = 1
	end
	return self.config.position
end
function intetiorPolicyBase:getSkillIdentityStr()
	local position = self:getSkillIdentity()
	local _ENV, tabstr = self, self
	for _, v in ipairs(position) do
		local name = officialInfoRead.getInfoByName(v)
		if name then
			table.insert(tabstr, name)
		end
	end
	return table.concat(tabstr, ",")
end
function intetiorPolicyBase:resetSkillPolicyData(data)
	self.policyData, _UPVALUE0_ = nil, nil
end
function intetiorPolicyBase:setSkillPolicyData(data)
