local vipLocalData = include("vipLocalData")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_vipSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://vipCenterView/Com_vipSingle", Com_vipSingle)
function Com_vipSingle:onInit()
	self.fields.Btn_item:setVisible(false)
	self.fields.Btn_item:addClickListener(handler(self, self.btnItemClick))
	self.fields.Com_larger:setVisible(false)
	self:fixChildrenPos()
	self.fields.nbg:fix()
end
function Com_vipSingle:onShow()
end
function Com_vipSingle:getValueStr(value, onlyValue)
	local rs = ""
	if self.itemInfo.effectType == 1 then
		rs = "+" .. value / 10 .. "%"
	elseif self.itemInfo.effectType == 2 then
		rs = "+" .. value
	elseif self.itemInfo.effectType == 3 then
		rs = value / 60 .. i18n("common_text_545")
	elseif self.itemInfo.effectType == 4 and not onlyValue then
		rs = value == 0 and "" or i18n("common_text_246")
	elseif self.itemInfo.effectType == 5 and not onlyValue then
		if 0 < value then
			if 15 < value then
				_ENV = "common_text_545"
				;("common_text_545").lv = value - 15
				rs = i18n("common_text_3974", "common_text_545")
			else
				_ENV = "common_text_545"
				;("common_text_545").lv = value
				rs = i18n("common_text_2838", "common_text_545")
			end
		else
			rs = i18n("common_text_2839")
		end
	elseif self.itemInfo.effectType == 6 then
		_ENV = "common_text_545"
		;("common_text_545").value = value
		rs = i18n("common_text_1952", "common_text_545")
	end
	return rs
end
function Com_vipSingle:initData(data)
	self.itemInfo = data
	self.fields.icon:setSpriteFrame(vipLocalData.vipBuffDes[self.itemInfo.buffType].icon)
	self.fields.Btn_item:setVisible(self.itemInfo.effectType == 5)
	self.fields.new:setVisible(self.itemInfo.isNew)
	local nameStr = i18n(vipLocalData.vipBuffDes[self.itemInfo.buffType].name)
	local valueStr = fguiHelper.getColorString("#4CE61A", self:getValueStr(self.itemInfo.value))
	vipLocalData = self:getValueStr(self.itemInfo.value)
	self:getValueStr(self.itemInfo.value).var1 = nameStr
	self:getValueStr(self.itemInfo.value).var2 = valueStr
	self.fields.Text_des:setString(i18n("%{var1}%{var2}", self:getValueStr(self.itemInfo.value)))
	if self.itemInfo.addValue and self.itemInfo.addValue ~= 0 then
		local rs = self:getValueStr(self.itemInfo.addValue, true)
		if rs ~= "" then
			self.fields.Com_larger:setVisible(true)
			self.fields.Com_larger:initData(self:getValueStr(self.itemInfo.addValue, true))
		else
			self.fields.Com_larger:setVisible(false)
		end
	else
		self.fields.Com_larger:setVisible(false)
	end
end
function Com_vipSingle:btnItemClick()
	SoraDPlaySound()
	if not lordInfoCtrl:getVipDailyGiftInfo(self.itemInfo.value) then
		local _ENV, itemList = lordInfoCtrl:getVipDailyGiftInfo(self.itemInfo.value), lordInfoCtrl:getVipDailyGiftInfo(self.itemInfo.value)
	end
	if next(itemList) then
		local panel = SoraDCreatePanel("commonItemShowBox")
		panel:initVipData(self.itemInfo.value, itemList)
		panel:show()
	end
end
return Com_vipSingle
