local officialInfoRead = include("officialInfoRead")
local buffDesRead = include("buffDesRead")
local mailFunctions = include("mailFunctions")
local buffDesRead = include("buffDesRead")
local intetiorRead = include("intetiorRead")
local intetiorUtil = include("intetiorUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_LogItem = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Intetior/Com_LogItem", Com_LogItem)
fgui.register_extension("ui://Intetior/Com_LogItem2", Com_LogItem)
_ENV = fgui.register_extension
fgui.register_extension.STEAL_FAIL = 1
fgui.register_extension.STEAL_SUCCESS = 2
local fgui.register_extension.CHARGE, gParliamentTrickLogType = 3, fgui.register_extension
function Com_LogItem:onInit()
	self:fixChildrenPos()
end
function Com_LogItem:onShow()
end
function Com_LogItem:initData(info, index)
	dump(info, "info")
	if self.fields.bg then
		self.fields.bg:setVisible(math.fmod(index, 2) == 1)
	end
	if info.dataType == 1 then
		return self:createSingle_Trick(info, index)
	else
		return self:createSingle_Doate(info, index)
	end
end
function Com_LogItem:createSingle_Trick(info, index)
	local mailFunctions, config
	local name = mailFunctions:getWrappedName(info.allianceAbb, info.name)
	config.name = name
	local strKey = "parliament_text_13"
	local type = info.type
	if type == gParliamentTrickLogType.STEAL_FAIL then
		local effectValue = buffDesRead.getTitleWithValue(info.effectType, info.effectValue or 0)
		config.sting = effectValue
	elseif type == gParliamentTrickLogType.STEAL_SUCCESS then
		strKey = "parliament_text_135"
		config.num = info.stealNum
	elseif type == gParliamentTrickLogType.CHARGE then
		strKey = "parliament_text_136"
		config.num = info.num
		config.trickname = intetiorRead:getTrickName(info.trickId)
	end
	self.fields.Text_info:setString(i18n(strKey, config))
	self.fields.Text_time:setString(_G.SoraDConverTimeStr(info.t))
end
function Com_LogItem:createSingle_Doate(info, index)
	local mailFunctions, config
	local name = mailFunctions:getWrappedName(info.allianceAbb, info.name)
	if info.official then
		local officialName = officialInfoRead.getInfoByName(info.official)
		if officialName then
			name = officialName .. name
		end
	end
	config.name = name
	config.num = info.num or 0
	local strKey
	if info.type == 1 then
		strKey = "parliament_text_12"
	else
		local policyName = intetiorRead:getPolicyBaseName(info.policyId)
		config.policyName = policyName
		strKey = "parliament_text_126"
	end
	self.fields.Text_info:setString(i18n(strKey, config))
	self.fields.Text_time:setString(_G.SoraDConverTimeStr(info.t))
end
function Com_LogItem:initPolicyData(info, showType, index)
	dump(info, "info")
	if self.fields.bg then
		self.fields.bg:setVisible(math.fmod(index, 2) == 1)
	end
	if showType == 1 then
		return self:createSingle_Policy(info)
	else
		return self:createSingle_Order(info)
	end
end
function Com_LogItem:createSingle_Policy(info)
	local mailFunctions, config
	local name = mailFunctions:getWrappedName(info.allianceAbb, info.name)
	local officialName = officialInfoRead.getInfoByName(1)
	if officialName then
		name = officialName .. name
	end
	config.lord = name
	local policyName = intetiorRead:getPolicyBaseName(info.policyId)
	config.policyName = policyName
	local strKey = "unknown"
	if info.type == 1 then
		config.des = intetiorRead:getPolicyBaseDes(info.policyId)
		strKey = "parliament_text_61"
	elseif info.type == 2 then
		strKey = "parliament_text_113"
	end
	self.fields.Text_info:setString(i18n(strKey, config))
	self.fields.Text_time:setString(_G.SoraDConverTimeStr(info.t))
end
function Com_LogItem:createSingle_Order(info)
	local des = intetiorUtil:getOrderDes(info)
	self.fields.Text_info:setString(des)
	self.fields.Text_time:setString(_G.SoraDConverTimeStr(info.t))
end
return Com_LogItem
