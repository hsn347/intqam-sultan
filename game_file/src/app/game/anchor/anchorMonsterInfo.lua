local anchorMonsterInfo = class("anchorMonsterInfo", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("anchorMonsterInfo")
	end
	return target
end)
local POS_NODE_BEGIN_Y = -(200 + display.iPhoneXBottom)
local POS_NODE_END_Y = display.iPhoneXBottom
function anchorMonsterInfo:ctor()
	self.handleCloseCallBack = handler(self, self.closeCallBack)
	self.enableTouchCloseSelf = true
	self.isHideCurrentSceneView = false
	self:setBackGroundColorOpacity(0)
	self.Node_content = SoraDGetChildByName(self, "Node_content")
	self.Node_content:setPositionY(POS_NODE_BEGIN_Y)
	self.nodeMonsterZjssg = SoraDGetExtendChildFromCCSByName(self, "CCS_anchorMonsterInfoSingle_zjssg")
	self.nodeMonsterMy = SoraDGetExtendChildFromCCSByName(self, "CCS_anchorMonsterInfoSingle_my")
	self.nodeReaminsWar = SoraDGetExtendChildFromCCSByName(self, "CCS_anchorBuildingInfoSingle_remains")
	self:initView()
end
function anchorMonsterInfo:initView()
	self.Node_content:runAction(cca.moveTo(0.1, cc.p(0, POS_NODE_END_Y)))
	self.nodeMonsterZjssg:initView(false, cc.p(63, 63))
	self.nodeMonsterMy:initView(true, cc.p(4, 4))
	self.nodeReaminsWar:initView(cc.p(33, 33))
end
function anchorMonsterInfo:onMessageListener()
end
function anchorMonsterInfo:closeCallBack()
	self:exitView()
end
function anchorMonsterInfo:exitView()
	POS_NODE_BEGIN_Y = nil
	;(nil)[1] = cca.moveTo(0.1, cc.p(0, POS_NODE_BEGIN_Y))
	;(nil)[2] = cca.callFunc(function()
		self:removeFromParent()
	end)
	;(nil)[3] = cca.callFunc(function()
		self:removeFromParent()
	end)
	;(nil)[4] = cca.callFunc(function()
		self:removeFromParent()
	end)
	;(nil)[5] = cca.callFunc(function()
		self:removeFromParent()
	end)
	self.Node_content:runAction(cca.seq(nil))
end
return anchorMonsterInfo
