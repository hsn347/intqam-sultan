local buffDesRead = include("buffDesRead")
local PROGRESSLEN = 370
local PROGRESSHEIGHT = 20
local godEquipmentAttrSingle = class("godEquipmentAttrSingle", function(luaFileName)
	return SoraDCreateBasePanel("godEquipmentAttrSingle")
end)
function godEquipmentAttrSingle:ctor()
	self.buffID = nil
	self.Text_attr = SoraDGetChildByName(self, "Text_attr")
	self.Text_percent = SoraDGetChildByName(self, "Text_percent")
	self.Text_percent_ex = SoraDGetChildByName(self, "Text_percent_ex")
	self.Text_percent_ex:setVisible(false)
	self.Image_cur = SoraDGetChildByName(self, "Image_cur")
	self.Image_preview = SoraDGetChildByName(self, "Image_preview")
	self.Image_preview:setVisible(false)
end
function godEquipmentAttrSingle:initData(buffID, curValue, preValue, maxValue)
	self.buffID = buffID
	self.Text_attr:setString(buffDesRead.getTitleBase(self.buffID))
	self.Text_percent:setString(buffDesRead.getTitleValueWithValue(self.buffID, SoraDPreciseDecimal(curValue, 2), true))
	self:setPreviewModel(curValue, preValue, maxValue)
end
function godEquipmentAttrSingle:limitShow(buffID, buffValue)
	self.buffID = buffID
	self.Text_percent_ex:setVisible(false)
	self.Text_attr:setString(buffDesRead.getTitleBase(self.buffID))
	self.Text_percent:setString(buffDesRead.getTitleValueWithValue(self.buffID, SoraDPreciseDecimal(buffValue, 2), true))
	self:setCurProgressBar()
end
function godEquipmentAttrSingle:setPreviewModel(curValue, preValue, maxValue)
	curValue = SoraDPreciseDecimal(curValue, 1)
	preValue = SoraDPreciseDecimal(preValue, 1)
	local curPercent = curValue / maxValue
	local prePercent = preValue / maxValue
	print("godEquipmentAttrSingle:setPreviewModel", curValue, preValue, maxValue)
	if maxValue == curValue and curValue == preValue then
		print("满属性")
		self:limitShow(self.buffID, curValue)
	elseif curValue < preValue then
		print("洗出好属性")
		self:setPreviewProgressBar(prePercent, cc.c3b(0, 190, 30))
		self:setCurProgressBar(curPercent, cc.c3b(0, 103, 255))
		self.Text_percent_ex:setVisible(true)
		self.Text_percent_ex:setColor(cc.c3b(0, 255, 30))
		self.Text_percent_ex:setString(SoraDFValueSuit(buffDesRead.getTitleValueWithValue(self.buffID, SoraDPreciseDecimal(preValue - curValue, 2), true)))
		self.Text_percent_ex:setPositionX(self.Text_percent:getPositionX() - SoraDFPosX(self.Text_percent:getContentSize().width + 10, 0))
	elseif preValue == curValue then
		print("白属性")
		self:setPreviewProgressBar(curPercent, cc.c3b(0, 103, 255))
		self:setCurProgressBar(curPercent, cc.c3b(0, 103, 255))
		self.Text_percent:setColor(cc.c3b(255, 255, 255))
		self.Text_percent_ex:setVisible(false)
	else
		print("差属性")
		self:setPreviewProgressBar(curPercent, cc.c3b(190, 40, 40))
		self:setCurProgressBar(prePercent, cc.c3b(0, 103, 255))
		self.Text_percent_ex:setVisible(true)
		self.Text_percent_ex:setColor(cc.c3b(255, 0, 0))
		self.Text_percent_ex:setString(SoraDFValueSuit(buffDesRead.getTitleValueWithValue(self.buffID, SoraDPreciseDecimal(curValue - preValue, 2), true), "-"))
		self.Text_percent_ex:setPositionX(self.Text_percent:getPositionX() - SoraDFPosX(self.Text_percent:getContentSize().width + 10, 0))
	end
end
function godEquipmentAttrSingle:setCurProgressBar(percent, color)
	local percent = percent or 1
	percent = math.min(percent, 1)
	percent = math.max(percent, 0)
	local color = color or cc.c3b(225, 121, 0)
	self.Image_cur:setContentSize(cc.size(PROGRESSLEN * percent, PROGRESSHEIGHT))
	self.Image_cur:setColor(color)
end
function godEquipmentAttrSingle:setPreviewProgressBar(percent, color)
	local percent = percent or 1
	percent = math.min(percent, 1)
	percent = math.max(percent, 0)
	local color = color or cc.c3b(225, 121, 0)
	self.Image_preview:setContentSize(cc.size(PROGRESSLEN * percent, PROGRESSHEIGHT))
	self.Image_preview:setColor(color)
	self.Image_preview:setVisible(true)
end
return godEquipmentAttrSingle
