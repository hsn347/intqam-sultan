local legendTeamCtrl = SoraDGetCtrl("legendTeamCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_addHead = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://LegendaryKing/Com_addHead", Com_addHead)
function Com_addHead:onInit()
	self.fields.Com_add:addClickListener(handler(self, self.btnAddClick))
	self.fields.Btn_remove:addClickListener(handler(self, self.btnRemoveClick))
	self.fields.Btn_remove:setVisible(false)
	self.fields.sheer:fix()
end
function Com_addHead:onShow()
end
function Com_addHead:initData(uid)
	self.uid = uid
	if uid then
		self.controllers.c1:setSelectedIndex(1)
		if legendTeamCtrl:isTeamLeader() or legendTeamCtrl:isTeamCommander(uid) and uid == SoraDGetPlayerID() then
			self.fields.Btn_remove:setVisible(true)
		else
			self.fields.Btn_remove:setVisible(false)
		end
		local member = legendTeamCtrl:getTeamMemberInfo(uid)
		self.fields.Com_head:setPlayerID(uid)
		if member then
			self.fields.Com_head:setHeadSprite(member.headid, member.avatar)
			self.fields.Text_online:setString(member.online == 0 and i18n("common_text_224") or i18n("common_text_3976"))
			self.controllers.c2:setSelectedIndex(member.online == 0 and 0 or 1)
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Btn_remove:setVisible(false)
	end
end
function Com_addHead:btnAddClick()
	SoraDPlaySound()
	if not legendTeamCtrl:isTeamLeader() then
		SoraDShowMsgTip(i18n("legendary_commander_text3"))
		return
	end
	if not legendTeamCtrl:isPrepareStatus() then
		SoraDShowMsgTip(i18n("legendary_commander_text7"))
		return
	end
	uiManager:show("legendarySearchView")
end
function Com_addHead:btnRemoveClick()
	SoraDPlaySound()
	local content = i18n("legendary_commander_text9")
	if legendTeamCtrl:isTeamLeader() then
		content = i18n("legendary_commander_text4")
	end
	_ENV = nil
	;(nil).content = content
	;(nil).confirmString = i18n("common_text_204")
	;(nil).cancelString = i18n("common_text_185")
	;(nil).confirmFunc = function()
		if not legendTeamCtrl:isPrepareStatus() then
			SoraDShowMsgTip(i18n("legendary_commander_text7"))
			return
		end
		if legendTeamCtrl:isTeamLeader() then
			legendTeamCtrl:reqExpelMember(self.uid)
		else
			legendTeamCtrl:reqQuitTeam()
		end
	end
	uiManager:show("MessageBox", nil)
end
return Com_addHead
