local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local hegemonRead = include("hegemonRead")
local hegemonCtrl = gametop.playertop_:getModule("hegemonCtrl")
local legendLordMapView_Hegemon = class("legendLordMapView_Hegemon", function(target)
	if target == nil then
		return SoraDCreateBasePanel("legendLordMapView_Hegemon")
	end
	if type(target) == "string" then
		return SoraDCreateBasePanel(target)
	end
	return target
end)
function legendLordMapView_Hegemon:ctor()
	self.text_time = SoraDGetChildByName(self, "Text_time")
	self.text_time = SoraDCreateTimerLabel(self, self.text_time)
	self.text_name = SoraDGetChildByName(self, "Text_name")
	self.name_bg = SoraDGetChildByName(self, "name_bg")
	self.time_bg = SoraDGetChildByName(self, "time_bg")
	self.image_bg = SoraDGetChildByName(self, "Image_hegemon")
	self.image_bg:setScale(0.75)
	self.node_fire = SoraDGetChildByName(self, "Node_hegemon_fire")
	self.image_icon = SoraDGetChildByName(self, "Image_hegemon_icon")
	self.image_status_fire = SoraDGetChildByName(self, "hegemon_status_fire")
	self.image_status_peace = SoraDGetChildByName(self, "hegemon_status_peace")
end
function legendLordMapView_Hegemon:getBoundingBox(buildID, buildInfo)
	return self.image_bg:getCascadeBoundingBox()
end
function legendLordMapView_Hegemon:initView(buildID, buildInfo)
	self.buildID = buildID
	self.buildInfo = buildInfo
	self:updateInfo()
	self:updateStatus()
end
function legendLordMapView_Hegemon:updateInfo()
	local name = hegemonRead.getName(self.buildID)
	self.text_name:setString(name)
	local posArrowX = SoraDFIsRA() and -self.text_name:getContentSize().width / 2 - 30 or self.text_name:getContentSize().width / 2 + 30
	self.image_icon:setPositionX(posArrowX)
	local image = hegemonRead.getIcon(self.buildID)
	self.image_bg:setSpriteFrame(image)
end
function legendLordMapView_Hegemon:getBuildStatus()
	local activityID = hegemonRead.getActivityIdByBuildID(self.buildID)
	if not activityShowCtrl:getParamByID(activityID) then
		local hegemonRead, param = activityShowCtrl:getParamByID(activityID), activityShowCtrl:getParamByID(activityID)
	end
	local curState = param.curState
	return curState
end
function legendLordMapView_Hegemon:getBuildTime()
	local curState = self:getBuildStatus()
	local activityID = hegemonRead.getActivityIdByBuildID(self.buildID)
	local warTime = 0
	if curState == ACTIVITY_STATE.PREPARE or curState == ACTIVITY_STATE.ACTIVE then
		local eventLeftTime = activityShowCtrl:getTimeInfoByID(activityID)
		if eventLeftTime then
			local timerNode = eventLeftTime.timerNode
			if timerNode then
				warTime = timerNode.timer:getRemainTime()
			end
		end
	end
	return curState, warTime
end
function legendLordMapView_Hegemon:updateStatus()
	local warStatus, warTime = self:getBuildTime()
	if warStatus == ACTIVITY_STATE.PREPARE then
		self.image_status_fire:setVisible(false)
		self.image_status_peace:setVisible(true)
	elseif warStatus == ACTIVITY_STATE.ACTIVE then
		self.image_status_fire:setVisible(true)
		self.image_status_peace:setVisible(false)
	else
		self.image_status_fire:setVisible(false)
		self.image_status_peace:setVisible(false)
	end
	if 0 < warTime then
		self.text_time:beginTime(warTime)
		self.text_time:setVisible(true)
		self.time_bg:setVisible(true)
		self.image_icon:setVisible(true)
	else
		self.text_time:setVisible(false)
		self.time_bg:setVisible(false)
		self.image_icon:setVisible(false)
	end
	local selfKingdomJoin = hegemonCtrl:getJoinBid()
	if selfKingdomJoin and selfKingdomJoin == self.buildID then
		self.image_icon:setVisible(true)
	else
		self.image_icon:setVisible(false)
	end
	local fNode = self.node_fire:getChildByName("hegemon_fightNode")
	if warStatus == ACTIVITY_STATE.ACTIVE and 0 < warTime then
		if not fNode then
			local fightNode = SoraDGetFightingEffect()
			fightNode:setName("hegemon_fightNode")
			fightNode:setScale(0.5)
			fightNode:setPosition(cc.p(0, 0))
			fightNode:addTo(self.node_fire)
			_ENV, _ENV = fightNode, fightNode.addTo
			_ENV, fightNode.addTo[1], fightNode.plist = fightNode, fightNode, "et_lmzdan_02.plist"
			_ENV, fightNode.plist = self.node_fire, "et_lmzdan_01.plist"
			self.node_fire.x = 0
			fightNode.addTo[2], fightNode.pos, self.node_fire.y = fightNode, self.node_fire, 10
			local param = fightNode.addTo
			local et_node = SoraDCreateEffectNode(param)
			et_node:setScale(2)
			et_node:addTo(fightNode)
		end
	elseif fNode then
		fNode:removeFromParent()
	end
end
return legendLordMapView_Hegemon
