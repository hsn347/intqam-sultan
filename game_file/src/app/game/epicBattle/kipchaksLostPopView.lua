local kipchaksLostPopView = class("kipchaksLostPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("kipchaksLostPopView")
	end
	return target
end)
function kipchaksLostPopView:ctor()
	self.data = nil
	self.Text_tip = SoraDGetChildByName(self, "Text_tip")
	self.Text_tip:setString(i18n("epicbattle_text_17"))
	self.Text_upTip = SoraDGetChildByName(self, "Text_upTip")
	self.Text_upTip:setString(i18n("epicbattle_text_18"))
	_ENV, _ENV, self.Node_way = self, SoraDGetChildByName(self, "Node_way"), SoraDGetChildByName(self, "Node_way")
	self.name = "epicbattle_btn_03"
	_ENV, SoraDGetChildByName(self, "Node_way")[1], self.handle = self, self, handler(self, self.onBtnTrainClick)
	self.name = "daily_reward_name_06"
	_ENV, SoraDGetChildByName(self, "Node_way")[2], self.handle = self, self, handler(self, self.onBtnTechClick)
	self.name = "epicbattle_btn_02"
	SoraDGetChildByName(self, "Node_way")[3], self.handle = self, handler(self, self.onBtnUpArmyClick)
	local wayConfig = SoraDGetChildByName(self, "Node_way")
	for i = 1, 3 do
		local node = SoraDGetChildByName(self.Node_way, "Node_" .. i)
		local name = SoraDGetChildByName(node, "Text_name")
		name:setString(i18n(wayConfig[i].name))
		local btn = SoraDGetChildByName(node, "Button_bg")
		btn:addTouchEventListener(wayConfig[i].handle)
	end
	self.Node_spine = SoraDGetChildByName(self, "Node_spine")
	local spine_lost = sp.SkeletonAnimation:create("spine/zhanbai.skel", "spine/zhanbai.atlas", 1)
	spine_lost:addTo(self.Node_spine)
	spine_lost:setAnimation(0, "animation", true)
	self.Button_ok = SoraDGetChildByName(self, "Button_ok")
	self.Button_ok:setTitleText(i18n("common_text_204"))
	self.Button_ok:addTouchEventListener(handler(self, self.onBtnOKClick))
	self.Button_look = SoraDGetChildByName(self, "Button_look")
	self.Button_look:setTitleText(i18n("common_text_829"))
	self.Button_look:addTouchEventListener(handler(self, self.onBtnLookClick))
end
function kipchaksLostPopView:initData(data)
	self.data = data
end
function kipchaksLostPopView:onBtnOKClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function kipchaksLostPopView:onBtnLookClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.btnLookHandle then
			self.btnLookHandle()
			return
		end
		local panle = SoraDCreatePanel("kipchaksReport")
		panle:initData(self.data)
		panle:show()
	end
end
function kipchaksLostPopView:onBtnTrainClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local worldMapWarDef = include("worldMapWarDef")
		worldMapWarDef.openHeroTrainListView()
		self:removeFromParent()
	end
end
function kipchaksLostPopView:onBtnTechClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		;(nil).bid = BUILDID.COLLEGE
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.RESEARCH_TECHNOLOGY, nil)
		SoraDRemoveAllPanelFromManager()
	end
end
function kipchaksLostPopView:onBtnUpArmyClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		;(nil).bid = BUILDID.CHARIOT_PLANT
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
		SoraDRemoveAllPanelFromManager()
	end
end
function kipchaksLostPopView:setBtnLookHandle(handle)
	self.btnLookHandle = handle
end
function kipchaksLostPopView:setSpineVisible(visible)
	self.Node_spine:setVisible(visible)
	local Center_Node = SoraDGetChildByName(self, "Center_Node")
	Center_Node:setPositionY(Center_Node:getPositionY() + 100)
end
return kipchaksLostPopView
