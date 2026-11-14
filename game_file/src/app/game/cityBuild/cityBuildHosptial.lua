local gametop = gModuleMgr.getObject("gametop")
local armyCtrl = gametop.playertop_:getModule("armyCtrl")
local cityBuildBaseEntity = include("cityBuildBaseEntity")
local cityBuildHosptial = class("cityBuildHosptial", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildHosptial:ctor()
end
function cityBuildHosptial:loadView()
	self:loadBaseView()
end
function cityBuildHosptial:onMessageListener()
	cityBuildBaseEntity.onMessageListener(self)
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_HOSPTIAL_VIEW", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_SERVER_UPDATE_BUILD_CAN_UPGRADE", handler(self, self.sMsgUpdateBuildCanUpgrade))
	SoraDAddMessage(self, "MESSAGE_RESURGENCE_TREE_STATE_CHANGE", handler(self, self.sMsgUpdateTreeState))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_BUILDSTAR_QUEQUE_CALLBACK", handler(self, self.updateStarLv))
	SoraDAddMessage(self, "MESSAGE_BUILD_STAR_UPGRADE", handler(self, self.updateStarLv))
end
function cityBuildHosptial:sMsgUpdateTreeState(target, data)
	do return end
	local resurrectionCtrl = gametop.playertop_:getModule("resurrectionCtrl")
	local resuscitateState = resurrectionCtrl:getResurrectionState()
	if resuscitateState == gResurrectionActivityState.OPEN then
		if self.showEffectResuscitate then
			self:showEffectResuscitate()
		end
	elseif self.hideEffectResuscitate then
		self:hideEffectResuscitate(false)
	end
end
function cityBuildHosptial:msgUpdateView(target, data)
	self:updateView()
end
function cityBuildHosptial:updateView()
	local woundArmy = armyCtrl:getWoundedArmy()
	local totalArmy = 0
	if woundArmy then
		for k, v in pairs(woundArmy) do
			totalArmy = totalArmy + v
		end
	end
	if 0 < totalArmy then
		self:showNormalParticle()
	else
		self:hideNormalParticle()
	end
	do return end
	local resurrectionCtrl = gametop.playertop_:getModule("resurrectionCtrl")
	local resuscitateState = resurrectionCtrl:getResurrectionState()
	if resuscitateState == gResurrectionActivityState.OPEN then
		if self.showEffectResuscitate then
			self:showEffectResuscitate()
		end
	elseif self.hideEffectResuscitate then
		self:hideEffectResuscitate(false)
	end
end
function cityBuildHosptial:showEffectResuscitate()
	do return end
	local et_node = self:getChildByName("et_lifeTree")
	if et_node then
		et_node:setVisible(true)
		return
	end
	_ENV, _ENV = et_node, et_node.setVisible
	_ENV, et_node.setVisible[1], et_node.plist = et_node, et_node, "et_lifetree_01_01.plist"
	_ENV, et_node.plist = true, "et_gongfang_complete_02.plist"
	;(true).x = 1.16
	et_node.setVisible[2], et_node.scale, (true).y = et_node, true, 1.2
	local param = et_node.setVisible
	local et_node = SoraDCreateEffectNode(param)
	et_node:setName("et_lifeTree")
	et_node:addTo(self, 3)
end
function cityBuildHosptial:hideEffectResuscitate(isRemove)
	do return end
	local et_node = self:getChildByName("et_lifeTree")
	if et_node then
		et_node:setVisible(false)
		if isRemove then
			et_node:removeFromParent()
		end
	end
end
return cityBuildHosptial
