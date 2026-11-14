local baseFguiPanel = require("fgui.base.baseFguiPanel")
local MaigcLampOneKeyPanel = class("MaigcLampOneKeyPanel", baseFguiPanel)
local magicLampHatchRead = include("magicLampHatchRead")
local magicLampHatchCtrl = SoraDGetCtrl("magicLampHatchCtrl")
local publicRead = include("publicRead")
function MaigcLampOneKeyPanel:ctor(...)
	MaigcLampOneKeyPanel.super.ctor(self, ...)
	print("MaigcLampOneKeyPanel:ctor", self.viewName)
end
function MaigcLampOneKeyPanel:onInit()
	print("=======MaigcLampOneKeyPanel:onInit")
	self.fields.Panel_bg:setTitle(i18n("Jinn_hatch_text_58"))
	self.fields.Com_Slider:setInpuBoxFixPos(45, 180, 45)
	self.fields.Com_Slider:setSliderCallBack(handler(self, self.sliderCallBack))
	self.fields.desire:setTitle(i18n("Jinn_hatch_text_12"))
	self.fields.Button_pray:setTitle(i18n("Jinn_hatch_text_58"))
	self.fields.Button_pray:addClickEventListener(handler(self, self.onPrayClick))
	self.fields.btn_add:addClickEventListener(handler(self, self.onChooseClick))
	self.fields.com_item:setClickCallback(handler(self, self.onChooseClick))
end
function MaigcLampOneKeyPanel:onShow()
	print("=======MaigcLampOneKeyPanel:onShow")
	self:updateView()
end
function MaigcLampOneKeyPanel:updateView()
	self.hatchType = self.param.hatchType
	self.hatchData = magicLampHatchCtrl:getHatchData(self.hatchType)
	self.desireCfg = magicLampHatchRead.getDesireCfg(self.hatchType, self.hatchData.lv)
	self.desireItems = self.desireCfg.getItem
	self.desireInfo = self.hatchData.desireInfo
	self.chooseItemID = self.desireInfo.chooseItemID
	self.wishCfg = magicLampHatchRead.getWishCfg()
	self.fields.Button_pray:setCost(self.wishCfg.promoteItem[1], self.wishCfg.promoteItem[2])
	if self.chooseItemID ~= 0 then
		magicLampHatchCtrl = nil
		;(nil).item = publicRead.getName(self.chooseItemID)
		self.fields.text_tip1:setString(i18n("Jinn_hatch_text_41", nil))
		self.fields.com_item:setVisible(true)
		self.fields.icon_switch:setVisible(true)
		self.fields.btn_add:setVisible(false)
		self:setChooseItem(nil)
	else
		self.fields.text_tip1:setString(i18n("Jinn_hatch_text_8"))
		self.fields.com_item:setVisible(false)
		self.fields.icon_switch:setVisible(false)
		self.fields.btn_add:setVisible(true)
		self.fields.btn_add:setReddot(true)
	end
	self.maxNum = math.min(math.floor(self.desireInfo.disireResCount / self.wishCfg.promoteItem[2]), self.desireCfg.wishTimes - self.desireInfo.donateCount)
	magicLampHatchCtrl = self.desireCfg.wishTimes - self.desireInfo.donateCount
	;(self.desireCfg.wishTimes - self.desireInfo.donateCount).maxValue = self.maxNum
	;(self.desireCfg.wishTimes - self.desireInfo.donateCount).minValue = 1
	;(self.desireCfg.wishTimes - self.desireInfo.donateCount).curValue = 1
	self.fields.Com_Slider:initData(self.desireCfg.wishTimes - self.desireInfo.donateCount)
	local curCount = 1
	self.curCount = math.min(self.maxNum, curCount or 1)
	self.fields.progress:setMax(self.desireCfg.desire)
	self:sliderCallBack(self.curCount)
end
function MaigcLampOneKeyPanel:setChooseItem(data)
	if data == nil then
		for i, v in ipairs(self.desireItems) do
			if v.id == self.chooseItemID then
				data = v
				break
			end
		end
	end
	if data == nil then
		return
	end
	local realNum = magicLampHatchCtrl:getRealItemNum(self.hatchData.desireInfo.desire, data.num)
	self.fields.com_item:initData(data.id, realNum)
end
function MaigcLampOneKeyPanel:sliderCallBack(value)
	if 0 < value then
		self.curCount = value
		self.fields.progress:setValue(self.desireInfo.desire + value)
		self.fields.Button_pray:setCostNum(self.wishCfg.promoteItem[2] * value, self.desireInfo.disireResCount)
	end
end
function MaigcLampOneKeyPanel:onPrayClick()
	SoraDPlaySound()
	magicLampHatchCtrl = nil
	;(nil)[1] = self.desireInfo.donateCount
	;(nil)[2] = self.desireCfg.wishTimes
	dump(nil, "self.wishCfg.promoteItem[1]")
	if self.desireInfo.disireResCount < self.wishCfg.promoteItem[2] then
		_ENV = self.desireCfg.wishTimes
		self.desireCfg.wishTimes.item = publicRead.getName(self.wishCfg.promoteItem[1])
		SoraDShowMsgTip(i18n("common_text_1806", self.desireCfg.wishTimes))
		return
	end
	if not self.chooseItemID then
		SoraDShowMsgTip(i18n("Jinn_hatch_text_14"))
		return
	end
	if self.desireInfo.donateCount >= self.desireCfg.wishTimes then
		local nextDayUTC = serviceFunctions.getTomorrowZeroHourUTC()
		_ENV = i18n("Jinn_hatch_text_14")
		i18n("Jinn_hatch_text_14").time = SoraDConvertSecondToString(nextDayUTC - serviceFunctions.systemTime())
		SoraDShowMsgTip(i18n("Jinn_hatch_text_50", i18n("Jinn_hatch_text_14")))
		return
	end
	magicLampHatchCtrl:reqMagicLampHatchDonate(self.hatchType, self.curCount)
	self:close()
end
function MaigcLampOneKeyPanel:onChooseClick()
	if self.isCanReceive then
		return
	end
	SoraDPlaySound()
	_ENV = nil
	;(nil).hatchType = self.hatchType
	;(nil).desireItems = self.desireCfg.getItem
	uiManager:show("MagicLampHatchChoose", nil)
end
return MaigcLampOneKeyPanel
