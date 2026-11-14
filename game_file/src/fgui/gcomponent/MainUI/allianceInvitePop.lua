local gametop = gModuleMgr.getObject("gametop")
local allianceMgr = gametop.playertop_:getModule("allianceMgr")
local baseComponent = require("fgui.base.baseComponent")
local allianceInvitePop = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://MainUI/allianceInvitePop", allianceInvitePop)
function allianceInvitePop:onInit()
	self.fields.Button_close:addClickListener(handler(self, self.onBtnCloseClick))
	self.fields.Button_name:addClickListener(handler(self, self.onBtnNameClick))
	self.fields.Button_green:setString(i18n("common_text_140"))
	self.fields.Button_green:addClickListener(handler(self, self.onBtnGreenClick))
	self.fields.Text_msg:setString(i18n("common_text_4331"))
	self.fields.Button_close:fixPos()
	self.fields.Com_head:fixPos()
	self.fields.Text_lordName:fixPos()
	self.fields.Text_msg:fixPos()
	self.fields.Button_green:fixPos()
	self.fields.Button_name:fixPos()
end
function allianceInvitePop:onShow()
	self.fields.Sprite_arrow:setPositionX(SoraDFIsRA() and 60 or 500)
end
function allianceInvitePop:onBtnCloseClick()
	SoraDPlaySound()
	self:setVisible(false)
end
function allianceInvitePop:onBtnNameClick()
	SoraDPlaySound()
	local allianceQuery = gametop.playertop_:getModule("allianceQuery")
	_ENV = nil
	;(nil).from = "AllianceInvitePop"
	allianceQuery:reqAllianceInfo(gametop.playertop_:getKingdomID(), self.info.aid, nil)
end
function allianceInvitePop:onBtnGreenClick()
	SoraDPlaySound()
	self:setVisible(false)
	local funUnlockRead = include("funUnlockRead")
	local unlockLv = funUnlockRead.getUnlockLevel(gFunBuildKey.ALLIANCE)
	if unlockLv <= SoraDGetCastleLv() then
		allianceMgr:reqAgreeInviteJoin(self.info.aid, self.info.leaderid)
	else
		_ENV = self.info.leaderid
		self.info.leaderid.name = i18n("common_text_069")
		self.info.leaderid.lv = unlockLv
		SoraDShowMsgTip(i18n("common_text_2122", self.info.leaderid))
	end
end
function allianceInvitePop:initData(info)
	self.info = info
	_ENV = nil
	;(nil).abbr = self.info.allianceName
	;(nil).name = self.info.leadername
	local showName = i18n("common_text_186", nil)
	self.fields.Text_lordName:setString(showName)
	self.fields.Com_head:setHeadSprite(self.info.iconID, self.info.avatar)
	self.fields.Com_head:setPlayerID(self.info.leaderid)
	self.fields.Com_head:setKid(gametop.playertop_:getKingdomID())
end
return allianceInvitePop
