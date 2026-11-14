local nebulaEmperorRead = include("nebulaEmperorRead")
local nebulaEmperorCtrl = SoraDGetCtrl("nebulaEmperorCtrl")
local nebulaWarRead = include("nebulaWarRead")
local nebulaEmperorUtil = include("nebulaEmperorUtil")
local baseComponent = require("fgui.base.baseComponent")
local Com_officer = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://NebulaEmperorOfficer/Com_officer", Com_officer)
fgui.register_extension("ui://NebulaEmperorOfficer/Com_officer_1", Com_officer)
fgui.register_extension("ui://NebulaEmperorOfficer/Com_officer_2", Com_officer)
fgui.register_extension("ui://NebulaEmperorOfficer/Com_officer_title", Com_officer)
function Com_officer:onInit()
	self:addClickListener(handler(self, self.onClick))
	if self.fields.Text_help then
		self.fields.Text_help:setString(i18n("nebula_war_text_0484"))
	end
end
function Com_officer:onShow()
end
function Com_officer:updateDataOfficer(officerID, titleInfo)
	self.officerID = officerID
	local cfg = nebulaEmperorRead.getOfficerConfig(officerID)
	self.cfg = cfg
	self.limitList = titleInfo
	local info = titleInfo and titleInfo[tostring(officerID)]
	self.info = info
	if info then
		self:updateDataOfficerHasPerson(cfg, info)
	else
		self:updateDataOfficerNoPerson(cfg)
	end
	self:setString(i18n(cfg.name))
end
function Com_officer:updateDataOfficerNoPerson(cfg)
	self.controllers.c1:setSelectedIndex(0)
	self.fields.icon:setURL(cfg.img2)
end
function Com_officer:updateDataOfficerHasPerson(cfg, info)
	self.controllers.c1:setSelectedIndex(1)
	if cfg.buffType == gLegendBuffType.KINGDOM then
		self:checkSetSelectedIndex(self.controllers.c2, 0)
		local regionId = info
		self.fields.Load_flag:setURL(nebulaEmperorUtil.getAreaIcon(regionId))
		self.fields.Text_name:setString(nebulaEmperorUtil.getAreaName(regionId))
	else
		self:checkSetSelectedIndex(self.controllers.c2, 1)
		if cfg.pos <= 3 then
			local lordLocalData = include("lordLocalData")
			self.fields.Image_bust:setURL(lordLocalData.getBust(info.iconID))
		else
			self.fields.Com_head:setHeadSprite(info.iconID, info.avatar)
			self.fields.Com_head:setPlayerID(info.uid)
			self.fields.Com_head:setKid(info.kid)
		end
		local abbr = nebulaWarRead.getAreaAbbr(info.regionId)
		self.fields.Text_name:setString(_G.textParser.formatPlayerName(abbr, info.nickname, info.kid))
	end
end
function Com_officer:updateTitle(officerID)
	self.officerID = officerID
	local cfg = nebulaEmperorRead.getOfficerConfig(officerID)
	self.cfg = cfg
	self:setString(i18n(cfg.name))
	self.fields.icon:setURL(cfg.img2)
end
function Com_officer:onClick()
	SoraDPlaySound()
	if nebulaEmperorUtil.isWarTest() then
		SoraDShowMsgTip(i18n("nebulaemperor_text_238"))
		return
	end
	local panel = SoraDCreatePanel("NebulaOfflcerDetailPop")
	_ENV = i18n("nebulaemperor_text_238")
	i18n("nebulaemperor_text_238").warType = gKingdomClassType.nebulaEmperor
	i18n("nebulaemperor_text_238").officerID = self.officerID
	i18n("nebulaemperor_text_238").cfg = self.cfg
	i18n("nebulaemperor_text_238").limitList = self.limitList
	panel:init(i18n("nebulaemperor_text_238"))
	panel:show()
end
function Com_officer:checkSetSelectedIndex(controller, index)
	if controller then
		controller:setSelectedIndex(index)
	end
end
return Com_officer
