local nebulaPrivilegeCtrl = SoraDGetCtrl("nebulaPrivilegeCtrl")
local nebulaPrivilegelRead = include("nebulaPrivilegelRead")
local nebulaWarUtil = include("nebulaWarUtil")
local nebulaWarRead = include("nebulaWarRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_settleInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://NebulaWarNew/Com_settleInfo", Com_settleInfo)
function Com_settleInfo:onInit()
	self.fields.Button_officer:setString(i18n("activity_name_9001430"))
	self.fields.Button_officer:addClickListener(handler(self, self.onClickBtnOfficer))
end
function Com_settleInfo:onShow()
end
function Com_settleInfo:onClickBtnOfficer(...)
	SoraDPlaySound()
	clientEventMgr.singleClickEvent(gActivityTimeActivityID.NEBULA_PRIVILEGE)
end
function Com_settleInfo:initView(...)
	local round = nebulaPrivilegeCtrl:getRound()
	local officers = nebulaPrivilegelRead.getOfficers(round)
	local selfReginId = nebulaWarUtil.getRegionId()
	if nebulaWarRead.checkCampType1(selfReginId) then
		self.controllers.c1:setSelectedIndex(1)
		for _, cfg in ipairs(officers) do
			local pos = nebulaPrivilegelRead.getOfficialPos(cfg.officerID)
			if pos == 1 then
				local Com_settle = self.fields.Com_settle8
				if Com_settle then
					self:updateDataOfficer(Com_settle, cfg)
				end
			end
		end
	else
		self.controllers.c1:setSelectedIndex(0)
		for _, cfg in ipairs(officers) do
			local pos = nebulaPrivilegelRead.getOfficialPos(cfg.officerID)
			local Com_settle = self.fields["Com_settle" .. pos]
			if Com_settle then
				self:updateDataOfficer(Com_settle, cfg)
			end
		end
	end
end
function Com_settleInfo:updateDataOfficer(obj, cfg)
	local c1 = obj:getController("c1")
	local _fields = obj._fields
	if not _fields then
		_fields = fguiHelper.get_fields(obj)
		obj._fields = _fields
		_fields.Image_bust:addClickListener(handler(self, self.onClickImageBust))
		_fields.Button_help:addClickListener(handler(self, self.onClickBtnHelp))
		_fields.Text_help:setString(i18n("nebula_war_text_0484"))
		fguiHelper.setTextWidthHeight(_fields.Text_help, cc.size(190, 56))
		if not SoraDFIsRA() then
			_fields.Text_help:fixPos()
			_fields.Button_help:fixPos()
		end
	end
	local info = nebulaPrivilegeCtrl:getOfficer(cfg.officerID)
	if info then
		c1:setSelectedIndex(1)
		local lordLocalData = include("lordLocalData")
		_fields.Image_bust:setURL(lordLocalData.getPortrait(info.iconID))
		_fields.Image_bust:setTag(cfg.officerID)
		local playerName = _G.textParser.formatPlayerName(info.allianceAbbr, info.nickName, info.officerKid)
		_fields.Text_player:setString(playerName)
		local groupId = nebulaWarUtil.getGroupIdByKid(info.officerKid)
		local abbr = nebulaWarRead.getWarGroupAbbr(groupId)
		local name = nebulaWarRead.getWarGroupName(groupId)
		_ENV = lordLocalData.getPortrait(info.iconID)
		lordLocalData.getPortrait(info.iconID).abbr = abbr
		lordLocalData.getPortrait(info.iconID).name = name
		_fields.Text_group:setString(i18n("common_text_186", lordLocalData.getPortrait(info.iconID)))
	else
		c1:setSelectedIndex(0)
	end
	_fields.Text_officer:setString(i18n(nebulaPrivilegelRead.getOfficialName(cfg.officerID)))
	_fields.Image_officer:setURL(nebulaPrivilegelRead.getOfficialImg2(cfg.officerID))
	local pos = nebulaPrivilegelRead.getOfficialPos(cfg.officerID)
	if 4 <= pos then
		_fields.Text_rank:setString(pos)
	end
end
function Com_settleInfo:onClickImageBust(EventContext)
	SoraDPlaySound()
	local officerID = EventContext:getSender():getTag()
	local info = nebulaPrivilegeCtrl:getOfficer(officerID)
	if info then
		_ENV = officerID
		officerID.msg = "MESSAGE_CHAT_REQUEST_LORD_INFO"
		officerID.playerID = info.officerUid
		officerID.kid = info.officerKid
		SoraDSendMessage(officerID)
	end
end
function Com_settleInfo:onClickBtnHelp(...)
	SoraDPlaySound()
	SoraDShowHelpMsgTip(i18n("nebula_war_text_0506"))
end
return Com_settleInfo
