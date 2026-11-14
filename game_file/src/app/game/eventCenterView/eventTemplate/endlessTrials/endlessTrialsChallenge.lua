local gametop = gModuleMgr.getObject("gametop")
local kingdomMapCtrl = gametop.playertop_:getModule("kingdomMapCtrl")
local activityShowCtrl = SoraDGetCtrl("activityShowCtrl")
local endlessTrialsCtrl = SoraDGetCtrl("endlessTrialsCtrl")
local allianceMgr = SoraDGetCtrl("allianceMgr")
local endlessTrialsChallenge = class("endlessTrialsChallenge", function(target)
	if target == nil then
		return SoraDCreateBasePanel("endlessTrialsChallenge")
	end
	return target
end)
function endlessTrialsChallenge:ctor()
	self:initWidget()
	self:refreshData()
end
function endlessTrialsChallenge:onMessageListener(...)
	SoraDAddMessage(self, "MESSAGE_ENDLESSTRIALSVIEW_REFRESH", handler(self, self.refreshData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENT_COMMON_RED_POINT_REFRESH", handler(self, self.updateRedPoint))
	SoraDAddMessage(self, "MESSAGE_ENDLESSTRIALS_LEFT_TIME_REFRESH", handler(self, self.setLeftRewardTime), num)
end
function endlessTrialsChallenge:updateRedPoint(target, data)
	if data and data.eventID == gActivityTimeActivityID.ENDLESS_TRIALS_ACTIVITY then
		self:updateBtnGift()
	end
end
function endlessTrialsChallenge:initWidget(...)
	local root = self._ccsView
	endlessTrialsCtrl = nil
	;(nil)[1] = "Top_Node"
	self.Top_Node = SoraDGetChildByFullPath(root, nil)
	endlessTrialsCtrl = nil
	;(nil)[1] = "Node_time"
	self.Node_time = SoraDGetChildByFullPath(self.Top_Node, nil)
	endlessTrialsCtrl = nil
	;(nil)[1] = "Text_time"
	self.Text_time = SoraDGetChildByFullPath(self.Node_time, nil)
	self.Text_time = SoraDCreateTimerLabel(self, self.Text_time)
	self.Text_time:setTimeLast(function(time)
		_ENV = nil
		;(nil).time = time
		return i18n("common_text_607", nil)
	end)
	self.Text_time:beginTime(endlessTrialsCtrl:getActivityRemainTime())
	SoraDToCenter(self.Node_time, nil, SoraDFIsRA())
	endlessTrialsCtrl = nil
	;(nil)[1] = "Bottom_Node"
	self.Bottom_Node = SoraDGetChildByFullPath(root, nil)
	endlessTrialsCtrl = nil
	;(nil)[1] = "Node_content"
	self.Node_content = SoraDGetChildByFullPath(self.Bottom_Node, nil)
	endlessTrialsCtrl = nil
	;(nil)[1] = "Node_self"
	local Node_self = SoraDGetChildByFullPath(self.Node_content, nil)
	endlessTrialsCtrl = "Node_self"
	;("Node_self")[1] = "Text_des"
	self.Text_des_self = SoraDGetChildByFullPath(Node_self, "Node_self")
	self.Text_des_self:setString(i18n("rides_title_01"))
	endlessTrialsCtrl = i18n("rides_title_01")
	i18n("rides_title_01")[1] = "Text_rank"
	self.Text_rank_self = SoraDGetChildByFullPath(Node_self, i18n("rides_title_01"))
	endlessTrialsCtrl = i18n("rides_title_01")
	i18n("rides_title_01")[1] = "Text_noSelf"
	self.Text_noSelf = SoraDGetChildByFullPath(Node_self, i18n("rides_title_01"))
	self.Text_noSelf:setString(i18n("herobattle_text_05"))
	endlessTrialsCtrl = i18n("herobattle_text_05")
	i18n("herobattle_text_05")[1] = "Node_alliance"
	local Node_alliance = SoraDGetChildByFullPath(self.Node_content, i18n("herobattle_text_05"))
	endlessTrialsCtrl = "Node_alliance"
	;("Node_alliance")[1] = "Text_des"
	self.Text_des_alli = SoraDGetChildByFullPath(Node_alliance, "Node_alliance")
	self.Text_des_alli:setString(i18n("rides_title_02"))
	endlessTrialsCtrl = i18n("rides_title_02")
	i18n("rides_title_02")[1] = "Text_rank"
	self.Text_rank_alli = SoraDGetChildByFullPath(Node_alliance, i18n("rides_title_02"))
	endlessTrialsCtrl = i18n("rides_title_02")
	i18n("rides_title_02")[1] = "Text_noAlliance"
	self.Text_noAlliance = SoraDGetChildByFullPath(Node_alliance, i18n("rides_title_02"))
	endlessTrialsCtrl = i18n("rides_title_02")
	i18n("rides_title_02")[1] = "Button_go"
	self.Button_go = SoraDGetChildByFullPath(self.Bottom_Node, i18n("rides_title_02"))
	self.Button_go:setTitleText(i18n("treasure_crystal_btn_01"))
	self.Button_go:addTouchEventListener(handler(self, self.btn_onClick_go))
	if G_IS_UNITY then
		local image = self.Button_go:getChild("frame_wjtz_anniuzhuangshi_34")
		if image then
			image:setVisible(false)
		end
	end
	self.Button_gift = SoraDGetChildByName(self, "Button_gift")
	self.Text_gift = SoraDGetChildByName(self, "Text_gift")
	self.Text_gift:setString(i18n("anniversary_fire_text_16"))
	self.Button_gift:addTouchEventListener(handler(self, self.onGiftClick))
	self.ccs_red = SoraDGetExtendChildFromCCSByName(self, "CCS_commonRedPoint_red")
	if SoraDFIsRA() then
		local pos1 = Node_self:getPositionX()
		Node_self:setPositionX(Node_alliance:getPositionX())
		Node_alliance:setPositionX(pos1)
	end
	SoraDCreatAnimation(self.__cname, self, true)
	local Node_effect = SoraDGetChildByName(Node_self, "Node_effect")
	SoraDMixtureGLONEByParent(Node_effect)
	local Node_effect = SoraDGetChildByName(Node_alliance, "Node_effect")
	SoraDMixtureGLONEByParent(Node_effect)
	local Node_Effect_up = SoraDGetChildByName(self, "Node_Effect_up")
	_UPVALUE2_ = "Node_Effect_up"
	;("Node_Effect_up")[1] = "et_Par_wjsljf_006"
	;("Node_Effect_up")[2] = "et_Par_wjsljf_003_02"
	for i, v in ipairs("Node_Effect_up") do
		SoraDGetChildByName(Node_Effect_up, v):setAutoCull(false)
	end
	_UPVALUE3_ = ipairs("Node_Effect_up")
	ipairs("Node_Effect_up")[1] = "ar"
	ipairs("Node_Effect_up")[2] = "en"
	ipairs("Node_Effect_up")[3] = "ko"
	local icon = SoraDGetImageNameByLang("frame_wjsl_slogan_%s.png", ipairs("Node_Effect_up"))
	SoraDGetChildByName(self, "Sprite_slogan"):setSpriteFrame(icon)
	local spine_m = sp.SkeletonAnimation:create("spine/xueguai.skel", "spine/xueguai.atlas", 1)
	spine_m:setAnimation(0, "animation", true)
	spine_m:setPosition(cc.p(0, 120))
	spine_m:addTo(self.Node_content, -1)
	self.spine_m = spine_m
	if display.height > 1300 then
		spine_m:setScale(1.2)
	end
	local scale = (display.height - 256) / 880
	scale = math.min(1.0, math.max(0.8, scale))
	self.Node_content:setScale(scale)
	local offset = display.height - 960 + 27
	offset = math.min(0, offset)
	self.Node_content:setPositionY(self.Node_content:getPositionY() + offset)
	self:addLeftRewardTimes(Node_self)
end
function endlessTrialsChallenge:initData(bType)
	endlessTrialsCtrl:reqRankData()
	endlessTrialsCtrl:reqGiftInfo()
end
function endlessTrialsChallenge:addLeftRewardTimes(Node_self)
	_UPVALUE1_ = nil
	;(nil)[1] = "Text_des"
	self.Text_leftAttack = SoraDGetChildByFullPath(Node_self, nil):clone()
	self.Text_leftAttack:setName("Text_attackLeftTime")
	self.Text_leftAttack:setFontSize(20)
	self.Text_leftAttack:addTo(self.Bottom_Node)
	self.Text_leftAttack:setPositionX(self.Button_go:getPositionX())
	self.Text_leftAttack:setPositionY(self.Button_go:getPositionY() + 50)
	self.Text_leftAttack = SoraDChangeTextToHtml(self.Text_leftAttack)
	local leftTime = self:getLeftTime()
	local color = 0 < leftTime and "#4CE61A" or "#FF0000"
	_ENV = self.Button_go:getPositionX()
	_ENV, _ENV, self.Button_go:getPositionX().num = self.Button_go:getPositionX()
	self.Button_go:getPositionX().num, self.Button_go:getPositionX().color = self.Button_go:getPositionX()
	local str = i18n_html("common_text_4590", self.Button_go:getPositionX())
	self.Text_leftAttack:setString(str)
end
function endlessTrialsChallenge:getLeftTime()
	local leftTime = endlessTrialsCtrl:getLeftAttackTimes()
	if leftTime then
		return 0 <= leftTime and leftTime or 0
	end
	local info = kingdomMapCtrl.kingdomMapCell:getBossRewardLeftTimes(gBossType.endlessTrialBoss1)
	local leftTime = info.maxAttackNum - info.attackNum
	return 0 <= leftTime and leftTime or 0
end
function endlessTrialsChallenge:setLeftRewardTime(target, data)
	local leftTime = data.num >= 0 and data.num or 0
	local color = 0 < leftTime and "#4CE61A" or "#FF0000"
	_ENV = nil
	_ENV, _ENV, (nil).num = nil, nil, leftTime
	;(nil).num, (nil).color = nil, color
	local str = i18n_html("common_text_4590", nil, nil)
	self.Text_leftAttack:setString(str)
end
function endlessTrialsChallenge:refreshData(...)
	SoraDCloseLoading(self)
	self.personalRank = endlessTrialsCtrl:getPersonalRank()
	if self.personalRank <= 0 or self.personalRank > 999 then
		self.Text_rank_self:setString(tostring(999) .. "+")
		self.Text_rank_self:setVisible(false)
		self.Text_noSelf:setVisible(true)
	else
		self.Text_rank_self:setString(tostring(self.personalRank))
		self.Text_rank_self:setVisible(true)
		self.Text_noSelf:setVisible(false)
	end
	local alliance = allianceMgr:getAlliance()
	if alliance ~= nil then
		self.allianceRank = endlessTrialsCtrl:getAllianceRank()
		if 0 >= self.allianceRank or self.allianceRank > 99 then
			self.Text_rank_alli:setString(tostring(99) .. "+")
			self.Text_rank_alli:setVisible(false)
			self.Text_noAlliance:setString(i18n("herobattle_text_05"))
			self.Text_noAlliance:setVisible(true)
		else
			self.Text_rank_alli:setString(tostring(self.allianceRank))
			self.Text_rank_alli:setVisible(true)
			self.Text_noAlliance:setVisible(false)
		end
	else
		self.Text_rank_alli:setVisible(false)
		self.Text_noAlliance:setString(i18n("pyramid_text_02"))
		self.Text_noAlliance:setVisible(true)
	end
	self:updateBtnGift()
end
function endlessTrialsChallenge:updateBtnGift()
	local count = endlessTrialsCtrl:getRewardCount()
	self.ccs_red:updateRedPoint(count)
end
function endlessTrialsChallenge:btn_onClick_go(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("endlessTrialsBossList"):show()
	end
end
function endlessTrialsChallenge:onGiftClick(button, eventType)
	if eventType == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local count = endlessTrialsCtrl:getRewardCount()
		if 0 < count then
			SoraDShowLoading(self)
			endlessTrialsCtrl:reqGiftReward()
		else
			SoraDShowMsgTip(i18n("alliancerewards_text_02"))
		end
	end
end
return endlessTrialsChallenge
