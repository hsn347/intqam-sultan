local mailNumTip = class("mailNumTip", function(target)
	if target and tolua.type(target) == "string" then
		target = SoraDCreateTouchPanel(target)
	end
	return target or SoraDCreateTouchPanel("mailNumTip")
end)
function mailNumTip:ctor(properties)
	self:setSwallowTouches(false)
	self:setBackGround(0)
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.img = SoraDGetChildByName(self, "Image")
	self.bgWidth = 400
	self.textTitleList = SoraDGetChildsArrayByName(self, "Text_Title_", 5, 1)
	_UPVALUE5_, self.textValueList = SoraDGetChildsArrayByName(self, "Text_Value_", 5, 1), SoraDGetChildsArrayByName(self, "Text_Value_", 5, 1)
	SoraDGetChildsArrayByName(self, "Text_Value_", 5, 1)[1] = "mail_2_text_36"
	SoraDGetChildsArrayByName(self, "Text_Value_", 5, 1)[2] = "battlelog_text_19"
	SoraDGetChildsArrayByName(self, "Text_Value_", 5, 1)[3] = "battlelog_text_20"
	SoraDGetChildsArrayByName(self, "Text_Value_", 5, 1)[4] = "battlelog_text_21"
	local SoraDGetChildsArrayByName(self, "Text_Value_", 5, 1)[5], nameConfig = "battlelog_text_22", SoraDGetChildsArrayByName(self, "Text_Value_", 5, 1)
	for i, v in ipairs(self.textTitleList) do
		v:setString(i18n(nameConfig[i]) .. ": ")
	end
end
function mailNumTip:initData(numList)
	local maxWidth = 400
	local newWidth = 0
	for i, num in ipairs(numList) do
		local posX = self.textTitleList[i]:getContentSize().width
		self.textValueList[i]:setString(string.formatnumberthousands(num))
		self.textValueList[i]:setPositionX(SoraDFPosX(-posX - 25, 0))
		local width = math.abs(-posX - 25) + self.textValueList[i]:getContentSize().width
		if maxWidth < width then
			newWidth = maxWidth
			SoraDSetTextWidthHeight(self.textValueList[i], cc.size(maxWidth - math.abs(-posX - 25), 40))
		elseif width > newWidth then
			newWidth = width
		end
	end
	self.bgWidth = newWidth + 20
	self.img:setContentSize(cc.size(newWidth + 20, 222.0))
end
function mailNumTip:getItemWidth()
	return self.bgWidth
end
return mailNumTip
