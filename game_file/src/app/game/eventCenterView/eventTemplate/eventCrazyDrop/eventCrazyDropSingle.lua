local eventCrazyDropSingle = class("eventCrazyDropSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("eventCrazyDropSingle")
	end
	return target
end)
function eventCrazyDropSingle:ctor()
	self.itemArray, _ENV, self.award, _ENV, self.eid = nil, nil, nil, nil, nil
	self.Image_event = SoraDGetChildByName(self, "Image_event")
	self.Text_event_name = SoraDGetChildByName(self, "Text_event_name")
	self.Text_des = SoraDGetChildByName(self, "Text_des")
	self.Node_awards = SoraDGetChildByName(self, "Node_awards")
	self.Button_go = SoraDGetChildByName(self, "Button_go")
	self.Button_go:setSwallowTouches(false)
	self.Button_go:setTitleText(i18n("common_text_477"))
	self.Button_go:addTouchEventListener(handler(self, self.onBtnGo))
end
function eventCrazyDropSingle:initData(data, otherData)
	self.scroll = otherData.scroll
	self.view = otherData.view
	self.award = data.award
	self.eid = data.info.eid
	self.Image_event:loadTexture(data.info.bg, ccui.TextureResType.plistType)
	self.Text_event_name:setString(data.info.name)
	self.Text_des:setString(data.info.des)
	for k, v in ipairs(self.award) do
		if not self.itemArray[k] then
			self.itemArray[k] = include("commonItemAward").new()
			self.itemArray[k]:setScale(0.7)
			self.itemArray[k]:setBaseScale(1.0)
			self.itemArray[k]:setOwnScroll(self.scroll)
			self.itemArray[k]:setOwnView(self.view)
			self.itemArray[k]:addTo(self.Node_awards)
		end
		self.itemArray[k]:setVisible(true)
		self.itemArray[k]:initData(v)
		self.itemArray[k]:setPosition(SoraDFPosX(-80 * (k - 1), 0), 0)
	end
	for i = #self.itemArray, #self.award + 1, -1 do
		if self.itemArray[i] then
			self.itemArray[i]:setVisible(false)
		end
	end
end
function eventCrazyDropSingle:skip()
	if self.eid == gActivityTimeActivityID.CRAZY_DROP_ACTIVITY_0 or self.eid == gActivityTimeActivityID.CRAZY_DROP_ACTIVITY_1 then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		mildGuideManager:starToQuickToWorld(nil)
		SoraDRemoveAllPanelFromManager()
	elseif self.eid == gActivityTimeActivityID.CRAZY_DROP_ACTIVITY_2 then
		local currentScene = display.getRunningScene()
		local currentView = currentScene:currentSceneShowView()
		if currentView.__cname == "worldMapView" then
			_ENV = currentView.__cname
			currentView.__cname.msg = "MESSAGE_MAINCITYVIEW_MOVETO_BUILDBYBID"
			local currentView.__cname.goOuterCity, data = true, currentView.__cname
			_ENV = nil
			;(nil).msg = "MESSAGE_MAINSCEN_ONSHOW"
			;(nil).viewType = VIEW_TYPE_CITY
			;(nil).otherData = data
			SoraDSendMessage(nil)
		else
			_ENV = SoraDSendMessage
			SoraDSendMessage.msg = "MESSAGE_MAINCITYVIEW_MOVETO_BUILDBYBID"
			SoraDSendMessage.goOuterCity = true
			SoraDSendMessage(SoraDSendMessage)
		end
		SoraDRemoveAllPanelFromManager()
	elseif self.eid == gActivityTimeActivityID.CRAZY_DROP_ACTIVITY_3 then
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.MAKE_A_WISH, nil)
		SoraDRemoveAllPanelFromManager()
	end
end
function eventCrazyDropSingle:onBtnGo(button, event)
	if event == ccui.TouchEventType.ended then
		if self.scroll and not SoraDIsNodeVisibleOnScroll(button, self.scroll, event) then
			print("node is not on view")
			return
		end
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		self:skip()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = button:getTouchBeganPosition()
		local touchmovePoint = button:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return eventCrazyDropSingle
