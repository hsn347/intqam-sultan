local allianceDesRead = include("allianceDesRead")
local baseComponent = require("fgui.base.baseComponent")
local allianceSettingsListSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://AllianceManageView/allianceSettingsListSingle", allianceSettingsListSingle)
function allianceSettingsListSingle:onInit()
	self.fields.Button_single:addClickListener(handler(self, self.btnClick))
	self.fields.Sprite_arr:fixPos()
	self.fields.Text_title:fixPos()
end
function allianceSettingsListSingle:onShow()
end
function allianceSettingsListSingle:initData(tag, curTag)
	self.singleTag = tag
	self.curTag = curTag
	self.isOpen = self.singleTag == self.curTag
	self.fields.Sprite_arr:setRotation(self.isOpen and 0 or SoraDFIsRA() and 90 or -90)
	self.fields.Text_title:setString(allianceDesRead.getSettingsName(self.singleTag))
	self.fields.Load:removeAllChildren()
	if self.isOpen then
		local node = self:getNode()
		node:initData(self.singleTag)
		self.fields.Load:addChild(node)
		self:setHeight(55 + node:getHeight())
	else
		self:setHeight(55)
	end
end
function allianceSettingsListSingle:getNode()
	_ENV, _ENV = nil, nil
	_ENV, (nil)[1], (nil).url = nil, nil, "changeSloganNode"
	_ENV, (nil)[2], (nil).url = nil, nil, "changeOpenRecruitmentNode"
	_ENV, (nil)[3], (nil).url = nil, nil, "changeAllianceNicknameNode"
	_ENV, (nil)[4], (nil).url = nil, nil, "changeAllianceNicknameNode"
	_ENV, (nil)[5], (nil).url = nil, nil, "changeAllianceLanguageNode"
	_ENV, (nil)[6], (nil).url = nil, nil, "changeAllianceRankTitleNode"
	;(nil)[7], (nil).url = nil, "changeTerritoryColorNode"
	local nodeCfg
	return fgui.UIPackage:createObjectFromURL("ui://AllianceManageView/" .. nodeCfg[self.singleTag].url)
end
function allianceSettingsListSingle:btnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).msg = "MESSAGE_ALLIANCE_UI_MANAGER_SETTING_SELECT"
	;(nil).tag = self.singleTag
	SoraDSendMessage(nil)
end
return allianceSettingsListSingle
