local gametop = gModuleMgr.getObject("gametop")
local activity_9001594_Ctrl = SoraDGetCtrl("activity_9001594_Ctrl")
local activity_9001594_Read = include("activity_9001594_Read")
local constantRead = include("constantRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local Activity_9001594_MembersPanel = class("Activity_9001594_MembersPanel", baseFguiPanel)
function Activity_9001594_MembersPanel:ctor(...)
	Activity_9001594_MembersPanel.super.ctor(self, ...)
	print("Activity_9001594_MembersPanel:ctor", self.viewName)
	self.listData, Activity_9001594_MembersPanel, self.memebers, Activity_9001594_MembersPanel = print, print, print, print
	self.limit = constantRead.getConstValue("DATE_PALM_ACCEPPT_HELP_NUM", 2)
	self.selfUid = gametop.playertop_:getPlayerID()
end
function Activity_9001594_MembersPanel:onInit()
	print("=======Activity_9001594_MembersPanel:onInit")
	self.fields.Panel_bg:setString(i18n("datepalm_tree_text24"))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.Text_tip:setString(i18n("datepalm_tree_text58"))
	self.input = self.fields.input:getChild("input")
	self.input:setPromptHolder(i18n("bubble_farm_text18"))
	self.fields.Btn_search:setString(i18n("common_text_166"))
	self.fields.Btn_search:addClickListener(handler(self, self.btnSearchClick))
	self.fields.input:fixPos()
	self.fields.Btn_search:fixPos()
end
function Activity_9001594_MembersPanel:onShow()
	print("=======Activity_9001594_MembersPanel:onShow")
	self.fields.Com_own:setVisible(false)
	self:updateTextAssist()
	activity_9001594_Ctrl:reqMembers()
end
function Activity_9001594_MembersPanel:onItemRenderer(index, obj)
	local member = self.listData[index + 1]
	self:updateMemberSingle(obj, member)
end
function Activity_9001594_MembersPanel:updateMemberSingle(obj, member)
	local _fields = obj._fields
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		_fields = obj._fields
		_fields.Button_go:addClickListener(handler(self, self.onClickBtnGo))
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
	end
	_ENV = handler(self, self.onClickBtnGo)
	handler(self, self.onClickBtnGo).rank = member.rank
	handler(self, self.onClickBtnGo).isOwnRank = obj == self.fields.Com_own
	_fields.Com_rankBase:initRankBaseData(handler(self, self.onClickBtnGo))
	_fields.Com_head:setHeadSprite(member.iconID, member.avatar)
	_fields.Com_head:setAvatarFrame(member.avatarFrameId)
	local growthValue = activity_9001594_Ctrl:getGrowthValue(member)
	local curLv = activity_9001594_Read.getLevelByExp(growthValue)
	_fields.Text_lv:setString("Lv." .. curLv)
	if obj ~= self.fields.Com_own then
		_fields.Text_name:setString(member.nickName)
	end
	local times = activity_9001594_Ctrl:getBeAssistanceTimes(member)
	local remain = math.max(0, self.limit - times)
	_ENV = handler(self, self.onClickBtnGo)
	handler(self, self.onClickBtnGo).num = remain
	handler(self, self.onClickBtnGo).maxnum = self.limit
	_fields.Text_spread:setString(i18n("datepalm_tree_text63", handler(self, self.onClickBtnGo)))
	local ret = activity_9001594_Ctrl:checkCanAssist(member)
	if ret then
		_fields.Text_spread:setColor(cc.c3b(0, 255, 0))
	else
		_fields.Text_spread:setColor(cc.c3b(117, 117, 117))
		if member.uid ~= self.selfUid then
			_fields.Button_go:setGrayed(true)
		end
	end
	if member.uid == self.selfUid then
		_fields.Button_go:setString(i18n("soldier_rush_skill_name_5"))
	else
		_fields.Button_go:setString(i18n("datepalm_tree_text25"))
	end
	_fields.Button_go.rank = member.rank
	local btnVisible = member.uid ~= self.selfUid or self.fields.Com_own == obj
	_fields.Button_go:setVisible(btnVisible)
	if btnVisible then
		_fields.Text_spread:setPositionY(8)
	else
		_fields.Text_spread:setPositionY(40)
	end
end
function Activity_9001594_MembersPanel:onClickBtnGo(EventContext)
	SoraDPlaySound()
	local sender = EventContext:getSender()
	local rank = sender.rank
	local member = self.memebers[rank]
	if member.uid == self.selfUid then
		_ENV = self.selfUid
		self.selfUid.msg = "MESSAGE_ACTIVITY_9001594_UPDATE"
		self.selfUid.key = "backHome"
		SoraDSendMessage(self.selfUid)
		self:closePanel()
	else
		SoraDShowLoading(self)
		activity_9001594_Ctrl:reqMembers(member.uid)
	end
end
function Activity_9001594_MembersPanel:onMsgUpdateData(target, event)
	local key = event.key
	if key == "members" then
		SoraDCloseLoading(self)
		self.memebers = event.memebers
		for i, v in ipairs(self.memebers) do
			v.rank = i
		end
		self.listData = self.memebers
		self.fields.List:setNumItems(#self.listData)
		for i, member in pairs(self.memebers) do
			if member.uid == self.selfUid then
				self.fields.Com_own:setVisible(true)
				self:updateMemberSingle(self.fields.Com_own, member)
				break
			end
		end
	elseif key == "member" then
		if event.err == gErrDef.Err_None then
			_ENV = gErrDef.Err_None
			gErrDef.Err_None.msg = "MESSAGE_ACTIVITY_9001594_UPDATE"
			gErrDef.Err_None.key = "gotoOther"
			gErrDef.Err_None.member = event.member
			SoraDSendMessage(gErrDef.Err_None)
			self:closePanel()
		else
			SoraDCloseLoading(self)
		end
	end
end
function Activity_9001594_MembersPanel:updateTextAssist(...)
	local remain = activity_9001594_Ctrl:getRemainAssistanceTimes()
	local countStr = tonumber(remain)
	if 0 < remain then
		activity_9001594_Ctrl = nil
		;(nil).color = "#00ff00"
		countStr = SoraDWrapHtmlTagByStyle(countStr, nil)
	end
	local Text_name = self.fields.Com_own:getChild("Text_name")
	Text_name:setIsHtml(true)
	activity_9001594_Ctrl = nil
	;(nil).num = countStr
	Text_name:setString(i18n("datepalm_tree_text64", nil))
end
function Activity_9001594_MembersPanel:btnSearchClick()
	SoraDPlaySound()
	local name = self.input:getText()
	if string.len(name) <= 0 then
		SoraDShowMsgTip(i18n("bubble_farm_text18"))
		return
	end
	local _ENV, ret = SoraDShowMsgTip, SoraDShowMsgTip
	for k, v in ipairs(self.memebers) do
		if string.match(v.nickName, name) then
			table.insert(ret, v)
		end
	end
	self.listData = ret
	if 0 < #self.listData then
		self.fields.List:setNumItems(#self.listData)
	else
		SoraDShowMsgTip(i18n("datepalm_tree_text61"))
	end
end
return Activity_9001594_MembersPanel
