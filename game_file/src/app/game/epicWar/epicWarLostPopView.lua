local gametop = gModuleMgr.getObject("gametop")
local epicWarCtrl = gametop.playertop_:getModule("epicWarCtrl")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local epicWarLostPopView = class("epicWarLostPopView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicWarLostPopView")
	end
	return target
end)
function epicWarLostPopView:ctor()
	SoraDCreatAnimation(self.__cname, self._ccsView, false)
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
	self.Button_ok = SoraDGetChildByName(self, "Button_ok")
	self.Button_ok:setTitleText(i18n("common_text_204"))
	self.Button_ok:addTouchEventListener(handler(self, self.onBtnOKClick))
	self.Button_look = SoraDGetChildByName(self, "Button_look")
	self.Button_look:setTitleText(i18n("common_text_829"))
	self.Button_look:addTouchEventListener(handler(self, self.onBtnLookClick))
	self.Node_cri = SoraDGetChildByName(self, "Node_cri")
	local criSprite = cc.criSprite.createCriSprite("sp_sszzsb_001.usm", false, false)
	criSprite:addTo(self.Node_cri)
	criSprite:setBlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
end
function epicWarLostPopView:initData(data)
	self.data = data
end
function epicWarLostPopView:onBtnOKClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:removeFromParent()
	end
end
function epicWarLostPopView:onBtnLookClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if self.btnLookHandle then
			self.btnLookHandle()
			return
		end
		local panle = SoraDCreatePanel("epicBattleMailView")
		panle:initData(self.data)
		panle:show()
	end
end
function epicWarLostPopView:onBtnTrainClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local worldMapWarDef = include("worldMapWarDef")
		worldMapWarDef.openHeroTrainListView()
	end
end
function epicWarLostPopView:onBtnTechClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		;(nil).bid = BUILDID.COLLEGE
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.RESEARCH_TECHNOLOGY, nil)
		SoraDRemoveAllPanelFromManager()
	end
end
function epicWarLostPopView:onBtnUpArmyClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local mildGuideManager = gModuleMgr.sharedMgr("mildGuideManager")
		_ENV = nil
		;(nil).bid = BUILDID.CHARIOT_PLANT
		mildGuideManager:starMildByNewPlayerQuestID(gNewPLayerTaskType.TRAIN_SOLDIERS, nil)
		SoraDRemoveAllPanelFromManager()
	end
end
function epicWarLostPopView:setBtnLookHandle(handle)
	self.btnLookHandle = handle
end
function epicWarLostPopView:setSpineVisible(visible)
	self.Node_spine:setVisible(visible)
	local Center_Node = SoraDGetChildByName(self, "Center_Node")
	Center_Node:setPositionY(Center_Node:getPositionY() + 100)
end
return epicWarLostPopView
