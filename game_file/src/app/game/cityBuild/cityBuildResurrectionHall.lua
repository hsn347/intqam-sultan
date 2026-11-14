local cityBuildViewDef = include("cityBuildViewDef")
local cityBuildConstDef = include("cityBuildConstDef")
local gametop = gModuleMgr.getObject("gametop")
local cityBuildResurrectionHall = class("cityBuildResurrectionHall", function()
	local cityBuildClass = include("cityBuildBaseEntity")
	return cityBuildClass.new()
end)
function cityBuildResurrectionHall:ctor()
	self:setBuildIndex(cityBuildConstDef.buildIndexDef.index_ResurrectionHall)
	self.bid = cityBuildConstDef.fixedBuildDef.ResurrectionHall
end
function cityBuildResurrectionHall:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_RESURRECTION_HALL_VIEW", handler(self, self.msgUpdateView))
	SoraDAddMessage(self, "MESSAGE_MAINCITYVIEW_UPDATE_NIGHT_CFG", handler(self, self.updateView))
	self:updateView()
end
function cityBuildResurrectionHall:loadView()
	self:loadBaseView()
	_ENV = nil
	_ENV, (nil).name = i18n("common_text_3458"), i18n("common_text_3458")
	i18n("common_text_3458").x = 0
	;(nil).pos, i18n("common_text_3458").y = i18n("common_text_3458"), -50
	SoraDShowNameOnTouchEvent(self, nil)
end
function cityBuildResurrectionHall:msgUpdateView(target, data)
	self:updateView()
end
function cityBuildResurrectionHall:updateView()
	self:updateIsLock()
	if self:getIsLocked() == false then
		local resurrectionCtrl = gametop.playertop_:getModule("resurrectionCtrl")
		local resuscitateState = resurrectionCtrl:getResurrectionState()
		if resuscitateState == gResurrectionActivityState.OPEN then
			if self.showEffectResuscitate then
				self:showEffectResuscitate()
			end
		elseif self.hideEffectResuscitate then
			self:hideEffectResuscitate(false)
		end
		local lifeWaterCtrl = gametop.playertop_:getModule("lifeWaterCtrl")
		local lifeWaterState = lifeWaterCtrl:getResurrectionState()
		if lifeWaterState == gLifeWaterActivityState.OPEN then
			self:showEffectSpringWater()
		else
			self:hideEffectSpringWater()
		end
	end
end
function cityBuildResurrectionHall:showEffectResuscitate()
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
function cityBuildResurrectionHall:hideEffectResuscitate(isRemove)
	local et_node = self:getChildByName("et_lifeTree")
	if et_node then
		et_node:setVisible(false)
		if isRemove then
			et_node:removeFromParent()
		end
	end
end
function cityBuildResurrectionHall:showEffectSpringWater()
	local period = SoraDGetDayPeriod()
	if period == gDay.DAY_TIME then
		if self.et_nodeNight then
			self.et_nodeNight:setVisible(false)
		end
		if not self.et_nodeDay then
			self.et_nodeDay = SoraDCreatAnimation("animationFHQSDay")
			self.et_nodeDay:setPosition(0, -20)
			self.et_nodeDay:addTo(self, 3)
		else
			self.et_nodeDay:setVisible(true)
		end
	else
		if self.et_nodeDay then
			self.et_nodeDay:setVisible(false)
		end
		if not self.et_nodeNight then
			self.et_nodeNight = SoraDCreatAnimation("animationFHQSNight")
			self.et_nodeNight:setPosition(0, -20)
			self.et_nodeNight:addTo(self, 3)
		else
			self.et_nodeNight:setVisible(true)
		end
	end
end
function cityBuildResurrectionHall:hideEffectSpringWater()
	if self.et_nodeDay then
		self.et_nodeDay:setVisible(false)
	end
	if self.et_nodeNight then
		self.et_nodeNight:setVisible(false)
	end
end
return cityBuildResurrectionHall
