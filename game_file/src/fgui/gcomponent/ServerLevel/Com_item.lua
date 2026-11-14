local worldKingdomLvDesRead = include("worldKingdomLvDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_item = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://ServerLevel/Com_item", Com_item)
function Com_item:onInit()
	self:fixChildrenPos()
end
function Com_item:onShow()
end
function Com_item:initData(itemData)
	dump(itemData, "initData")
	self.itemInfo = itemData
	self:setItemValue()
	local buffName = ""
	local imgIcon = worldKingdomLvDesRead.getBuffIcon(self.itemInfo.buffType)
	local realImg = SoraDCheckPNG(imgIcon, "icon_item_common.png")
	self.fields.Image_ItemIcon:setURL(realImg)
	if self.itemInfo.isBig then
		if self.itemInfo.value == self.itemInfo.value1 then
			self.fields.Image_ItemArrow:setVisible(false)
		else
			self.fields.Image_ItemArrow:setVisible(true)
		end
		self:setMeGray(false)
		buffName = worldKingdomLvDesRead.getDes(self.itemInfo.buffType, self.itemInfo.condition)
	else
		self.fields.Image_ItemArrow:setVisible(false)
		local value = self.itemInfo.isBig and self.itemInfo.value or self.itemInfo.value1
		if value and value <= 0 then
			self:setMeGray(true)
		else
			self:setMeGray(false)
		end
		buffName = worldKingdomLvDesRead.getDes(self.itemInfo.buffType, self.itemInfo.condition1)
	end
	self.fields.Text_ItemDes:setString(buffName)
end
function Com_item:setItemValue()
	local rs = ""
	local value = self.itemInfo.isBig and self.itemInfo.value or self.itemInfo.value1
	local isShowValueIcon = false
	if self.itemInfo.effectType == 1 then
		rs = "+" .. value / 10 .. "%"
	elseif self.itemInfo.effectType == 2 then
		if self.itemInfo.buffType == 113 then
			local isShowWarLv, textLv = SoraDGetBuildWarLv(value)
			if isShowWarLv then
				rs = textLv
				isShowValueIcon = true
			else
				rs = value
			end
		elseif self.itemInfo.buffType == 112 or self.itemInfo.buffType == 111 then
			rs = value
		else
			rs = "+" .. value
		end
	elseif self.itemInfo.effectType == 3 then
		rs = value / 60 .. i18n("common_text_545")
	elseif self.itemInfo.effectType == 4 then
		rs = value == 0 and "" or i18n("common_text_246")
	else
		rs = value
	end
	self.fields.Text_ItemValue:setString(rs)
	self.controllers.c1:setSelectedIndex(isShowValueIcon and 0 or 1)
end
function Com_item:setMeGray(bool)
	self.fields.Image_ItemIcon:setGrayed(bool)
	if bool then
		self.fields.Text_ItemValue:setColor(cc.c3b(75, 75, 75))
		self.fields.Text_ItemDes:setColor(cc.c3b(75, 75, 75))
	else
		self.fields.Text_ItemValue:setColor(cc.c3b(112, 199, 35))
		self.fields.Text_ItemDes:setColor(cc.c3b(180, 170, 135))
	end
end
return Com_item
