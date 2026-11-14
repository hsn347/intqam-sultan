local baseComponent = require("fgui.base.baseComponent")
local Com_team = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NebulaOfflcer/Com_team", Com_team)
local nebulaPrivilegeCtrl = SoraDGetCtrl("nebulaPrivilegeCtrl")
local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
function Com_team:onInit()
	self:addClickListener(handler(self, self.onClick))
	self:showHelp(false)
end
function Com_team:onShow()
end
function Com_team:initOfficerID(officerID, forceBig)
	self.forceBig = forceBig
	local cfg = nebulaPrivilegelRead.getOfficerInfo(officerID)
	self:updateDataOfficer(cfg)
end
function Com_team:updateDataOfficer(cfg)
	self.cfg = cfg
	local info = nebulaPrivilegeCtrl:getOfficer(cfg.officerID)
	self.info = info
	if info then
		self:updateDataOfficerHasPerson(cfg, info)
	else
		self.controllers.c1:setSelectedIndex(1)
		self:updateDataOfficerNoPerson(cfg)
	end
	self:setString(i18n(cfg.name))
end
function Com_team:updateDataOfficerNoPerson(cfg)
	self.fields.imgHead:setSpriteFrame(cfg.img2)
	local isAppointID = nebulaPrivilegelRead.checkIsAppointID(cfg.officerID)
	self:showHelp(isAppointID)
	local isKing = nebulaPrivilegeCtrl:isKing(cfg.appointID)
	self:setReddot(isKing)
end
function Com_team:updateDataOfficerHasPerson(cfg, info)
	self:showHelp(false)
	self:setReddot(false)
	if self.forceBig or cfg.pos <= 4 then
		self.controllers.c1:setSelectedIndex(2)
		local lordLocalData = include("lordLocalData")
		self.fields.Image_bust:setURL(lordLocalData.getBust(info.iconID))
	else
		self.controllers.c1:setSelectedIndex(0)
		self.fields.Com_head:setHeadSprite(info.iconID, info.avatar)
		self.fields.Com_head:setPlayerID(info.officerUid)
		self.fields.Com_head:setKid(info.officerKid)
	end
	self.fields.txtPlayerName:setString(_G.textParser.formatPlayerName(info.allianceAbbr, info.nickName, info.officerKid))
end
function Com_team:onClick()
	if self.isClickHelp then
		self.isClickHelp = false
		return
	end
	SoraDPlaySound()
	if not self.cfg then
		return
	end
	local panel = SoraDCreatePanel("NebulaOfflcerDetailPop")
	panel:init(self.cfg, self.info)
	panel:show()
end
function Com_team:onClickBtnHelp(...)
	self.isClickHelp = true
	SoraDPlaySound()
	local des = nebulaPrivilegelRead.getOfficialDes(self.cfg.officerID)
	SoraDShowHelpMsgTip(des)
end
function Com_team:showHelp(show)
	self.fields.Text_help:setVisible(show)
	self.fields.Button_help:setVisible(show)
	if show and not self.isInitShow then
		self.isInitShow = true
		local Text_help = self.fields.Text_help
		local Button_help = self.fields.Button_help
		Text_help:fixPos()
		Button_help:fixPos()
		Text_help:setString(i18n("nebula_war_text_0484"))
		local textWidth = fguiHelper.setTextWidthHeight(Text_help, cc.size(160, 52))
		Button_help:addClickListener(handler(self, self.onClickBtnHelp))
	end
end
return Com_team
