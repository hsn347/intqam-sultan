local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local epicBattleActionNode = class("epicBattleActionNode", function(target)
	if target == nil then
		return SoraDCreateBasePanel("epicBattleActionNode")
	end
	return target
end)
function epicBattleActionNode:ctor()
	self:setNodeEventEnabled(true)
	self.actSwitch = false
	self.Text_curAction = SoraDGetChildByName(self, "Text_curAction")
	self.Text_maxAction = SoraDGetChildByName(self, "Text_maxAction")
	self.Button_countPlus = SoraDGetChildByName(self, "Button_countPlus")
	self.Button_countPlus:addTouchEventListener(handler(self, self.btnPlusClick))
	self.updateTimer = SoradCreateTimer(self, handler(self, self.initData))
	self:initData()
end
function epicBattleActionNode:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EPICBATTLE_ACTION_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_UI_EPICBATTLE_ACTION_REDUCE", handler(self, self.showAction))
end
function epicBattleActionNode:initData()
	local curAction = epicWarCtrl:getCurExploreCount()
	local maxAction = epicWarCtrl:getMaxExploreCount()
	if self.Text_curAction then
		self.Text_curAction:setString(curAction)
		self.Text_curAction:setColor(0 < curAction and cc.c3b(255, 255, 255) or cc.c3b(190, 40, 40))
	end
	if self.Text_maxAction then
		self.Text_maxAction:setString("/" .. maxAction)
	end
end
function epicBattleActionNode:openSwitch()
	self.actSwitch = true
end
function epicBattleActionNode:showAction()
	if not self.actSwitch then
		return
	end
	_ENV = nil
	;(nil).text = "-1"
	;(nil).font = "res/fonts/pve_fnt_title.fnt"
	;(nil).align = cc.TEXT_ALIGNMENT_CENTER
	;(nil).x = self.Text_curAction:getPositionX() - 15
	;(nil).y = 0
	local actLabel = display.newBMFontLabel(nil)
	actLabel:addTo(self, 5)
	actLabel:sscale(0.5)
	_UPVALUE1_ = 5
	;(5)[1] = cca.moveTo(0.5, self.Text_curAction:getPositionX() - 15, -30)
	;(5)[2] = cca.fadeOut(0.5)
	;(5)[3] = cca.fadeOut(0.5)
	;(5)[4] = cca.fadeOut(0.5)
	_ENV = 5
	;(5).onComplete = function()
		actLabel:removeFromParent()
	end
	transition.execute(actLabel, cca.spawn(5), 5)
end
function epicBattleActionNode:btnPlusClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDCreatePanel("epicBattleActionBuyView"):show()
	end
end
function epicBattleActionNode:onExit()
	SoraDRemoveMessageByTarget(self)
	SoraDManagerRemoveTimerByTarget(self)
end
return epicBattleActionNode
