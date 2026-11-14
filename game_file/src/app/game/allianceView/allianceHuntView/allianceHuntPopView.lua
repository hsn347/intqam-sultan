local gametop = gModuleMgr.getObject("gametop")
local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
local allianceHuntDesRead = include("allianceHuntDesRead")
_ENV = "allianceHuntDesRead"
;("allianceHuntDesRead").colorRed = cc.c3b(190, 40, 40)
;("allianceHuntDesRead").colorGreen = cc.c3b(0, 190, 30)
local ("allianceHuntDesRead").colorYellow, _defaultParam = cc.c3b(255, 200, 100), "allianceHuntDesRead"
local allianceHuntPopView = class("allianceHuntPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("allianceHuntPopView")
	end
	return target
end)
_ENV = "allianceHuntPopView"
;("allianceHuntPopView").win = 1
allianceHuntPopView.popStyle, ("allianceHuntPopView").lost = "allianceHuntPopView", 2
function allianceHuntPopView:ctor()
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.btn_confirm = SoraDGetChildByName(self, "btn_confirm")
	self.Text_Result = SoraDGetChildByName(self, "Text_Result")
	self.Text_Total = SoraDGetChildByName(self, "Text_Total")
	self.Text_Kill_Score = SoraDGetChildByName(self, "Text_kill_Score")
	self.node_explose = SoraDGetChildByName(self, "node_explose")
	self.enableTouchCloseSelf = true
	self.baseClose = self.close
	self.close = self.onClose
	self:setCloseCallBack(handler(self, self.onClose))
	self.btn_confirm:setTitleText(i18n("common_text_204"))
	self.btn_confirm:addTouchEventListener(handler(self, self.goBack))
	self.nodeTargetHead = SoraDGetChildByName(self, "Node_target_head")
	self.nodeSelfHead = SoraDGetChildByName(self, "Node_self_head")
	self.iconTargetHead = SoraDGetChildByName(self, "icon_target_head")
	self.txtTargetScore = SoraDGetChildByName(self, "txt_target_score")
	self.txtTargetName = SoraDGetChildByName(self, "txt_target_name")
	self.iconSelfHead = SoraDGetChildByName(self, "icon_self_head")
	self.txtSelfScore = SoraDGetChildByName(self, "txt_self_score")
	self.txtSelfName = SoraDGetChildByName(self, "txt_self_name")
	self.nodeFightEffect = SoraDGetChildByName(self, "Node_fight_effect")
	SoraDChangeTextToHtml(self.txtSelfScore)
	SoraDChangeTextToHtml(self.txtTargetScore)
	SoraDChangeTextToHtml(self.Text_Total)
	self.txtSelfScore:setTextColor(cc.c3b(182, 182, 182))
	self.txtSelfScore:setColor(cc.c3b(255, 255, 255))
	self.txtTargetScore:setTextColor(cc.c3b(182, 182, 182))
	self.txtTargetScore:setColor(cc.c3b(255, 255, 255))
end
function allianceHuntPopView:createUI()
end
function allianceHuntPopView:init(data)
	self.curScore = data.score
	self.multipleTimes = data.multipleTimes
	self.challengePoint = data.challengePoint
	self.uinfoSelf = data.uinfoSelf
	self.uinfoTarget = data.uinfoTarget
	self.isTargetRobot = data.isTargetRobot
	local popStyle = data.popStyle
	local animNode
	if popStyle == allianceHuntPopView.popStyle.win then
		animNode = SoraDCreatAnimation("animationAllianceHuntWin", nil, false)
		SoraDPlaySound("huntSound", "hunt_win")
	else
		animNode = SoraDCreatAnimation("animationAllianceHuntLose", nil, false)
		SoraDPlaySound("huntSound", "hunt_lost")
		self.node_explose:setVisible(false)
	end
	animNode:addTo(self.Center_Node)
	animNode:setPosition(cc.p(0, 180))
	self.Text_Result:setString(self.curScore > self.challengePoint and i18n("alliance_hunt_text_28") or i18n("alliance_hunt_text_29"))
	local numColor = cc.c3b(255, 255, 255)
	allianceHuntPopView = 255
	allianceHuntPopView, allianceHuntPopView, (255).num = self.challengePoint, math.floor(self.challengePoint), math.floor(self.challengePoint)
	math.floor(self.challengePoint).num, self.challengePoint.color = self.challengePoint, numColor
	local strChallengePoint = i18n_html("alliance_hunt_text_35", 255, (math.floor(self.challengePoint)))
	self.txtTargetScore:setString(strChallengePoint)
	allianceHuntPopView = strChallengePoint
	allianceHuntPopView, allianceHuntPopView, strChallengePoint.num = self.curScore, math.floor(self.curScore), math.floor(self.curScore)
	math.floor(self.curScore).num, self.curScore.color = self.curScore, numColor
	local strScore = i18n_html("alliance_hunt_text_35", strChallengePoint, (math.floor(self.curScore)))
	self.txtSelfScore:setString(strScore)
	allianceHuntPopView = cc.p(0, 180)
	allianceHuntPopView, allianceHuntPopView, cc.p(0, 180).num = self.curScore * self.multipleTimes, math.floor(self.curScore * self.multipleTimes), math.floor(self.curScore * self.multipleTimes)
	math.floor(self.curScore * self.multipleTimes).num, (self.curScore * self.multipleTimes).color = self.curScore * self.multipleTimes, numColor
	self.Text_Total:setString(i18n_html("alliance_text_39", cc.p(0, 180)))
	self.txtSelfName:setString(self.uinfoSelf.nickName)
	SoraDGetHeadFromManager(self.iconSelfHead, self.uinfoSelf.iconID, self.uinfoSelf.avatar)
	if self.isTargetRobot then
		self.txtTargetName:setString(i18n(allianceHuntDesRead.robotConfig[1].Name))
		self.iconTargetHead:setSpriteFrame(allianceHuntDesRead.robotConfig[1].Head)
	else
		self.txtTargetName:setString(self.uinfoTarget.nickName)
		SoraDGetHeadFromManager(self.iconTargetHead, self.uinfoTarget.iconID, self.uinfoTarget.avatar)
	end
	local fightNode = SoraDGetFightingEffect()
	fightNode:setName("effect_fight")
	fightNode:setScale(1.0)
	fightNode:setPosition(0, -55)
	fightNode:addTo(self.nodeFightEffect)
end
function allianceHuntPopView:onMessageListener()
end
function allianceHuntPopView:onClose()
end
function allianceHuntPopView:goBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:closePanel()
		_ENV = self
		self.msg = "MESSAGE_ALLIANCE_HUNT_CLOSE_BATTLE"
		SoraDSendMessage(self)
	end
end
return allianceHuntPopView
