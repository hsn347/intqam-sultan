local gametop = gModuleMgr.getObject("gametop")
local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
local intetiorRead = include("intetiorRead")
local baseComponent = require("fgui.base.baseComponent")
local intetiorMainPolicyBase = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Intetior/intetiorMainPolicyBase", intetiorMainPolicyBase)
function intetiorMainPolicyBase:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
end
function intetiorMainPolicyBase:onShow()
	self:req4Data()
	self:initSkill()
	local data = intetiorCtrl:getPolicyData()
	self:updatePolicyData_imp(data)
	self:initView()
end
function intetiorMainPolicyBase:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_POLICY_DATA_RSP", handler(self, self.rspPolicyData))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_POLICY_DATA_UPDATE", handler(self, self.updatePolicyData))
end
function intetiorMainPolicyBase:rspPolicyData(target, data)
	if data.err == gErrDef.Err_None and data.info then
		self:updatePolicyData(target, data)
	end
end
function intetiorMainPolicyBase:updatePolicyData_imp(info)
	for i, v in pairs(info) do
		local policyId = tonumber(i)
		if policyId then
			local skill = self.skillList[policyId]
			if skill then
				skill:setSkillPolicyData(v)
			end
		end
	end
end
function intetiorMainPolicyBase:updatePolicyData(target, data)
	if data.info then
		self:resetSkill()
		self:updatePolicyData_imp(data.info)
		self:initView()
	end
end
function intetiorMainPolicyBase:req4Data()
	intetiorCtrl:reqParliamentPolicyData()
end
function intetiorMainPolicyBase:resetSkill()
	for _, v in pairs(self.showList) do
		v:resetSkillPolicyData()
	end
end
function intetiorMainPolicyBase:initSkill()
	local intetiorRead, showList
	local intetiorRead, skillList
	local config = intetiorRead:getPolicyBaseTable()
	for i, v in ipairs(config) do
		local configView = intetiorRead:getPolicyBaseView(v.type)
		intetiorRead = "intetiorPolicySkill"
		;("intetiorPolicySkill").config = v
		;("intetiorPolicySkill").configView = configView
		;("intetiorPolicySkill").skillType = 1
		local skill = include("intetiorPolicySkill").new("intetiorPolicySkill")
		table.insert(showList, skill)
		skillList[i] = skill
	end
	self.skillList = skillList
	self.showList = showList
end
function intetiorMainPolicyBase:initView()
	table.sort(self.showList, function(a, b)
		if a:isSkillEffect() ~= b:isSkillEffect() then
			return a:isPolicyPolicy()
		end
		if a:isPolicyPromise() ~= b:isPolicyPromise() then
			return a:isPolicyPromise()
		end
		return a:getSkillID() < b:getSkillID()
	end)
	self.fields.List:setNumItems(#self.showList)
end
function intetiorMainPolicyBase:onItemRender(index, target)
	target:initData(self.showList[index + 1])
end
return intetiorMainPolicyBase
