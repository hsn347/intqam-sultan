local atlantisActivityCtrl = SoraDGetCtrl("atlantisActivityCtrl")
local lordSpineDef = include("lordSpineDef")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local AtlantisTreasurePanel = class("AtlantisTreasurePanel", baseFguiPanel)
function AtlantisTreasurePanel:ctor(...)
	self.super.ctor(self, ...)
	print("AtlantisTreasurePanel:ctor", self.viewName)
end
function AtlantisTreasurePanel:getPackageList()
	if not self._packageList then
		_UPVALUE2_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "Activity2112"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
	end
	return self._packageList
end
function AtlantisTreasurePanel:onInit()
	print("=======AtlantisTreasurePanel:onInit")
	self.fields.Com_title:initData(i18n("atlantiswar_text_0366"), handler(self, self.onClickClose), handler(self, self.onClickHelp))
	self.fields.Label_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("atlantiswar_text_0375", nil)
	end)
	self.fields.Label_time:setTimeEndListener(function()
		self.fields.Label_time:setString(i18n("Anchor_text_21"))
		self:refreshTreasureTime()
	end)
	self.fields.Button_treasure1:setString(i18n("atlantiswar_text_0426"))
	self.fields.Button_treasure1:getChild("Text_des"):setString(i18n("atlantiswar_text_0427"))
	for treasureType = 1, 3 do
		local Button_treasure = self.fields["Button_treasure" .. treasureType]
		Button_treasure:setTag(treasureType)
		Button_treasure:addClickListener(handler(self, self.onClickTreasure))
	end
end
function AtlantisTreasurePanel:onShow()
	print("=======AtlantisTreasurePanel:onShow")
	atlantisActivityCtrl:reqGetTreasureInfo()
	local remainTime = atlantisActivityCtrl:getTreasureRemainTime()
	if 0 < remainTime then
		self.fields.Label_time:beginTime(remainTime)
	else
		self.fields.Label_time:setString(i18n("Anchor_text_21"))
	end
end
function AtlantisTreasurePanel:onClickHelp(...)
	SoraDPlaySound()
	_ENV = nil
	;(nil).content = i18n("atlantiswar_text_0367")
	uiManager:show("RuleView", nil)
end
function AtlantisTreasurePanel:onClickSend(EventContext)
	SoraDPlaySound()
	local treasureType = EventContext:getSender():getTag()
	_ENV = nil
	;(nil).treasureType = treasureType
	uiManager:show("AtlantisTreasureSend", nil)
end
function AtlantisTreasurePanel:refreshView(...)
	local data = atlantisActivityCtrl:getTreasureInfo()
	atlantisActivityCtrl = nil
	;(nil).kingdomName = data.kingdomName
	;(nil).kid = data.top1Kid
	self.fields.Text_kingdom:setString(i18n("atlantiswar_text_0373", nil))
	local info = lordSpineDef.getLordSpineInfo(data.iconID)
	if info then
		self.fields.Com_spine:setEffectPath(info.json)
	end
	atlantisActivityCtrl = i18n("atlantiswar_text_0373", nil)
	i18n("atlantiswar_text_0373", nil).Name = data.nickName
	self.fields.Text_player:setString(i18n("atlantiswar_text_0374", i18n("atlantiswar_text_0373", nil)))
	local isSender = atlantisActivityCtrl:checkIsTreasureSender()
	self.fields.Button_send2:setVisible(isSender)
	self.fields.Button_send3:setVisible(isSender)
	if isSender then
		for treasureType = 2, 3 do
			local Button_send = self.fields["Button_send" .. treasureType]
			Button_send:setTag(treasureType)
			Button_send:addClickListener(handler(self, self.onClickSend))
		end
	end
	self:refreshTreasureTime()
	self:refreshTreasureData()
end
function AtlantisTreasurePanel:refreshTreasureTime(...)
	if not atlantisActivityCtrl:checkIsTreasureSender() then
		return
	end
	local remainTime = atlantisActivityCtrl:getTreasureRemainTime()
	for treasureType = 2, 3 do
		local Button_send = self.fields["Button_send" .. treasureType]
		if 0 < remainTime then
			Button_send:setString(i18n("atlantiswar_text_0380"))
		else
			Button_send:setEnabled(false)
			Button_send:setString(i18n("Anchor_text_21"))
		end
	end
end
function AtlantisTreasurePanel:onClickTreasure(EventContext)
	SoraDPlaySound()
	local treasureType = EventContext:getSender():getTag()
	_ENV = nil
	;(nil).treasureType = treasureType
	uiManager:show("AtlantisTreasureReward", nil)
end
function AtlantisTreasurePanel:refreshTreasureData(...)
	if not atlantisActivityCtrl:getTreasureInfo().atlantisWarTreasureData then
		atlantisActivityCtrl = atlantisActivityCtrl:getTreasureInfo().atlantisWarTreasureData
	end
	self.atlantisWarTreasureData = atlantisActivityCtrl:getTreasureInfo().atlantisWarTreasureData
	local AST = require_data("atlantiswar_season_treasure", true).data
	for treasureType = 2, 3 do
		local Button_treasure = self.fields["Button_treasure" .. treasureType]
		local Text_des = Button_treasure:getChild("Text_des")
		local Button_send = self.fields["Button_send" .. treasureType]
		local countMax = AST[treasureType].count
		if not self.atlantisWarTreasureData[tostring(treasureType)] then
			local atlantisActivityCtrl, typeData = self.atlantisWarTreasureData[tostring(treasureType)], self.atlantisWarTreasureData[tostring(treasureType)]
		end
		typeData = table.keys(typeData)
		table.sort(typeData)
		local count = math.max(0, countMax - #typeData)
		atlantisActivityCtrl = nil
		;(nil).var = count
		;(nil).var1 = countMax
		Button_treasure:setString(i18n("atlantiswar_text_0378", nil))
		if count <= 0 then
			Button_send:setEnabled(false)
			atlantisActivityCtrl = i18n("atlantiswar_text_0378", nil)
			i18n("atlantiswar_text_0378", nil).var = fguiHelper.getColorString("#ff0000", count)
			i18n("atlantiswar_text_0378", nil).var1 = countMax
			Button_treasure:setString(i18n("atlantiswar_text_0378", i18n("atlantiswar_text_0378", nil)))
		else
			atlantisActivityCtrl = i18n("atlantiswar_text_0378", i18n("atlantiswar_text_0378", nil))
			i18n("atlantiswar_text_0378", i18n("atlantiswar_text_0378", nil)).var = count
			i18n("atlantiswar_text_0378", i18n("atlantiswar_text_0378", nil)).var1 = countMax
			Button_treasure:setString(i18n("atlantiswar_text_0378", i18n("atlantiswar_text_0378", i18n("atlantiswar_text_0378", nil))))
		end
		local str = i18n("atlantiswar_text_0379") .. [[


]]
		if next(typeData) then
			for _, v in ipairs(typeData) do
				str = string.format("%s  #%s", str, v)
			end
		else
			str = string.format("%s%s", str, i18n("common_text_480"))
		end
		Text_des:setString(str)
	end
end
return AtlantisTreasurePanel
