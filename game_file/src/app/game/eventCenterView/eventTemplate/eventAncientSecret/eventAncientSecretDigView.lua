local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local ancientTreasureCtrl = gametop.playertop_:getModule("ancientTreasureCtrl")
local ancientTreasureRead = include("ancientTreasureRead")
local publicRead = include("publicRead")
local eventAncientSecretDigView = class("eventAncientSecretDigView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventAncientSecretDigView")
	end
	return target
end)
local huobaID = 821701
local chanzID = 821801
function eventAncientSecretDigView:ctor()
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.Text_status:setString(i18n("AncienTreasure_text_43"))
	self.Text_award:setString(i18n("common_text_2078"))
	self.Button_go:setTitleText(i18n("AncienTreasure_btn_08"))
	self.Button_go:addTouchEventListener(handler(self, self.onGOClick))
	self:setBoxInfo()
end
function eventAncientSecretDigView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE", handler(self, self.updateData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function eventAncientSecretDigView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY) then
		self:removeFromParent()
	end
end
function eventAncientSecretDigView:setBoxInfo()
	for i = 1, 3 do
		local nodeBox = SoraDGetChildByName(self, "Node_box_" .. i)
		local Button_box = SoraDGetChildByName(nodeBox, "Button_box")
		Button_box:setTag(i)
		Button_box:addTouchEventListener(handler(self, self.onBoxClick))
		local Sprite_box = SoraDGetChildByName(Button_box, "Sprite_box")
		local boxInfo = ancientTreasureRead.getBoxInfoByIndex(i)
		Sprite_box:setSpriteFrame(boxInfo.box)
		if i == 3 then
			self:setBoxEffect(nodeBox)
		end
	end
end
function eventAncientSecretDigView:setBoxEffect(target)
	local eNode = self:getChildByName("effect_node")
	if not eNode then
		_ENV, _ENV = "effect_node", self
		;("effect_node").png = "dh_xsyd_01.png"
		;("effect_node").scale = 2.75
		;("effect_node").opacity = 178.5
		_UPVALUE1_ = nil
		;(nil)[1] = cca.fadeTo(0.55, 0.2)
		;(nil)[2] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[3] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[4] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[5] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[6] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[7] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[8] = cca.fadeTo(0.5333333333333333, 0.7)
		;(nil)[9] = cca.fadeTo(0.5333333333333333, 0.7)
		_ENV, self[1], ("effect_node").seq = "effect_node", "effect_node", cca.seq(nil)
		;("effect_node").png = "dh_xsyd_07.png"
		_ENV, self[2], ("effect_node").scale = "effect_node", "effect_node", 2
		;("effect_node").png = "dh_xsyd_02.png"
		;("effect_node").scale = 2.4
		_ENV = nil
		;(nil)[1] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[2] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[3] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[4] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[5] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[6] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[7] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[8] = cca.rotateBy(1.0833333333333333, 540)
		;(nil)[9] = cca.rotateBy(1.0833333333333333, 540)
		self[3], ("effect_node").seq = "effect_node", cca.seq(nil)
		local actionConfig = self
		local roundNode = display.newNode()
		roundNode:setScale(0.3)
		roundNode:setName("effect_node")
		roundNode:addTo(target, 9)
		for k, v in ipairs(actionConfig) do
			if v.png then
				local sprite = display.newSprite("#" .. v.png)
				if v.scale then
					sprite:setScale(v.scale)
				end
				if v.opacity then
					sprite:setOpacity(v.opacity)
				end
				if v.rotation then
					sprite:setRotation(v.rotation)
				end
				if v.seq then
					sprite:runAction(cc.RepeatForever:create(v.seq))
				end
				sprite:addTo(roundNode, k)
			end
		end
	else
		eNode:setVisible(true)
	end
end
function eventAncientSecretDigView:setHuobaInfo()
	local torchCount = ancientTreasureCtrl:getTorchCount(self.buildID)
	self.Text_exploreType:setString(i18n("AncienTreasure_text_32"))
	local Text_num = SoraDGetChildByName(self.Node_exploreType, "Text_num")
	local Text_name = SoraDGetChildByName(self.Node_exploreType, "Text_name")
	local icon_tool = SoraDGetChildByName(self.Node_exploreType, "icon_tool")
	Text_num:setString(torchCount .. "/" .. self.maxLimitTorch)
	icon_tool:setSpriteFrame(publicRead.getIcon(huobaID))
	Text_name:setString(publicRead.getName(huobaID))
	SoraDToCenter(self.Node_exploreType)
end
function eventAncientSecretDigView:setChanzInfo()
	local spadeCount = ancientTreasureCtrl:getSpadeCount(self.buildID)
	self.Text_exploreCount:setString(i18n("AncienTreasure_text_34"))
	local Text_num = SoraDGetChildByName(self.Node_exploreCount, "Text_num")
	local Text_name = SoraDGetChildByName(self.Node_exploreCount, "Text_name")
	local icon_tool = SoraDGetChildByName(self.Node_exploreCount, "icon_tool")
	Text_num:setString(spadeCount .. "/" .. self.maxLimitSpade)
	icon_tool:setSpriteFrame(publicRead.getIcon(chanzID))
	Text_name:setString(publicRead.getName(chanzID))
	SoraDToCenter(self.Node_exploreCount)
end
function eventAncientSecretDigView:initData(instance)
	self.pos = instance:getTilePoint()
	self.buildID = instance.buildID
	self.buildType = instance.buildType
	local svrBuildInfo = ancientTreasureRead.getSvrBuildInfo(self.buildType)
	self.maxLimitTorch = svrBuildInfo.torch
	self.maxLimitSpade = svrBuildInfo.spade
	if not ancientTreasureCtrl:getBuildInfoInAlliance(self.buildID) then
		local ancientTreasureRead, buildInfo = ancientTreasureCtrl:getBuildInfoInAlliance(self.buildID), ancientTreasureCtrl:getBuildInfoInAlliance(self.buildID)
	end
	ancientTreasureRead = nil
	;(nil).name = buildInfo.nickName or ""
	self.ccs_bg:setTitleName(i18n("AncienTreasure_text_28", nil))
	self.Text_pos:setString(self.pos.x .. "," .. self.pos.y)
	self.Text_pos:setTouchEnabled(true)
	self.Text_pos:addTouchEventListener(handler(self, self.onGOClick))
	SoraDDrawTextUnderLine(self.Text_pos, cc.c4b(105, 180, 230, 255))
	local buildInfo = ancientTreasureRead.getBuildInfo(self.buildType)
	ancientTreasureRead = cc.c4b(105, 180, 230, 255)
	cc.c4b(105, 180, 230, 255).type = self.buildType > 0 and i18n(buildInfo.name) or i18n("AncienTreasure_text_60")
	self.Text_type:setString(i18n("common_text_3516", cc.c4b(105, 180, 230, 255)))
	ancientTreasureRead = i18n("common_text_3516", cc.c4b(105, 180, 230, 255))
	i18n("common_text_3516", cc.c4b(105, 180, 230, 255)).num = buildInfo.num
	self.Text_count:setString(i18n("AncienTreasure_text_31", i18n("common_text_3516", cc.c4b(105, 180, 230, 255))))
	self:setHuobaInfo()
	self:setChanzInfo()
	self:setTMZReward()
	self:setWJZReward()
end
function eventAncientSecretDigView:updateData(target, data)
	self:setTMZReward()
	self:setHuobaInfo()
	self:setChanzInfo()
end
function eventAncientSecretDigView:setTMZReward()
	local rewardInfo = ancientTreasureRead.getBoxInfoByIndex(2)
	local Button_box = SoraDGetChildByName(self.Node_findBox, "Button_box")
	Button_box:addTouchEventListener(handler(self, self.onTMZBoxClick))
	local Text_tip = SoraDGetChildByName(self.Node_findBox, "Text_tip")
	Text_tip:setString(i18n("AncienTreasure_text_44"))
	local Text_got = SoraDGetChildByName(self.Node_findBox, "Text_got")
	ancientTreasureRead = i18n("AncienTreasure_text_44")
	i18n("AncienTreasure_text_44").num = ""
	Text_got:setString(i18n("AncienTreasure_text_45", i18n("AncienTreasure_text_44")))
	local Text_boxName = SoraDGetChildByName(self.Node_findBox, "Text_boxName")
	Text_boxName:setString(i18n(rewardInfo.name))
	local myTorchCount = ancientTreasureCtrl:getTorchCount(self.buildID)
	local mySpadeCount = ancientTreasureCtrl:getSpadeCount(self.buildID)
	local svrBuildInfo = ancientTreasureRead.getSvrBuildInfo(self.buildType)
	local torchMax = svrBuildInfo.torch
	local spadeMax = svrBuildInfo.spade
	local total = svrBuildInfo.detectReward[2]
	local count = math.floor((myTorchCount + mySpadeCount) * total / (torchMax + spadeMax))
	print("torchMax,spadeMax,total,myTorchCount,mySpadeCount===", torchMax, spadeMax, total, myTorchCount, mySpadeCount)
	local Text_num = SoraDGetChildByName(self.Node_findBox, "Text_num")
	Text_num:setString(count)
	local Sprite_got = SoraDGetChildByName(self.Node_findBox, "Sprite_got")
	Sprite_got:setVisible(0 < count)
	self.Node_gotTip:setVisible(0 < count)
end
function eventAncientSecretDigView:setWJZReward()
	local rewardInfo = ancientTreasureRead.getBoxInfoByIndex(3)
	local Button_box = SoraDGetChildByName(self.Node_digBox, "Button_box")
	Button_box:addTouchEventListener(handler(self, self.onWJZBoxClick))
	local Text_tip = SoraDGetChildByName(self.Node_digBox, "Text_tip")
	Text_tip:setString(i18n("AncienTreasure_text_46"))
	local Text_boxName = SoraDGetChildByName(self.Node_digBox, "Text_boxName")
	Text_boxName:setString(i18n(rewardInfo.name))
end
function eventAncientSecretDigView:onTMZBoxClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("eventAncientSecretAwardView")
		panel:initData(2)
		panel:show()
	end
end
function eventAncientSecretDigView:onWJZBoxClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("eventAncientSecretAwardView")
		panel:initData(3)
		panel:show()
	end
end
function eventAncientSecretDigView:onBoxClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("eventAncientSecretAwardView")
		panel:initData(target:getTag())
		panel:show()
	end
end
function eventAncientSecretDigView:onGOClick(target, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		print("跳转到世界坐标======")
		_ENV = "跳转到世界坐标======"
		;("跳转到世界坐标======").x = self.pos.x
		;("跳转到世界坐标======").y = self.pos.y
		SoraDGotoWorldMapPoint("跳转到世界坐标======", true)
		SoraDRemoveAllPanelFromManager()
	end
end
return eventAncientSecretDigView
