local gametop = gModuleMgr.getObject("gametop")
local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_challenge = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Com_challenge", Com_challenge)
function Com_challenge:onInit()
	self.fields.Ani_lineUp:setAllFrameName("dh_Tex_XL_xznd01_%.3d.png", 0)
	self.fields.Ani_lineUp:setPlaySettings(0, -1, 1)
	self.fields.Ani_lineUp_L:setAllFrameName("dh_Tex_XL_xznd01_%.3d.png", 0)
	self.fields.Ani_lineUp_L:setPlaySettings(0, -1, 1)
	self.fields.Ani_dunUp:setAllFrameName("dh_Tex_XL_xznd03_%.3d.png", 0)
	self.fields.Ani_dunUp:setPlaySettings(0, -1, 1, -1, handler(self, self.showOnAni))
	self.fields.Ani_dunUp_ten:setAllFrameName("dh_Tex_XL_xznd05_%.3d.png", 0)
	self.fields.Ani_dunUp_ten:setPlaySettings(0, -1, 1, -1, handler(self, self.showOnAni))
	self.fields.Ani_lineOn:setAllFrameName("dh_Tex_XL_xznd02_%.3d.png", 16)
	self.fields.Ani_dunOn:setAllFrameName("dh_Tex_XL_xznd04_%.3d.png", 16)
	self.fields.Ani_dunOn_ten:setAllFrameName("dh_Tex_XL_xznd06_%.3d.png", 16)
	self:addClickListener(handler(self, self.onClickBtn))
end
function Com_challenge:showOnAni()
	self.fields.num:setGrayed(false)
	self.fields.Node_normal:setVisible(false)
	self.fields.Ani_dunUp_ten:setVisible(false)
	self.fields.Ani_dunUp:setVisible(false)
	self.fields.Ani_lineUp_L:setVisible(false)
	self.fields.Ani_lineUp:setVisible(false)
	local tenFlag = self.data.levelD == 10 and true or false
	local enable = self.data.enableD
	self.fields.Ani_dunOn_ten:setVisible(enable and tenFlag)
	self.fields.Ani_dunOn:setVisible(enable and not tenFlag)
	if self.data.left then
		self.fields.Ani_lineOn_L:setVisible(enable)
	else
		self.fields.Ani_lineOn:setVisible(enable)
	end
end
function Com_challenge:initData(level, enable, btnInfo, limitLevel)
	self:setTag(level)
	self.fields.num:setURL("frame_llzh_nandu" .. level .. ".png")
	self:setTouchEnabled(enable)
	_ENV = self.setTouchEnabled
	self.setTouchEnabled.levelD = level
	self.setTouchEnabled.enableD = enable
	self.setTouchEnabled.btnInfoD = btnInfo
	self.setTouchEnabled.newFlagD = false
	self.setTouchEnabled.limitLevelD = limitLevel
	self.setTouchEnabled.tenFlagD = level == 10
	self.setTouchEnabled.leftD = level % 2 == 0 and true or false
	self.data, self.setTouchEnabled.levelEqualD = self.setTouchEnabled, limitLevel == level
	self.fields.num:setGrayed(not enable)
	if enable then
	else
		self.fields.Node_normal:setVisible(true)
	end
	if 3 < level and limitLevel == level and self:checkNeedRemindOnce(gActivityCenterUIEnum.ROME_ACTIVITY) then
		self.fields.Node_normal:setVisible(true)
		local phase = romeActivityCtrl:getActNthPhase()
		self:addRemindToManager(phase)
		self.firstTime = self:checkNeedRemindOnce2(level) and true or false
	else
		self.firstTime = false
	end
	local showUp = limitLevel == level and self.firstTime
	self.showUp = showUp
	if showUp then
		self.fields.num:setGrayed(showUp)
	end
	if level == 10 then
		self.fields.Ani_dunOn_ten:setVisible(enable and not showUp)
	else
		self.fields.Ani_dunOn:setVisible(enable and not showUp)
	end
	if level == 1 then
		return
	end
	local flag = level % 2 == 0 and true or false
	if flag then
		self.data.left = true
		self.fields.normal_line_L:setVisible(not enable or showUp)
		self.fields.Ani_lineOn_L:setVisible(enable and not showUp)
	else
		self.data.left = false
		self.fields.normal_line_R:setVisible(not enable or showUp)
		self.fields.Ani_lineOn:setVisible(enable and not showUp)
	end
end
function Com_challenge:addRemindToManager(value)
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:romanChallengeSelectedView:index~integer", value, nil)
end
function Com_challenge:checkNeedRemindOnce(activityID)
	local phase = romeActivityCtrl:getActNthPhase()
	romeActivityCtrl = nil
	;(nil).byUID = true
	local lastPhase = SoraDConfigGet("Game:romanChallengeSelectedView:index~integer", nil) or -1
	if lastPhase == -1 or phase ~= lastPhase then
		return true
	else
		return false
	end
end
function Com_challenge:showUpAni()
	if self.showUp and self.data.limitLevelD > 3 and self.data.levelEqualD and self:checkNeedRemindOnce2(self.data.levelD) then
		local phase = romeActivityCtrl:getActNthPhase()
		self:addRemindToManager2(self.data.levelD, phase)
		if self.data.leftD then
			self:setLineInVisible()
			if self.data.tenFlagD then
				self.transitions.ten_up_L:play()
			else
				self.transitions.line_up_L:play()
			end
		elseif self.data.tenFlagD then
			self.transitions.ten_up_R:play()
		else
			self.transitions.line_up_R:play()
		end
	end
end
function Com_challenge:setLineInVisible()
	self.fields.normal_line_L:setVisible(false)
	self.fields.normal_line_R:setVisible(false)
end
function Com_challenge:addRemindToManager2(key, value)
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:romanChallengeSelectedView:effectLevelFirst~table", nil) then
		local _ENV, list = SoraDConfigGet("Game:romanChallengeSelectedView:effectLevelFirst~table", nil), SoraDConfigGet("Game:romanChallengeSelectedView:effectLevelFirst~table", nil)
	end
	list[tostring(key)] = romeActivityCtrl:getActNthPhase()
	_ENV = nil
	;(nil).byUID = true
	SoraDConfigSet("Game:romanChallengeSelectedView:effectLevelFirst~table", list, nil)
end
function Com_challenge:checkNeedRemindOnce2(key)
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:romanChallengeSelectedView:effectLevelFirst~table", nil) then
		local _ENV, list = SoraDConfigGet("Game:romanChallengeSelectedView:effectLevelFirst~table", nil), SoraDConfigGet("Game:romanChallengeSelectedView:effectLevelFirst~table", nil)
	end
	if table.nums(list) == 0 or list[tostring(key)] == nil or list[tostring(key)] < -1 then
		return true
	else
		return false
	end
end
function Com_challenge:onClickBtn()
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
function Com_challenge:onShow()
end
return Com_challenge
