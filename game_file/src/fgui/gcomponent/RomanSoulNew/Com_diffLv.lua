local baseComponent = require("fgui.base.baseComponent")
local Com_diffLv = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Com_diffLv", Com_diffLv)
function Com_diffLv:onInit()
	self:addClickListener(handler(self, self.onClickBtn))
end
function Com_diffLv:initData(level, enable, btnInfo)
	self:setTag(level)
	self.fields.num:setURL("day" .. level .. ".png")
	self.fields.bg:setURL("btn_Roman_difficulty_lock.png")
	if enable then
		self:setTouchEnabled(true)
		self.fields.num:setVisible(true)
		self.fields.lock:setVisible(false)
	else
		self:setTouchEnabled(false)
		self.fields.num:setVisible(false)
		self.fields.lock:setVisible(true)
		self.fields.lock:setURL("icon_Roman_difficulty_lock.png")
	end
end
function Com_diffLv:onClickBtn()
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("common_text_1505"), i18n("common_text_054"), nil, function(type)
		if MSGBOX_CALLBACK_YES == type then
			SoraDPlaySound()
			local condition = false
			local gametop = gModuleMgr.getObject("gametop")
			local allianceMgr = gametop.playertop_:getModule("allianceMgr")
			if allianceMgr:hasJoinAlliance() then
				local memberMgr = gametop.playertop_:getModule("memberMgr")
				local ownmember = memberMgr:getOwnMember()
				local ownRank = ownmember:getProperty("rank")
				if ownRank > RANK_TOP_SPECIAL then
					condition = true
				end
			end
			if condition then
				local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
				romeActivityCtrl:reqOpenActivity(self:getTag())
			else
				SoraDShowMsgTip(i18n("common_text_1501"))
			end
		end
	end)
end
function Com_diffLv:onShow()
end
return Com_diffLv
