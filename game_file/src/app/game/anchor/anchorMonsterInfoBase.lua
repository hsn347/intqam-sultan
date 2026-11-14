local gametop = gModuleMgr.getObject("gametop")
local remainsWarCtrl = gametop.playertop_:getModule("remainsWarCtrl")
local anchorDef = include("anchorDef")
local gQueueTargetStatusType = anchorDef.gQueueTargetStatusType
local anchorMonsterInfoBase = class("anchorMonsterInfoBase", function(target)
	return target
end)
function anchorMonsterInfoBase:ctor()
	self.btnBg = SoraDGetChildByName(self, "Button_bg")
	if self.btnBg then
		self.btnBg:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	self.nodeStatus = SoraDGetChildByName(self, "Node_status")
	self.nodeStatus:setVisible(false)
	self.txtStatus = SoraDGetChildByName(self, "Text_status")
	self.nodeStatusBg = SoraDGetChildByName(self, "Node_status_bg")
	self.nodeStatusBg:setVisible(false)
	self.nodeAttack = SoraDGetChildByName(self, "Node_attack")
	self.nodeHelp = SoraDGetChildByName(self, "Node_help")
end
function anchorMonsterInfoBase:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.uPos then
			SoraDGotoWorldMapPoint(self.uPos)
			SoraDRemoveAllPanelFromManager()
		end
	end
end
function anchorMonsterInfoBase:resetUI()
	self.nodeStatusBg:setVisible(false)
	self.nodeAttack:setVisible(false)
	self.nodeHelp:setVisible(false)
end
function anchorMonsterInfoBase:updateStatus()
	self:resetUI()
	local status = remainsWarCtrl:getBuildingStatus(self.uStatusPos)
	local strStatus, color
	if status == gQueueTargetStatusType.attacking or status == gQueueTargetStatusType.massing then
		strStatus = "Anchor_text_15"
		color = display.COLOR_RED
		self.nodeAttack:setVisible(true)
		self:addStatusAcction(self.nodeAttack)
	elseif status == gQueueTargetStatusType.helping then
		strStatus = "common_text_2913"
		color = display.COLOR_GREEN
		self.nodeHelp:setVisible(true)
		self:addStatusAcction(self.nodeHelp)
	end
	if strStatus then
		self.nodeStatus:setVisible(true)
		self.nodeStatusBg:setVisible(true)
		self.txtStatus:setString(i18n(strStatus))
		if color then
			self.txtStatus:setColor(color)
		end
	else
		self.nodeStatus:setVisible(false)
		self.nodeStatusBg:setVisible(false)
	end
end
function anchorMonsterInfoBase:addStatusAcction(node)
	_UPVALUE2_ = nil
	;(nil)[1] = cca.fadeTo(0.5, 1)
	;(nil)[2] = cca.delay(1)
	;(nil)[3] = cca.fadeTo(0.5, 0)
	;(nil)[4] = cca.fadeTo(0.5, 0)
	;(nil)[5] = cca.fadeTo(0.5, 0)
	local seq = cca.seq(nil)
	node:stopAllActions()
	node:runAction(cca.repeatForever(seq))
end
return anchorMonsterInfoBase
