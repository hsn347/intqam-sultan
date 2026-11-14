local radianceWarRead = include("radianceWarRead")
local publicRead = include("publicRead")
local radianceWarResultView = class("radianceWarResultView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("radianceWarResultView")
	end
	return target
end)
function radianceWarResultView:ctor()
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.scaleActTarget = self.centerNode
	self:panelScaleAct()
	self.textDescribe = SoraDGetChildByName(self, "Text_Describe")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createScrollSingle))
	self.scroll:setSingleRefresh(handler(self, self.refreshScrollSingle))
	self.btnSure = SoraDGetChildByName(self, "Button_Sure")
	self.btnSure:setTitleText(i18n("common_text_204"))
	self.btnSure:addTouchEventListener(handler(self, self.btnSureClick))
	self.nodeSingle = SoraDGetChildByName(self, "Node_Single")
	self.nodeSpine = SoraDGetChildByName(self, "Node_spine")
	local spine_lost = sp.SkeletonAnimation:create("spine/shengli.skel", "spine/shengli.atlas", 1)
	spine_lost:addTo(self.nodeSpine)
	spine_lost:setPositionY(-50)
	spine_lost:setAnimation(0, "animation", true)
	self:initData()
end
function radianceWarResultView:onExitPanel()
	_G.SoraDGetCtrl("radianceActivityCtrl"):resetRadianceWarEnd()
end
function radianceWarResultView:close(ref, type)
	if type == ccui.TouchEventType.ended then
		self:closePanel()
		if not worldMapDefine.isInRadiance() then
			_G.SoraDQuickLogin()
		end
	end
end
function radianceWarResultView:initData(data)
	local reward
	local infoReward = radianceWarRead.getRewardList(1)
	for i, v in ipairs(infoReward) do
		if v.type == 1 then
			reward = v.reward
		end
	end
	radianceWarRead = v.type
	v.type.scroll = self.scroll
	v.type.view = self
	self.scroll:updateScrollView(cc.size(640, 100), reward, 1, v.type)
	self.textDescribe:setString(i18n("brightWar_text_49"))
end
function radianceWarResultView:createScrollSingle()
	local single = self.nodeSingle:clone()
	local buttonItem = SoraDGetChildByName(single, "Button_item")
	buttonItem = include("commonBtnInstance").new(buttonItem)
	buttonItem:setScroll(self.scroll)
	return single
end
function radianceWarResultView:refreshScrollSingle(itemSingle, data, otherData)
	itemSingle:getChildByName("Image_quality"):loadTexture(publicRead.getBg(data.id), ccui.TextureResType.plistType)
	itemSingle:getChildByName("Image_icon"):loadTexture(publicRead.getIcon(data.id), ccui.TextureResType.plistType)
	itemSingle:getChildByName("Text_name"):setString(publicRead.getName(data.id))
	publicRead = publicRead.getName(data.id)
	publicRead.getName(data.id).num = "x"
	publicRead.getName(data.id).char = data.count
	itemSingle:getChildByName("Text_num"):setString(i18n("common_text_1470", publicRead.getName(data.id)))
	itemSingle:getChildByName("Button_item"):setItemInfo(self, data.id, data.count)
end
function radianceWarResultView:btnSureClick(target, eventType)
	if eventType == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		local tag = target:getTag()
		self:close(self, eventType)
	elseif eventType == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif eventType == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return radianceWarResultView
