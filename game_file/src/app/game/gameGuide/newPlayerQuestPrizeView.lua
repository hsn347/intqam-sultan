local gametop = gModuleMgr.getObject("gametop")
local newPlayerTaskCtrl = gametop.playertop_:getModule("newPlayerTaskCtrl")
local newPlayerTaskRead = include("newPlayerTaskRead")
local NewPlayerQuestPrizeView = class("newPlayerQuestPrizeView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("newPlayerQuestPrizeView")
	end
	return target
end)
function NewPlayerQuestPrizeView:ctor()
	self.tableData, _ENV, self.tablePrizeSinge, _ENV = nil, nil, nil, nil
	self.centerNode = SoraDGetChildByName(self, "Center_Node")
	self.layerTouch = SoraDGetChildByName(self, "Panel_touch")
	self.layerTouch:setContentSize(display.size)
	self.layerTouch:setPositionY(-90)
	self.img4 = SoraDGetChildByName(self, "Image_4")
	self.nodeBg = SoraDGetChildByName(self, "Node_bg")
	self.nodeEffect = SoraDGetChildByName(self, "Node_effect")
	self.btnOk = SoraDGetChildByName(self, "Button_ok")
	self.labelDes = SoraDGetChildByName(self, "Text_des")
	self.labelNotice = SoraDGetChildByName(self, "Text_notice")
	self.nodeItemParent = SoraDGetChildByName(self, "Node_item_parent")
	self.img_title = SoraDGetChildByName(self, "Image_title")
	_UPVALUE2_ = nil
	;(nil)[1] = "ar"
	;(nil)[2] = "en"
	self.img_title:setSpriteFrame(SoraDGetImageNameByLang("frame_zjjl_zhangjiejiangli_%s.png", nil))
	self.btnTitleText = SoraDGetChildByName(self, "Text_1")
	self.btnTitleText:setString(i18n("common_text_1146"))
	self.labelDes:setString(i18n("common_text_3679"))
	self.labelNotice:setString(i18n("common_text_3678"))
	for i, v in ipairs(self.nodeItemParent:getChildren()) do
		local single = include("commonItems").new(v)
		single:setOpacity(0)
		single:setCascadeOpacityEnabled(true)
		single.btnItem = SoraDGetChildByName(v, "Button_item")
		single.btnItem:addTouchEventListener(handler(self, self.itemClickCallBack))
		table.insert(self.tablePrizeSinge, single)
	end
	self.itemTip = SoraDCreatePanel("commonItemTips")
	self.itemTip:addTo(self.nodeItemParent, 2)
	self.itemTip:setVisible(false)
	self.itemTip:setScale(0.8)
	if self.btnOk then
		self.btnOk:addTouchEventListener(handler(self, self.btnClickCallBack))
	end
	SoraDPlaySound("normalcontrol", 3)
	self:playAnimate()
end
function NewPlayerQuestPrizeView:playAnimate()
	local curChapterID = newPlayerTaskCtrl:getCurChapterID()
	local animationName = curChapterID == 4103100 and "animation01" or "animation02"
	local delayF = curChapterID == 4103100 and 70 or 10
	self.centerBg = SoraDGetChildByName(self, "Center_Bg")
	self.spine_bg = sp.SkeletonAnimation:create("spine/dakai.skel", "spine/dakai.atlas", 1)
	self.spine_bg:addTo(self.centerBg, 1)
	self.spine_bg:setAnimation(0, animationName, false)
	self.spine_bg:setPosition(319, -125)
	_ENV = self.spine_bg.setPosition
	local self.spine_bg.setPosition[1], aniNodes = self.btnOk, self.spine_bg.setPosition
	for i, v in ipairs(aniNodes) do
		v:setVisible(false)
		v:setOpacity(0)
	end
	_ENV = false
	;(false)[1] = cca.delay(delayF / 60)
	;(false)[2] = cca.callFunc(function()
		for i, v in ipairs(self.tablePrizeSinge) do
			v:setScale(0.25)
			self = nil
			self = nil
			;(nil)[1] = cca.scaleTo(0.16666666666666666, 0.6)
			;(nil)[2] = cca.scaleTo(0.25, 0.55)
			;(nil)[3] = cca.scaleTo(0.25, 0.55)
			;(nil)[4] = cca.scaleTo(0.25, 0.55)
			;(nil)[1] = cca.fadeIn(0.16666666666666666)
			;(nil)[2] = cca.seq(nil)
			;(nil)[3] = cca.seq(nil)
			;(nil)[4] = cca.seq(nil)
			;(nil)[5] = cca.seq(nil)
			;(nil)[6] = cca.seq(nil)
			;(nil)[7] = cca.seq(nil)
			v:runAction(cca.spawn(nil))
		end
		for i, v in ipairs(aniNodes) do
			v:setVisible(true)
			v:runAction(cca.fadeIn(0.16666666666666666))
		end
		local effect_show, effectAction = SoraDCreatAnimation(self.__cname, self, true)
		self = v.runAction
		v.runAction[1] = cca.delay(1.25)
		v.runAction[2] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[3] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[4] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[5] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[6] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[7] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[8] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[9] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[10] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		self:runAction(cca.seq(v.runAction))
	end)
	;(false)[3] = cca.callFunc(function()
		for i, v in ipairs(self.tablePrizeSinge) do
			v:setScale(0.25)
			self = nil
			self = nil
			;(nil)[1] = cca.scaleTo(0.16666666666666666, 0.6)
			;(nil)[2] = cca.scaleTo(0.25, 0.55)
			;(nil)[3] = cca.scaleTo(0.25, 0.55)
			;(nil)[4] = cca.scaleTo(0.25, 0.55)
			;(nil)[1] = cca.fadeIn(0.16666666666666666)
			;(nil)[2] = cca.seq(nil)
			;(nil)[3] = cca.seq(nil)
			;(nil)[4] = cca.seq(nil)
			;(nil)[5] = cca.seq(nil)
			;(nil)[6] = cca.seq(nil)
			;(nil)[7] = cca.seq(nil)
			v:runAction(cca.spawn(nil))
		end
		for i, v in ipairs(aniNodes) do
			v:setVisible(true)
			v:runAction(cca.fadeIn(0.16666666666666666))
		end
		local effect_show, effectAction = SoraDCreatAnimation(self.__cname, self, true)
		self = v.runAction
		v.runAction[1] = cca.delay(1.25)
		v.runAction[2] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[3] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[4] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[5] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[6] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[7] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[8] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[9] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[10] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		self:runAction(cca.seq(v.runAction))
	end)
	;(false)[4] = cca.callFunc(function()
		for i, v in ipairs(self.tablePrizeSinge) do
			v:setScale(0.25)
			self = nil
			self = nil
			;(nil)[1] = cca.scaleTo(0.16666666666666666, 0.6)
			;(nil)[2] = cca.scaleTo(0.25, 0.55)
			;(nil)[3] = cca.scaleTo(0.25, 0.55)
			;(nil)[4] = cca.scaleTo(0.25, 0.55)
			;(nil)[1] = cca.fadeIn(0.16666666666666666)
			;(nil)[2] = cca.seq(nil)
			;(nil)[3] = cca.seq(nil)
			;(nil)[4] = cca.seq(nil)
			;(nil)[5] = cca.seq(nil)
			;(nil)[6] = cca.seq(nil)
			;(nil)[7] = cca.seq(nil)
			v:runAction(cca.spawn(nil))
		end
		for i, v in ipairs(aniNodes) do
			v:setVisible(true)
			v:runAction(cca.fadeIn(0.16666666666666666))
		end
		local effect_show, effectAction = SoraDCreatAnimation(self.__cname, self, true)
		self = v.runAction
		v.runAction[1] = cca.delay(1.25)
		v.runAction[2] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[3] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[4] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[5] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[6] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[7] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[8] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[9] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		v.runAction[10] = cca.callFunc(function()
			effectAction:gotoFrameAndPlay(75, 150, true)
		end)
		self:runAction(cca.seq(v.runAction))
	end)
	self:runAction(cca.seq(false))
end
function NewPlayerQuestPrizeView:initData(data)
	self.tableData = data
	for k, v in ipairs(self.tableData) do
		v.itemID = v.id
		v.itemCount = v.count
	end
	for i, v in ipairs(self.tablePrizeSinge) do
		if self.tableData[i] then
			v:initData(self.tableData[i])
			v.btnItem:setTag(self.tableData[i].itemID)
			v.name:setVisible(false)
		else
			v:setVisible(false)
		end
	end
	local UIData = gModuleMgr.sharedMgr("mildGuideManager"):getVariate(self.__cname)
	if UIData then
		self.labelNotice:setVisible(UIData.isOtherReward)
		if UIData.curChapterID == 4103000 then
			userSDKManager.onGuideEvent(2038)
		end
	end
end
function NewPlayerQuestPrizeView:btnClickCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(button, type)
	end
end
function NewPlayerQuestPrizeView:close(ref, type)
	if type == ccui.TouchEventType.ended then
		local curChapterID = newPlayerTaskCtrl:getCurChapterID()
		local guideCtrl = gametop.playertop_:getModule("guideCtrl")
		self:showGirl()
		SoraCollectgarbage(self.__cname)
		self:removeFromParent()
	end
end
function NewPlayerQuestPrizeView:showGirl()
	SoraDNewChapterOpen()
	local curChapterID = newPlayerTaskCtrl:getCurChapterID()
	if curChapterID == 4103100 then
		userSDKManager.onGuideEvent(2039)
	end
end
function NewPlayerQuestPrizeView:itemClickCallBack(button, type)
	if type == ccui.TouchEventType.began then
		local btnParent = button:getParent()
		self.itemTip:initData(button:getTag())
		self.itemTip:setVisible(true)
		self.itemTip:setPosition(cc.p(btnParent:getPositionX() + SoraDFSign(110), btnParent:getPositionY() + 170))
	elseif type ~= ccui.TouchEventType.moved then
		self.itemTip:setVisible(false)
	end
end
return NewPlayerQuestPrizeView
