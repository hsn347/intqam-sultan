local ChangeAllianceLanguageSingle = class("changeAllianceLanguageSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("changeAllianceLanguageSingle")
	end
	return target
end)
function ChangeAllianceLanguageSingle:ctor()
	self.languageID = gLanguage.ALL
	self.scroll = nil
	self.singleIsMoved = false
	self.handle = nil
	self.labelName = SoraDGetChildByName(self, "Text_language")
	self.btnCheck = SoraDGetChildByName(self, "CheckBox_language")
	SoraDSetTextWidthHeight(self.labelName, cc.size(100, 60))
	if self.btnCheck then
		self.btnCheck:addEventListener(handler(self, self.btnClickCallBack))
		self:setCheck(false)
	end
end
function ChangeAllianceLanguageSingle:initData(lid)
	local allianceDesRead = include("allianceDesRead")
	self.languageID = lid
	self.labelName:setString(allianceDesRead.getLanguageName(self.languageID))
end
function ChangeAllianceLanguageSingle:setCheck(isCheck)
	self.btnCheck:setSelected(isCheck)
	self.btnCheck:setTouchEnabled(not isCheck)
	self.btnCheck:setSwallowTouches(false)
end
function ChangeAllianceLanguageSingle:setHandle(handle)
	self.handle = handle
end
function ChangeAllianceLanguageSingle:setScroll(scroll)
	self.scroll = scroll
end
function ChangeAllianceLanguageSingle:btnClickCallBack(button, type)
	if type == ccui.CheckBoxEventType.selected then
		if not SoraDIsNodeVisibleOnScroll(button, self.scroll) then
			button:setSelected(false)
			return
		end
		button:setTouchEnabled(false)
		button:setSwallowTouches(false)
		SoraDPlaySound()
		if self.handle then
			self.handle(self, self.languageID, type)
		end
	elseif type == ccui.CheckBoxEventType.unselected and self.handle then
		self.handle(self, self.languageID, type)
	end
end
return ChangeAllianceLanguageSingle
