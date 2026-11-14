local gametop = gModuleMgr.getObject("gametop")
local intetiorCtrl = gametop.playertop_:getModule("intetiorCtrl")
local intetiorRead = include("intetiorRead")
local baseComponent = require("fgui.base.baseComponent")
local intetiorMainPolicyOrder = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Intetior/intetiorMainPolicyOrder", intetiorMainPolicyOrder)
function intetiorMainPolicyOrder:onInit()
	self.fields.List:setItemRenderer(handler(self, self.onItemRender))
end
function intetiorMainPolicyOrder:onShow()
	self:initSkill()
	local data = intetiorCtrl:getDecreeData()
	self:updatePolicyData_imp(data)
	self:initView()
end
function intetiorMainPolicyOrder:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_DECREE_DATA_RSP", handler(self, self.rspPolicyData))
	SoraDAddMessage(self, "MESSAGE_SERVER_INTETIOR_DECREE_DATA_UPDATE", handler(self, self.updatePolicyData))
end
function intetiorMainPolicyOrder:rspPolicyData(target, data)
	SoraDCloseLoading()
	if data.err == gErrDef.Err_None and data.info then
		self:updatePolicyData(target, data)
	end
end
function intetiorMainPolicyOrder:updatePolicyData_imp(data)
	for i, v in pairs(data) do
		local policyId = tonumber(i)
		if policyId then
			local skill = self.skillList[policyId]
			if skill then
				skill:setSkillPolicyData(v)
			end
		end
	end
end
function intetiorMainPolicyOrder:updatePolicyData(target, data)
	if data.info then
		self:resetSkill()
		self:updatePolicyData_imp(data.info)
		self:initView()
	end
end
function intetiorMainPolicyOrder:req4Data()
	intetiorCtrl:reqParliamentDecreeData()
	SoraDShowLoading()
end
function intetiorMainPolicyOrder:resetSkill()
	for _, v in pairs(self.showList) do
		v:resetSkillPolicyData()
	end
end
function intetiorMainPolicyOrder:initSkill()
	local intetiorRead, showList
	local intetiorRead, skillList
	local config = intetiorRead:getPolicyOrderTable()
	for i, v in ipairs(config) do
		local configView = intetiorRead:getPolicyOrderView(v.type)
		intetiorRead = "intetiorPolicySkill"
		;("intetiorPolicySkill").config = v
		;("intetiorPolicySkill").configView = configView
		;("intetiorPolicySkill").skillType = 2
		local skill = include("intetiorPolicySkill").new("intetiorPolicySkill")
		table.insert(showList, skill)
		skillList[i] = skill
	end
	self.skillList = skillList
	self.showList = showList
end
function intetiorMainPolicyOrder:initView()
	self.fields.List:setNumItems(#self.showList)
end
function intetiorMainPolicyOrder:onItemRender(index, target)
	target:initData(self.showList[index + 1])
end
return intetiorMainPolicyOrder
