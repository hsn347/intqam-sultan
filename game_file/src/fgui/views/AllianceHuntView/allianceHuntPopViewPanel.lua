local gametop = gModuleMgr.getObject("gametop")
local allianceHuntCtrl = gametop.playertop_:getModule("allianceHuntCtrl")
local allianceHuntDesRead = include("allianceHuntDesRead")
_ENV = "allianceHuntDesRead"
;("allianceHuntDesRead").colorRed = cc.c3b(190, 40, 40)
;("allianceHuntDesRead").colorGreen = cc.c3b(0, 190, 30)
local ("allianceHuntDesRead").colorYellow, _defaultParam = cc.c3b(255, 200, 100), "allianceHuntDesRead"
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local allianceHuntPopViewPanel = class("allianceHuntPopViewPanel", baseFguiPanel)
_ENV = "allianceHuntPopViewPanel"
;("allianceHuntPopViewPanel").win = 1
allianceHuntPopViewPanel.popStyle, ("allianceHuntPopViewPanel").lost = "allianceHuntPopViewPanel", 2
function allianceHuntPopViewPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("allianceHuntPopViewPanel:ctor", self.viewName)
end
function allianceHuntPopViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function allianceHuntPopViewPanel:onInit()
	print("=======allianceHuntPopViewPanel:onInit")
	self.Center_Node = SoraDGetChildByName(self, "Center_Node")
	self.btn_confirm = SoraDGetChildByName(self, "btn_confirm")
	self.Text_Result = SoraDGetChildByName(self, "Text_Result")
	self.Text_Total = SoraDGetChildByName(self, "Text_Total")
	self.Text_Kill_Score = SoraDGetChildByName(self, "Text_kill_Score")
	self.enableTouchCloseSelf = true
	self.baseClose = self.close
	self.close = self.onClose
	self.btn_confirm:setTitleText(i18n("common_text_204"))
	self.btn_confirm:addClickEventListener(handler(self, self.goBack))
	self.nodeTargetHead = SoraDGetChildByName(self, "Node_target_head")
	self.nodeSelfHead = SoraDGetChildByName(self, "Node_self_head")
	self.iconTargetHead = SoraDGetChildByName(self, "icon_target_head")
	self.txtTargetScore = SoraDGetChildByName(self, "txt_target_score")
	self.txtTargetName = SoraDGetChildByName(self, "txt_target_name")
	self.iconSelfHead = SoraDGetChildByName(self, "icon_self_head")
	self.txtSelfScore = SoraDGetChildByName(self, "txt_self_score")
	self.txtSelfName = SoraDGetChildByName(self, "txt_self_name")
	self.nodeFightEffect = SoraDGetChildByName(self, "Node_fight_effect")
	if not SoraDFIsRA() then
		self.iconTargetHead:fixPos()
		self.txtTargetScore:fixPos()
		self.txtTargetName:fixPos()
		self.iconSelfHead:fixPos()
		self.txtSelfScore:fixPos()
		self.txtSelfName:fixPos()
		self.fields.Image_victory:setURL("frame_DrillGrounds_shengli04.png")
		self.fields.Image_lose:setURL("frame_DrillGrounds_shibai04.png")
	end
end
function allianceHuntPopViewPanel:onShow()
	print("=======allianceHuntPopViewPanel:onShow")
end
function allianceHuntPopViewPanel:init(data)
	self.curScore = data.score
	self.multipleTimes = data.multipleTimes
	self.challengePoint = data.challengePoint
	self.uinfoSelf = data.uinfoSelf
	self.uinfoTarget = data.uinfoTarget
	self.isTargetRobot = data.isTargetRobot
	local popStyle = data.popStyle
	local animNode
	if popStyle == allianceHuntPopViewPanel.popStyle.win then
		self.controllers.c1:setSelectedIndex(0)
		self.fields.icon_target_head:setGrayed(true)
		self.fields.Usm_victory:setVisible(true)
		self.fields.Image_victory:setVisible(true)
		SoraDPlaySound("huntSound", "hunt_win")
	else
		self.controllers.c1:setSelectedIndex(1)
		self.fields.icon_self_head:setGrayed(true)
		self.fields.Usm_lose:setVisible(true)
		self.fields.Image_lose:setVisible(true)
		SoraDPlaySound("huntSound", "hunt_lost")
	end
	self.fields.Group:setVisible(true)
	self.transitions.t0:play()
	self.Text_Result:setString(self.curScore > self.challengePoint and i18n("alliance_hunt_text_28") or i18n("alliance_hunt_text_29"))
	local numColor = cc.c3b(255, 255, 255)
	allianceHuntPopViewPanel = 255
	;(255).num = math.floor(self.challengePoint)
	local strChallengePoint = i18n("alliance_hunt_text_35", 255)
	self.txtTargetScore:setString(strChallengePoint)
	allianceHuntPopViewPanel = strChallengePoint
	strChallengePoint.num = math.floor(self.curScore)
	local strScore = i18n("alliance_hunt_text_35", strChallengePoint)
	self.txtSelfScore:setString(strScore)
	allianceHuntPopViewPanel = nil
	;(nil).num = math.floor(self.curScore * self.multipleTimes)
	self.Text_Total:setString(i18n("alliance_text_39", nil))
	self.txtSelfName:setString(self.uinfoSelf.nickName)
	self.iconSelfHead:setHeadSprite(self.uinfoSelf.iconID, self.uinfoSelf.avatar)
	if self.isTargetRobot then
		self.txtTargetName:setString(i18n(allianceHuntDesRead.robotConfig[1].Name))
		self.iconTargetHead:setHeadSprite(allianceHuntDesRead.robotConfig[1].Head)
	else
		self.txtTargetName:setString(self.uinfoTarget.nickName)
		self.iconTargetHead:setHeadSprite(self.uinfoTarget.iconID, self.uinfoTarget.avatar)
	end
end
function allianceHuntPopViewPanel:onMessageListener()
end
function allianceHuntPopViewPanel:onClose()
end
function allianceHuntPopViewPanel:goBack(button, type)
	SoraDPlaySound()
	self:closePanel()
	_ENV = self
	self.msg = "MESSAGE_ALLIANCE_HUNT_CLOSE_BATTLE"
	SoraDSendMessage(self)
end
return allianceHuntPopViewPanel
