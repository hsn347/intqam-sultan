local pickupStarsAgainCtrl = SoraDGetCtrl("pickupStarsAgainCtrl")
local pickupStarsAgainRead = include("pickupStarsAgainRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local DesertMeteoriteStartPanel = class("DesertMeteoriteStartPanel", baseFguiPanel)
_UPVALUE3_ = "DesertMeteoriteStartPanel"
DIFFICUTY_LANGUAGE, ("DesertMeteoriteStartPanel")[1] = "DesertMeteoriteStartPanel", "pickup_star_011"
DIFFICUTY_LANGUAGE, ("DesertMeteoriteStartPanel")[2] = "DesertMeteoriteStartPanel", "pickup_star_012"
DIFFICUTY_LANGUAGE, ("DesertMeteoriteStartPanel")[3] = "DesertMeteoriteStartPanel", "pickup_star_013"
function DesertMeteoriteStartPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("DesertMeteoriteStartPanel:ctor", self.viewName)
end
function DesertMeteoriteStartPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function DesertMeteoriteStartPanel:onInit()
	print("=======DesertMeteoriteStartPanel:onInit")
	self.fields.Panel_bg:setString(i18n("pickup_star_019"))
	self.fields.Text_desc:setString(i18n("pickup_star_008"))
	local difficultyList = pickupStarsAgainRead:getDesetMeteoritesDifficulty()
	_UPVALUE3_ = pickupStarsAgainRead
	self.buttons, _ENV, pickupStarsAgainRead[1] = self.fields.Button1, self.fields.Button1, self.fields.Button1
	self.buttons, _ENV, pickupStarsAgainRead[2] = self.fields.Button1, self.fields.Button1, self.fields.Button2
	local self.buttons, _ENV, pickupStarsAgainRead[3], buttons = self.fields.Button1, self.fields.Button1, self.fields.Button3, pickupStarsAgainRead
	for i, v in ipairs(difficultyList) do
		local difficultyInfo = v
		local btn = buttons[i]
		if btn then
			_ENV = i18n("pickup_star_008")
			i18n("pickup_star_008").time = SoraDConverSecondToDate(difficultyInfo.Time)
			btn:setString(i18n(DIFFICUTY_LANGUAGE[i], i18n("pickup_star_008")))
			btn:setTag(i)
			btn:addClickListener(handler(self, self.onClickBtn))
			table.insert(self.buttons, btn)
		end
	end
	for index, value in ipairs(buttons) do
		value:fixPos()
	end
end
function DesertMeteoriteStartPanel:onClickBtn(context)
	SoraDPlaySound()
	local tag = context:getSender():getTag()
	if SoraDEnoughTroops() then
		local dispatchPanel = uiManager:show("WorldDispatchArmyView")
		local exploreTime = pickupStarsAgainRead:getDesetMeteoritesDifficulty()[tag].Time
		_ENV = nil
		;(nil).toPoint = self.param:getTilePoint()
		_ENV, (nil).instanceID = self.param.instanceID, self.param.instanceID
		;(nil).otherData, self.param.instanceID.exploreTime = self.param.instanceID, exploreTime
		;(nil).dispatchType = worldMapDefine.worldMapTipButtonType_desertMeteorite
		;(nil).instanceType = gMapObjTypeDef.desertMeteorite
		dispatchPanel:initData(nil)
	end
	self:close()
end
function DesertMeteoriteStartPanel:onShow()
	print("=======DesertMeteoriteStartPanel:onShow")
	self.fields.Loader_banner:setURL("bg_zlxc_01.png")
	local leftTime = pickupStarsAgainCtrl:getExploreLeftTime()
	_ENV = nil
	;(nil).time = SoraDConvertSecondToString(leftTime)
	self.fields.Text_time:setString(i18n("pickup_star_010", nil))
	local gray = leftTime <= 0
	for index, value in ipairs(self.buttons) do
		value:setTouchable(not gray)
		value:setGrayed(gray)
	end
end
return DesertMeteoriteStartPanel
