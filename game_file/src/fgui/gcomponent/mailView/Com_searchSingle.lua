local lordLocalData = include("lordLocalData")
local allianceDesRead = include("allianceDesRead")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local baseComponent = require("fgui.base.baseComponent")
local Com_searchSingle = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://mailView/Com_searchSingle", Com_searchSingle)
function Com_searchSingle:onInit()
	self.fields.Text_powerLab:setString(i18n("common_text_090"))
	self:addClickListener(handler(self, self.btnClick))
	self:fixChildrenPos()
end
function Com_searchSingle:onShow()
end
function Com_searchSingle:initData(data)
	self.data = data
	self.fields.Image_portrait:setSpriteFrame(lordLocalData.getBust(self.data.iconID))
	self.fields.Text_power:setString(string.formatnumberthousands(self.data.totalFc))
	self.fields.Text_name:setString(self.data.nickName)
	self.fields.Com_castleLv:initData(self.data.cityLevel, self.data.starLv)
	if self.data.isAllianceMember then
		self.fields.Text_lastTime:setString(self.data.online == 0 and i18n("common_text_224") or SoraDConverSecondToDate(self.data.online, false, true))
	else
		self.fields.Text_lastTime:setString(self.data.language and allianceDesRead.getLanguageName(self.data.language) or "")
	end
end
function Com_searchSingle:setParent(parent)
	self.parent = parent
end
function Com_searchSingle:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_MAIL_UI_GIVE_PRESENT_PEOPLE_SELECTED"
	;(nil).name = self.data.nickName
	;(nil).abbr = self.data.allianceAbbr or ""
	;(nil).uid = self.data.uid
	;(nil).iconID = self.data.iconID
	SoraDSendMessage(nil)
	if self.parent then
		self.parent:close()
	end
end
return Com_searchSingle
