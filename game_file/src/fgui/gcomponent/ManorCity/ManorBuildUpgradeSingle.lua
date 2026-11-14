local manorCityRead = include("manorCityRead")
local resDesRead = include("resDesRead")
local itemDesRead = include("itemDesRead")
local baseComponent = require("fgui.base.baseComponent")
local ManorBuildUpgradeSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ManorCity/ManorBuildUpgradeSingle", ManorBuildUpgradeSingle)
function ManorBuildUpgradeSingle:onInit()
	self.fields.Button_jump:addClickListener(handler(self, self.onClickBtnJump))
	if not SoraDFIsRA() then
		self:fixChildrenPos()
	end
end
function ManorBuildUpgradeSingle:onShow()
end
function ManorBuildUpgradeSingle:onClickBtnJump(context)
	SoraDPlaySound()
	if self.handleCallBack then
		self.handleCallBack(self.data)
	end
end
function ManorBuildUpgradeSingle:isConditionMet(isMet)
	if isMet then
		self.controllers.c_met:setSelectedIndex(0)
	else
		self.controllers.c_met:setSelectedIndex(1)
	end
	self.isMet = isMet
end
function ManorBuildUpgradeSingle:setBtnCallBcak(handle)
	self.handleCallBack = handle
end
function ManorBuildUpgradeSingle:initData(data)
	self:removeTimer()
	local c1 = self.fields.Button_jump:getController("c1")
	c1:setSelectedIndex(2)
	self.data = data
	self:isConditionMet(self.data.singleData.isreach)
	local singleType = self.data.singleType
	if singleType == MANOR_COND_TYPE.TIME then
		self:needSpeedUp()
	elseif singleType == MANOR_COND_TYPE.BUILD then
		self:needBuild()
	elseif singleType == MANOR_COND_TYPE.ITEM then
		self:needItem()
	elseif singleType == MANOR_COND_TYPE.RES then
		self:needResource()
	end
end
function ManorBuildUpgradeSingle:needSpeedUp()
	self.fields.Button_jump:setString(i18n("common_text_018"))
	local c1 = self.fields.Button_jump:getController("c1")
	c1:setSelectedIndex(1)
	local qtype = tonumber(self.data.singleData.qtype)
	self.fields.Image_icon:setURL("icon_hourglass.png")
	self:openTimeUp()
	self.timer = SoradCreateTimer(self, handler(self, self.openTimeUp))
end
function ManorBuildUpgradeSingle:openTimeUp(dt)
	local _data = self.data.singleData
	local buildName = manorCityRead.getBuildName(_data.data.bid)
	manorCityRead = nil
	;(nil).name = buildName
	local typeStr = i18n("common_text_755", nil)
	local queue = _data
	local leftTime = queue.timerNode.timer:getRemainTime()
	self.fields.Text_des:setString(typeStr .. " " .. SoraDConvertSecondToString(leftTime))
	if leftTime <= 0 then
		self:buildTimerEnd()
	end
end
function ManorBuildUpgradeSingle:buildTimerEnd()
	if self.data.singleType == MANOR_COND_TYPE.TIME then
		self:removeTimer()
	end
end
function ManorBuildUpgradeSingle:removeTimer()
	if self.timer then
		SoraDManagerRemoveTimer(self, self.timer)
		self.timer = nil
	end
end
function ManorBuildUpgradeSingle:needBuild()
	local _data = self.data.singleData
	self.fields.Button_jump:setString(i18n("common_text_382"))
	local buildID = _data.bid
	local imageName = manorCityRead.getBuildSmallImage(buildID)
	self.fields.Image_icon:setURL(imageName)
	local buildName = manorCityRead.getBuildName(buildID)
	local buildLv = _data.blv
	_ENV = i18n("common_text_382")
	i18n("common_text_382").name = buildName
	i18n("common_text_382").lv = buildLv
	local desStr = i18n("common_text_334", i18n("common_text_382"))
	self.fields.Text_des:setString(desStr)
end
function ManorBuildUpgradeSingle:needItem()
	local _data = self.data.singleData
	self.fields.Button_jump:setString(i18n("common_text_337"))
	local toolID = _data.toolid
	local imageName = itemDesRead.getIcon(toolID)
	self.fields.Image_icon:setURL(imageName)
	local itemName = itemDesRead.getName(toolID)
	local curCount = _data.curcount
	local toolCount = _data.toolcount
	local desStr = itemName .. "   " .. string.formatnumberthousands(curCount) .. "/" .. string.formatnumberthousands(toolCount)
	self.fields.Text_des:setString(desStr)
end
function ManorBuildUpgradeSingle:needResource()
	local _data = self.data.singleData
	self.fields.Button_jump:setString(i18n("common_text_337"))
	local imageName = resDesRead.getIcon(_data.resid)
	self.fields.Image_icon:setURL(imageName)
	local desStr = string.formatnumberthousands(_data.rescount)
	self.fields.Text_des:setString(desStr)
end
return ManorBuildUpgradeSingle
