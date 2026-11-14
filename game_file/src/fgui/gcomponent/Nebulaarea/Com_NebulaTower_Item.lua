local baseComponent = require("fgui.base.baseComponent")
local Com_NebulaTower_Item = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://Nebulaarea/Com_NebulaTower_Item", Com_NebulaTower_Item)
local nebulaTowerLvDesRead = include("nebulaTowerLvDesRead")
function Com_NebulaTower_Item:onInit()
	if not SoraDFIsRA() then
		self:fixChildrenPos(false, true)
	end
end
function Com_NebulaTower_Item:onShow()
end
function Com_NebulaTower_Item:setData(data, isBig)
	self.isBig = isBig
	local value = self.isBig and data.value or data.value1
	local isShowValueIcon = false
	local rs = ""
	if data.effectType == 1 then
		rs = "+" .. value / 10 .. "%"
	elseif data.effectType == 2 then
		if data.buffType == 113 then
			local isShowWarLv, textLv = SoraDGetBuildWarLv(value)
			if isShowWarLv then
				rs = textLv
				isShowValueIcon = true
			else
				rs = value
			end
		elseif data.buffType == 112 or data.buffType == 111 then
			rs = value
		else
			rs = "+" .. value
		end
	elseif data.effectType == 3 then
		rs = value / 60 .. i18n("common_text_545")
	elseif data.effectType == 4 then
		rs = value == 0 and "" or i18n("common_text_246")
	else
		rs = value
	end
	self.fields.text_value:setString(rs)
	if isShowValueIcon == true then
		self.fields.value_icon:setSize(cc.size(50, 50))
	else
		self.fields.value_icon:setSize(cc.size(0, 50))
	end
	self.fields.value_icon:setVisible(isShowValueIcon)
	local buffName = ""
	local imgIcon = nebulaTowerLvDesRead.getBuffIcon(data.buffType)
	local realImg = SoraDCheckPNG(imgIcon, "icon_item_common.png")
	self.fields.imgIcon:setURL(realImg)
	if self.isBig then
		if data.value == data.value1 then
			self.fields.imgArrow:setVisible(false)
		else
			self.fields.imgArrow:setVisible(true)
		end
		self:setMeGray(false)
		buffName = nebulaTowerLvDesRead.getDes(data.buffType, data.condition)
	else
		self.fields.imgArrow:setVisible(false)
		local value = self.isBig and data.value or data.value1
		if value and value <= 0 then
			self:setMeGray(true)
		else
			self:setMeGray(false)
		end
		buffName = nebulaTowerLvDesRead.getDes(data.buffType, data.condition1)
	end
	self.fields.text_desc:setString(buffName)
end
function Com_NebulaTower_Item:setMeGray(bool)
	if bool then
		self.fields.text_value:setColor(cc.c3b(75, 75, 75))
		self.fields.imgIcon:setGrayed(true)
		self.fields.text_desc:setColor(cc.c3b(75, 75, 75))
	else
		self.fields.text_value:setColor(cc.c3b(0, 255, 0))
		self.fields.imgIcon:setGrayed(false)
		self.fields.text_desc:setColor(cc.c3b(205, 180, 140))
	end
end
return Com_NebulaTower_Item
