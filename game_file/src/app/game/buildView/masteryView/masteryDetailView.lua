local GridScrollView = include("GridScrollView")
local masteryViewSingleItem = include("masteryViewSingleItem")
local buildDescribeRead = include("buildDescribeRead")
local masteryDetailSkillSingle = include("masteryDetailSkillSingle")
local specializationRead = include("specializationRead")
local MASTERY_STATE = specializationRead.MASTERY_STATE
local cityCtrl = SoraDGetCtrl("cityCtrl")
local queueCtrl = SoraDGetCtrl("queueCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local cityBuildMgr = include("cityBuildMgr")
local buildLogic = include("buildLogic")
local masteryDetailView = class("masteryDetailView", function(target)
	if target == nil then
		return SoraDCreateBasePanel("masteryDetailView")
	end
	return target
end)
function masteryDetailView:onExitPanel()
	if self.needRecover then
		_ENV = nil
		;(nil).msg = "MESSAGE_MAINCITYVIEW_OFFSET_BUILD"
		;(nil).offsetType = MAINCITYVIEW_OFFSET_TYPE_RECOVER
		SoraDSendMessage(nil)
		if self.needBack then
			SoraDCreatePanel("masteryMainView"):show()
		end
	end
	display.removeAnimationCache("setStarAnimation_1")
	display.removeAnimationCache("setStarAnimation_2")
	_ENV = "setStarAnimation_2"
	;("setStarAnimation_2").isHideMainUI = false
	SoraDHideCurrentSceneViewAndMainUI("setStarAnimation_2")
end
function masteryDetailView:onEnterPanel()
	_ENV = nil
	;(nil).isHideMainUI = true
	SoraDHideCurrentSceneViewAndMainUI(nil)
end
function masteryDetailView:ctor()
	self.buffNodes, _ENV, self.needRecover = nil, nil, true
	self.needBack = false
	self:initWidget()
	self:initDeviceFit()
	SoraDAddMessage(self, "MESSAGE_MASTERY_VIEW_REFRESH", handler(self, self.msgUpdateView))
end
function masteryDetailView:msgUpdateView(target, event)
	if event.mid and tostring(self.mid) ~= tostring(event.mid) then
		return
	end
	SoraDCloseLoading(self)
	SoraDRemoveAllAfterPanelFromManager(self, true)
	self:refreshData()
	self:refreshState(self.state)
	self:refreshStars()
	self:refreshBuffNode()
	if event.name == "setStar" then
		self:showSetStarEffect()
	elseif event.name == "reset" then
		self:showResetEffect()
	end
end
function masteryDetailView:initWidget(...)
	local ccs_title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_build")
	self.ccs_title = ccs_title
	ccs_title:setTitle(i18n("specialization_text_03"))
	_UPVALUE1_ = i18n("specialization_text_03")
	i18n("specialization_text_03")[1] = "Button_help"
	local Button_help = SoraDGetChildByFullPath(ccs_title, i18n("specialization_text_03"))
	Button_help:addTouchEventListener(function(button, eventType)
		if eventType == ccui.TouchEventType.ended then
			SoraDPlaySound()
			userSDKManager.showFAQSection(gSDKDef.FAQSectionType.BUILD_MASTERY)
		end
	end)
	local root = self._ccsView
	_UPVALUE1_ = i18n("specialization_text_03")
	i18n("specialization_text_03")[1] = "Top_Node"
	self.Top_Node = SoraDGetChildByFullPath(root, i18n("specialization_text_03"))
	_UPVALUE1_ = i18n("specialization_text_03")
	i18n("specialization_text_03")[1] = "Node_buildInfo"
	self.Node_buildInfo = SoraDGetChildByFullPath(self.Top_Node, i18n("specialization_text_03"))
	_UPVALUE1_ = i18n("specialization_text_03")
	i18n("specialization_text_03")[1] = "Text_buildName"
	self.Text_buildName = SoraDGetChildByFullPath(self.Node_buildInfo, i18n("specialization_text_03"))
	_UPVALUE1_ = i18n("specialization_text_03")
	i18n("specialization_text_03")[1] = "Text_buildPower"
	self.Text_buildPower = SoraDGetChildByFullPath(self.Node_buildInfo, i18n("specialization_text_03"))
	_UPVALUE1_ = i18n("specialization_text_03")
	i18n("specialization_text_03")[1] = "Node_cur"
	self.Node_cur = SoraDGetChildByFullPath(self.Node_buildInfo, i18n("specialization_text_03"))
	_UPVALUE1_ = i18n("specialization_text_03")
	i18n("specialization_text_03")[1] = "Node_star"
	local Node_star = SoraDGetChildByFullPath(self.Node_cur, i18n("specialization_text_03"))
	local starSingle = SoraDCreatePanel("masteryStarSingle")
	starSingle:addTo(Node_star)
	self.curStarSingle = starSingle
	_UPVALUE1_ = Node_star
	Node_star[1] = "Text_8"
	SoraDGetChildByFullPath(self.Node_cur, Node_star):setString(i18n("specialization_text_20"))
	_UPVALUE1_ = i18n("specialization_text_20")
	i18n("specialization_text_20")[1] = "Sprite_74"
	self.Sprite_arrow = SoraDGetChildByFullPath(self.Node_buildInfo, i18n("specialization_text_20"))
	_UPVALUE1_ = i18n("specialization_text_20")
	i18n("specialization_text_20")[1] = "Node_next"
	self.Node_next = SoraDGetChildByFullPath(self.Node_buildInfo, i18n("specialization_text_20"))
	_UPVALUE1_ = i18n("specialization_text_20")
	i18n("specialization_text_20")[1] = "Node_star"
	local Node_star = SoraDGetChildByFullPath(self.Node_next, i18n("specialization_text_20"))
	local starSingle = SoraDCreatePanel("masteryStarSingle")
	starSingle:addTo(Node_star)
	self.nextStarSingle = starSingle
	_UPVALUE1_ = Node_star
	Node_star[1] = "Text_8"
	self.Text_next = SoraDGetChildByFullPath(self.Node_next, Node_star)
	self.Text_next:setString(i18n("common_text_381"))
	_UPVALUE1_ = i18n("common_text_381")
	i18n("common_text_381")[1] = "Node_upgrade"
	self.Node_upgrade = SoraDGetChildByFullPath(self.Node_buildInfo, i18n("common_text_381"))
	_UPVALUE1_ = i18n("common_text_381")
	i18n("common_text_381")[1] = "Button_upgrade"
	self.Button_upgrade = SoraDGetChildByFullPath(self.Node_upgrade, i18n("common_text_381"))
	self.Button_upgrade:addTouchEventListener(handler(self, self.onClick_upgrade))
	_UPVALUE1_ = handler(self, self.onClick_upgrade)
	handler(self, self.onClick_upgrade)[1] = "Node_time"
	self.Node_time = SoraDGetChildByFullPath(self.Node_upgrade, handler(self, self.onClick_upgrade))
	_UPVALUE1_ = handler(self, self.onClick_upgrade)
	handler(self, self.onClick_upgrade)[1] = "Text_time"
	self.Text_time = SoraDGetChildByFullPath(self.Node_time, handler(self, self.onClick_upgrade))
	_UPVALUE1_ = handler(self, self.onClick_upgrade)
	handler(self, self.onClick_upgrade)[1] = "Text_upgrade"
	SoraDGetChildByFullPath(self.Node_upgrade, handler(self, self.onClick_upgrade)):setString(i18n("common_text_055"))
	_UPVALUE1_ = i18n("common_text_055")
	i18n("common_text_055")[1] = "Node_loadingbar"
	self.Node_loadingbar = SoraDGetChildByFullPath(self.Node_buildInfo, i18n("common_text_055"))
	self.loadingBar = SoraDGetExtendChildFromCCSByName(self.Node_loadingbar, "CCS_commonProgressBar_time")
	_UPVALUE1_ = "CCS_commonProgressBar_time"
	;("CCS_commonProgressBar_time")[1] = "Text_time"
	self.loadingBar_time = SoraDGetChildByFullPath(self.loadingBar, "CCS_commonProgressBar_time")
	_UPVALUE1_ = "CCS_commonProgressBar_time"
	;("CCS_commonProgressBar_time")[1] = "Button_cancel"
	self.Button_cancel = SoraDGetChildByFullPath(self.loadingBar, "CCS_commonProgressBar_time")
	self.Button_cancel:addTouchEventListener(handler(self, self.onClick_cancel))
	_UPVALUE1_ = handler(self, self.onClick_cancel)
	handler(self, self.onClick_cancel)[1] = "Node_speedUp"
	self.Node_speedUp = SoraDGetChildByFullPath(self.Node_loadingbar, handler(self, self.onClick_cancel))
	_UPVALUE1_ = handler(self, self.onClick_cancel)
	handler(self, self.onClick_cancel)[1] = "Button_speedUp"
	self.Button_speedUp = SoraDGetChildByFullPath(self.Node_speedUp, handler(self, self.onClick_cancel))
	self.Button_speedUp:setTitleText(i18n("common_text_018"))
	self.Button_speedUp:addTouchEventListener(handler(self, self.onClick_speedup))
	_UPVALUE1_ = handler(self, self.onClick_speedup)
	handler(self, self.onClick_speedup)[1] = "Node_immed"
	self.Node_immed = SoraDGetChildByFullPath(self.Node_loadingbar, handler(self, self.onClick_speedup))
	_UPVALUE1_ = handler(self, self.onClick_speedup)
	handler(self, self.onClick_speedup)[1] = "Button_immed"
	self.Button_immed = SoraDGetChildByFullPath(self.Node_immed, handler(self, self.onClick_speedup))
	self.Button_immed:addTouchEventListener(handler(self, self.onClick_immed))
	_UPVALUE1_ = handler(self, self.onClick_immed)
	handler(self, self.onClick_immed)[1] = "Node_gold"
	self.Node_gold = SoraDGetChildByFullPath(self.Node_immed, handler(self, self.onClick_immed))
	_UPVALUE1_ = handler(self, self.onClick_immed)
	handler(self, self.onClick_immed)[1] = "Text_gold"
	self.Text_gold = SoraDGetChildByFullPath(self.Node_gold, handler(self, self.onClick_immed))
	_UPVALUE1_ = handler(self, self.onClick_immed)
	handler(self, self.onClick_immed)[1] = "Text_immed"
	SoraDGetChildByFullPath(self.Node_immed, handler(self, self.onClick_immed)):setString(i18n("common_text_378"))
	_UPVALUE1_ = i18n("common_text_378")
	i18n("common_text_378")[1] = "Node_unlock"
	self.Node_unlock = SoraDGetChildByFullPath(self.Node_buildInfo, i18n("common_text_378"))
	_UPVALUE1_ = i18n("common_text_378")
	i18n("common_text_378")[1] = "Text_16"
	local Text_16 = SoraDGetChildByFullPath(self.Node_unlock, i18n("common_text_378"))
	Text_16:setString(i18n("specialization_text_23"))
	_UPVALUE1_ = i18n("specialization_text_23")
	i18n("specialization_text_23")[1] = "Sprite_2"
	SoraDGetChildByFullPath(self.Node_unlock, i18n("specialization_text_23")):setPositionX(Text_16:getContentSize().width / 2 + 20)
	_UPVALUE1_ = Text_16:getContentSize().width / 2 + 20
	;(Text_16:getContentSize().width / 2 + 20)[1] = "Text_17"
	self.Text_lock = SoraDGetChildByFullPath(self.Node_unlock, Text_16:getContentSize().width / 2 + 20)
	_UPVALUE1_ = Text_16:getContentSize().width / 2 + 20
	;(Text_16:getContentSize().width / 2 + 20)[1] = "Button_go"
	self.Button_go = SoraDGetChildByFullPath(self.Node_unlock, Text_16:getContentSize().width / 2 + 20)
	self.Button_go:setTitleText(i18n("specialization_text_21"))
	self.Button_go:addTouchEventListener(handler(self, self.onClick_go))
	_UPVALUE1_ = handler(self, self.onClick_go)
	handler(self, self.onClick_go)[1] = "Text_bottom"
	SoraDGetChildByFullPath(self.Top_Node, handler(self, self.onClick_go)):setString(i18n("specialization_text_08"))
	_UPVALUE1_ = i18n("specialization_text_08")
	i18n("specialization_text_08")[1] = "Top_Size_ScrollView_build"
	self.scroll = SoraDGetChildByFullPath(self.Top_Node, i18n("specialization_text_08"))
	_UPVALUE1_ = i18n("specialization_text_08")
	i18n("specialization_text_08")[1] = "Node_skill"
	self.Node_skill = SoraDGetChildByFullPath(self.scroll, i18n("specialization_text_08"))
	_UPVALUE1_ = i18n("specialization_text_08")
	i18n("specialization_text_08")[1] = "Node_reset"
	self.Node_reset = SoraDGetChildByFullPath(self.Node_skill, i18n("specialization_text_08"))
	_UPVALUE1_ = i18n("specialization_text_08")
	i18n("specialization_text_08")[1] = "Text_5"
	self.Text_des = SoraDGetChildByFullPath(self.Node_reset, i18n("specialization_text_08"))
	_UPVALUE1_ = i18n("specialization_text_08")
	i18n("specialization_text_08")[1] = "Image_reset"
	self.Image_reset = SoraDGetChildByFullPath(self.Node_reset, i18n("specialization_text_08"))
	self.Image_reset:setTouchEnabled(true)
	self.Image_reset:addTouchEventListener(handler(self, self.onClick_reset))
	_UPVALUE1_ = handler(self, self.onClick_reset)
	handler(self, self.onClick_reset)[1] = "Node_center"
	self.Node_center = SoraDGetChildByFullPath(self.Node_skill, handler(self, self.onClick_reset))
	_UPVALUE1_ = handler(self, self.onClick_reset)
	handler(self, self.onClick_reset)[1] = "Sprite_7"
	self.Sprite_bg = SoraDGetChildByFullPath(self.Node_center, handler(self, self.onClick_reset))
	_UPVALUE1_ = handler(self, self.onClick_reset)
	handler(self, self.onClick_reset)[1] = "Sprite_1"
	self.Sprite_stars = SoraDGetChildByFullPath(self.Node_center, handler(self, self.onClick_reset))
	_UPVALUE1_ = handler(self, self.onClick_reset)
	handler(self, self.onClick_reset)[1] = "Text_4"
	self.Text_stars = SoraDGetChildByFullPath(self.Node_center, handler(self, self.onClick_reset))
	_UPVALUE1_ = handler(self, self.onClick_reset)
	handler(self, self.onClick_reset)[1] = "Node_effect"
	self.Node_effect_set = SoraDGetChildByFullPath(self.Node_center, handler(self, self.onClick_reset))
	_UPVALUE1_ = handler(self, self.onClick_reset)
	handler(self, self.onClick_reset)[1] = "Node_effect_reset"
	self.Node_effect_reset = SoraDGetChildByFullPath(self.Node_center, handler(self, self.onClick_reset))
	self.Node_effect_reset:setVisible(false)
	_UPVALUE1_ = false
	;(false)[1] = "Node_line"
	self.Node_line = SoraDGetChildByFullPath(self.Node_skill, false)
	self.lineList = SoraDGetChildsArrayByName(self.Node_line, "Sprite_", 6, 1)
	_UPVALUE1_ = "Sprite_"
	;("Sprite_")[1] = "Node_left"
	self.Node_left = SoraDGetChildByFullPath(self.Node_skill, "Sprite_")
	_UPVALUE1_ = "Sprite_"
	;("Sprite_")[1] = "Node_right"
	self.Node_right = SoraDGetChildByFullPath(self.Node_skill, "Sprite_")
	_UPVALUE1_ = "Sprite_"
	;("Sprite_")[1] = "Node_down"
	self.Node_down = SoraDGetChildByFullPath(self.Node_skill, "Sprite_")
	_UPVALUE1_ = "Sprite_"
	;("Sprite_")[1] = "Bottom_Node"
	self.Bottom_Node = SoraDGetChildByFullPath(root, "Sprite_")
	_UPVALUE2_ = "Sprite_"
	;("Sprite_")[1] = "Node_bottomLine"
	;("Sprite_")[2] = "frame_lace_base_1"
	self.frameLaceLeft = SoraDGetChildByFullPath(self.Bottom_Node, "Sprite_")
	_UPVALUE2_ = "Sprite_"
	;("Sprite_")[1] = "Node_bottomLine"
	;("Sprite_")[2] = "frame_lace_base_2"
	self.frameLaceRight = SoraDGetChildByFullPath(self.Bottom_Node, "Sprite_")
	_UPVALUE1_ = "Node_bottomLine"
	;("Node_bottomLine")[1] = "Node_fire"
	_UPVALUE1_ = "Node_fire"
	;("Node_fire")[1] = "Node_fire"
	SoraDCreateFireEffectNode(SoraDGetChildByFullPath(self.frameLaceLeft, "Node_bottomLine"), SoraDGetChildByFullPath(self.frameLaceRight, "Node_fire"))
end
function masteryDetailView:initDeviceFit(...)
	local sW = self.scroll:getContentSize().width
	local sH = display.height - 462
	local innerH = self.scroll:getInnerContainerSize().height
	sH = math.min(innerH, sH)
	self.scroll:setContentSize(cc.size(sW, sH))
	self.scroll:setBounceEnabled(innerH > self.scroll:getContentSize().height)
	if display.height >= 960 then
		self.frameLaceLeft:setPositionY(30)
		self.frameLaceRight:setPositionY(30)
	end
	local offsetY = display.height - 1263
	if 0 < offsetY then
		_UPVALUE1_ = self.scroll
		self.scroll[1] = "Image_bg_left"
		local imageLeft = SoraDGetChildByFullPath(self.Top_Node, self.scroll)
		_UPVALUE1_ = "Image_bg_left"
		;("Image_bg_left")[1] = "Image_bg_right"
		local imageRight = SoraDGetChildByFullPath(self.Top_Node, "Image_bg_left")
		imageLeft:setContentSize(cc.size(imageLeft:getContentSize().width, imageLeft:getContentSize().height + offsetY))
		imageRight:setContentSize(cc.size(imageRight:getContentSize().width, imageRight:getContentSize().height + offsetY))
	end
end
function masteryDetailView:initData(data)
	self.bid = data.bid
	self.iid = data.iid
	self.mid = data.mid
	self.state = data.state
	self.maxLv = specializationRead.getMasteryMaxLv(self.bid)
	self.needBack = data.needBack
	self.Text_buildName:setString(specializationRead.getMasteryName(self.bid))
	self:refreshData()
	self:initBuffNode()
	self:refreshState(self.state)
	self:refreshStars()
	self:refreshBuffNode()
end
function masteryDetailView:refreshData(...)
	if not cityCtrl:getMasteryByMid(self.mid) then
		cityCtrl = cityCtrl:getMasteryByMid(self.mid)
		cityCtrl:getMasteryByMid(self.mid).star = 0
		cityCtrl:getMasteryByMid(self.mid).lev = 0
	end
	self.mastery = cityCtrl:getMasteryByMid(self.mid)
	self.leftStars = self.mastery.star
	self.maxStars = self.mastery.lev
	self.curLv = self.mastery.lev
	local power = specializationRead.getMasteryFighting(self.bid, self.curLv)
	cityCtrl = nil
	;(nil).power = power
	self.Text_buildPower:setString(i18n("common_text_710", nil))
	local lv, __ = cityCtrl:getBuildMaxLv(self.bid)
	local needLv = specializationRead.getCondBuildingLv(self.bid, self.curLv)
	cityCtrl = i18n("common_text_710", nil)
	i18n("common_text_710", nil).Lv1 = lv
	i18n("common_text_710", nil).Lv2 = needLv
	self.Text_lock:setString(i18n("specialization_text_19", i18n("common_text_710", nil)))
end
function masteryDetailView:initBuffNode(...)
	_ENV = nil
	local (nil).handler, params = handler(self, self.handler_buffNode), nil
	local node = masteryDetailSkillSingle.new(self.Node_left)
	node:initData(params)
	self.buffNodes[1] = node
	local node = masteryDetailSkillSingle.new(self.Node_left:clone())
	node:addTo(self.Node_right)
	node:setPosition(cc.p(0, 0))
	node:initData(params)
	self.buffNodes[2] = node
	local node = masteryDetailSkillSingle.new(self.Node_left:clone())
	node:addTo(self.Node_down)
	node:setPosition(cc.p(0, 0))
	node:initData(params)
	self.buffNodes[3] = node
end
function masteryDetailView:refreshState(state)
	self.Node_loadingbar:setVisible(false)
	if state == MASTERY_STATE.lock or state == MASTERY_STATE.invalid then
		self.Text_buildPower:setVisible(false)
		self.Node_cur:setVisible(false)
		self.Sprite_arrow:setVisible(false)
		self.Node_next:setVisible(false)
		self.Node_unlock:setVisible(true)
		self.Sprite_bg:setSpriteFrame("bg_zzzj4.png")
		self.Sprite_stars:setSpriteFrame("icon_specialization_06.png")
		self.Node_reset:setVisible(false)
		self:hideLineEffect()
		self.Node_effect_set:setVisible(false)
	else
		self.Text_buildPower:setVisible(true)
		self.Node_unlock:setVisible(false)
		self.Sprite_bg:setSpriteFrame("bg_zzzj4_02.png")
		self.Sprite_stars:setSpriteFrame("icon_specialization_07.png")
		self.Node_reset:setVisible(true)
		self:showLineEffect()
		self.Node_effect_set:setVisible(true)
	end
	if state ~= MASTERY_STATE.lock and state ~= MASTERY_STATE.invalid then
		local maxLv = specializationRead.getMasteryMaxLv(self.bid)
		if maxLv > self.curLv then
			MASTERY_STATE = nil
			;(nil).lev = self.curLv
			self.curStarSingle:initData(nil)
			self.Node_next:setPositionX(56)
			self.Text_next:setString(i18n("common_text_381"))
			MASTERY_STATE = i18n("common_text_381")
			i18n("common_text_381").lev = self.curLv + 1
			self.nextStarSingle:initData(i18n("common_text_381"))
			local time = specializationRead.getCondTime(self.bid, self.curLv + 1)
			time = buildLogic.getMasteryUpgradeTime(time)
			self.Text_time:setString(SoraDConvertSecondToString(time))
			local queue = queueCtrl:queryQueue(gQueueTypeDef.build_mastery)
			local upgradingBid = queue and queue.data.bid or 0
			if upgradingBid == self.bid then
				self.queue = queue
				self.Node_upgrade:setVisible(false)
				self.Node_loadingbar:setVisible(true)
				if not self.timeHandle then
					self.timeHandle = SoradCreateTimer(self, handler(self, self.updateTime))
					self:updateTime()
				end
				local list = backpackCtrl:getSpeedUpItemList(gAbbrSpeedUpType.MASTERY_UPGRADE)
				if list and next(list) then
					self.Node_speedUp:setVisible(true)
					self.Node_immed:setPositionX(-78)
				else
					self.Node_speedUp:setVisible(false)
					self.Node_immed:setPositionX(0)
				end
			else
				self.Node_upgrade:setVisible(true)
				SoraDToCenter(self.Node_time, 6)
			end
		else
			self.Node_cur:setVisible(false)
			self.Sprite_arrow:setVisible(false)
			self.Node_next:setPositionX(0)
			self.Text_next:setString(i18n("common_text_283"))
			MASTERY_STATE = i18n("common_text_283")
			i18n("common_text_283").lev = maxLv
			self.nextStarSingle:initData(i18n("common_text_283"))
			self.Node_upgrade:setVisible(false)
		end
	else
		self.Node_upgrade:setVisible(false)
	end
end
function masteryDetailView:refreshStars(...)
	self.Text_des:setString(string.format("%s(%d/%d)", i18n("specialization_text_09"), self.leftStars, self.maxStars))
	self.Text_stars:setString(self.leftStars)
	self.Text_des:setColor(display.COLOR_WHITE)
	if self.leftStars == 0 then
		self.Sprite_bg:setSpriteFrame("bg_zzzj4.png")
		self.Sprite_stars:setSpriteFrame("icon_specialization_06.png")
		self.Text_des:setColor(masteryDetailSkillSingle.COLOR_GRAY)
		self:hideLineEffect()
		self.Node_effect_set:setVisible(false)
	end
end
function masteryDetailView:refreshBuffNode(...)
	for i, node in ipairs(self.buffNodes) do
		local buffID = specializationRead.getMasteryBuffID(self.mid, i)
		local buffLv = self.mastery[tostring(buffID)] or 0
		_ENV = nil
		;(nil).state = self.state
		;(nil).buffID = buffID
		;(nil).buffLv = buffLv
		;(nil).mid = self.mid
		node:initData(nil)
	end
end
function masteryDetailView:onClick_upgrade(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	local panel = SoraDCreatePanel("masteryUpgradePopView")
	_ENV = nil
	;(nil).bid = self.bid
	;(nil).mid = self.mid
	;(nil).curLv = self.curLv
	;(nil).parent = self
	panel:initData(nil)
	panel:show()
end
function masteryDetailView:onClick_speedup(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	SoraDShowSpeedUpByItemBox(gQueueTypeDef.build_mastery, function()
		local list = backpackCtrl:getSpeedUpItemList(gAbbrSpeedUpType.MASTERY_UPGRADE)
		if list and next(list) then
			self.Node_speedUp:setVisible(true)
			self.Node_immed:setPositionX(-78)
		else
			self.Node_speedUp:setVisible(false)
			self.Node_immed:setPositionX(0)
		end
	end)
end
function masteryDetailView:onClick_immed(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	SoraDShowSpeedUpBox(self.queue, nil, i18n("common_text_765"))
end
function masteryDetailView:onClick_go(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	local buildName = buildDescribeRead.getName(tonumber(self.bid))
	local buildCell = cityCtrl:getBuildCell(self.bid, self.iid)
	local queueType = tonumber(buildCell.info.state)
	if queueType == BUILD_STATE.BUILDING then
		_ENV = tonumber(self.bid)
		tonumber(self.bid).name = buildName
		SoraDShowMsgTip(i18n("common_text_753", tonumber(self.bid)))
		return
	end
	self.needRecover = false
	local mainCityFunctions = include("mainCityFunctions")
	mainCityFunctions.masteryJumpToBuildUpgrade(self.bid, self.iid)
	self:closePanel()
end
function masteryDetailView:onClick_reset(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	if self.leftStars == self.maxStars then
		SoraDShowMsgTip(i18n("specialization_tips_04"))
		return
	end
	local cost = specializationRead.getResetCost(self.maxStars - self.leftStars)
	if not SoraDEnoughGold(cost) then
		return
	end
	_ENV = i18n("specialization_tips_04")
	i18n("specialization_tips_04").num = cost
	SoraDShowMsgBox(string.format([[
%s
%s]], i18n("specialization_tips_05"), i18n("alliance_mobilize_des_18", i18n("specialization_tips_04"))), i18n("common_text_204"), i18n("common_text_185"), function(eventType)
		if eventType == MSGBOX_CALLBACK_YES then
			cityCtrl:sendReqMasteryReset(self.mid)
			SoraDShowLoading(self)
		end
	end)
end
function masteryDetailView:handler_buffNode(buffID)
	if self.leftStars > 0 then
		if self.isClooling then
			return
		end
		self.isClooling = true
		_UPVALUE1_ = nil
		;(nil)[1] = cca.delay(0.1)
		;(nil)[2] = cca.callFunc(function()
			self.isClooling = false
		end)
		;(nil)[3] = cca.callFunc(function()
			self.isClooling = false
		end)
		self:runAction(cca.seq(nil))
		local cityCtrl = SoraDGetCtrl("cityCtrl")
		cityCtrl:sendReqMasteryStars(self.mid, buffID)
		self.lastClikBuffID = buffID
		SoraDShowLoading(self)
		return true
	else
		SoraDShowMsgTip(i18n("specialization_tips_08"))
	end
end
function masteryDetailView:updateTime(...)
	local queue = queueCtrl:queryQueue(gQueueTypeDef.build_mastery)
	if not queue and self.timeHandle then
		SoraDManagerRemoveTimer(self, self.timeHandle)
		self.timeHandle = nil
		return
	end
	local totalTime = self.queue.totaltime
	local remainTime = self.queue.timerNode.timer:getRemainTime()
	queueCtrl = nil
	;(nil).maxValue = totalTime
	;(nil).curValue = totalTime - remainTime
	self.loadingBar:setProgressDate(nil)
	self.loadingBar_time:setString(SoraDConvertSecondToString(remainTime))
	local goldPay = serviceFunctions.timeConvertToGold(remainTime)
	self.Text_gold:setString(string.formatnumberthousands(math.floor(goldPay)))
	local goldWidth = self.Text_gold:getContentSize().width
	if not self.goldWidth or self.goldWidth ~= goldWidth then
		self.goldWidth = goldWidth
		SoraDToCenter(self.Node_gold, 6)
	end
end
function masteryDetailView:onClick_cancel(button, event)
	if event ~= ccui.TouchEventType.ended then
		return
	end
	SoraDPlaySound()
	SoraDShowMsgBox(i18n("common_text_731"), i18n("common_text_054"), nil, handler(self, self.cancelQueue))
end
function masteryDetailView:cancelQueue(event)
	if event == MSGBOX_CALLBACK_YES then
		SoraDShowMsgBox(i18n("common_text_736"), i18n("common_text_054"), nil, handler(self, self.sureCancelQueue))
	end
end
function masteryDetailView:sureCancelQueue(event)
	if event == MSGBOX_CALLBACK_YES then
		queueCtrl:cancelQueueReq(gQueueTypeDef.build_mastery)
	end
end
function masteryDetailView:hideLineEffect(...)
	if not self.hasLineEffect then
		return
	end
	self.hasLineEffect = false
	self.Node_line:stopAllActions()
	for i = 1, 6 do
		self.lineList[i]:setSpriteFrame("frame_zzzj_jt.png")
		self.lineList[i]:setOpacity(255)
	end
end
function masteryDetailView:showLineEffect(...)
	if self.hasLineEffect then
		return
	end
	self.hasLineEffect = true
	local delayTime = 0.3
	_UPVALUE5_ = nil
	;(nil)[1] = cca.callFunc(function()
		for i = 1, 6 do
			self.lineList[i]:setSpriteFrame("frame_zzzj_jt.png")
			self.lineList[i]:setOpacity(255)
		end
	end)
	;(nil)[2] = cca.delay(delayTime)
	;(nil)[3] = cca.callFunc(function()
		for i = 1, 3 do
			self.lineList[i]:setSpriteFrame("frame_zzzj_jt_2.png")
			self.lineList[i]:setOpacity(125)
		end
		for i = 4, 6 do
			self.lineList[i]:setSpriteFrame("frame_zzzj_jt.png")
			self.lineList[i]:setOpacity(255)
		end
	end)
	;(nil)[4] = cca.delay(delayTime)
	;(nil)[5] = cca.callFunc(function()
		for i = 4, 6 do
			self.lineList[i]:setSpriteFrame("frame_zzzj_jt_2.png")
			self.lineList[i]:setOpacity(255)
		end
	end)
	;(nil)[6] = cca.delay(delayTime)
	;(nil)[7] = cca.delay(delayTime)
	local seq = cca.seq(nil)
	self.Node_line:runAction(cc.RepeatForever:create(seq))
end
function masteryDetailView:showSetStarEffect()
	if not self.lastClikBuffID then
		return
	end
	local index = 1
	for i, v in ipairs(self.buffNodes) do
		if v.buffID == self.lastClikBuffID then
			index = i
			break
		end
	end
	local spriteBase = display.newSprite("#dh_zhuanjingfpx1_00.png")
	spriteBase:addTo(self.Node_center)
	spriteBase:setPosition(cc.p(0, 5))
	SoraDMixtureGLONE(spriteBase)
	spriteBase:setScale(1.15)
	local animation = display.getAnimationCache("setStarAnimation_1")
	if animation == nil then
		local frames = display.newFrames("dh_zhuanjingfpx1_0%d.png", 0, 9)
		animation = display.newAnimation(frames, 0.1)
		display.setAnimationCache("setStarAnimation_1", animation)
	end
	spriteBase:playAnimationOnce(animation, true)
	_UPVALUE1_ = true
	;(true)[1] = cca.delay(0.3)
	;(true)[2] = cca.callFunc(function()
		self.buffNodes[index]:showSetStarEffect()
	end)
	;(true)[3] = cca.callFunc(function()
		self.buffNodes[index]:showSetStarEffect()
	end)
	self.buffNodes[index]:runAction(cca.seq(true))
	local spriteBase = display.newSprite("#dh_zhuanjingfpx2_00.png")
	spriteBase:addTo(self.Node_center)
	SoraDMixtureGLONE(spriteBase)
	spriteBase:setScale(1.15)
	if index == 1 then
		spriteBase:setPosition(cc.p(-90, -20))
		spriteBase:setFlippedX(true)
	elseif index == 2 then
		spriteBase:setPosition(cc.p(90, -20))
	elseif index == 3 then
		spriteBase:setPosition(cc.p(-20, -100))
		spriteBase:setRotation(90)
	end
	local animation = display.getAnimationCache("setStarAnimation_2")
	if animation == nil then
		local frames = display.newFrames("dh_zhuanjingfpx2_%.2d.png", 0, 14)
		animation = display.newAnimation(frames, 0.05)
		display.setAnimationCache("setStarAnimation_2", animation)
	end
	spriteBase:playAnimationOnce(animation, true)
end
function masteryDetailView:showResetEffect(...)
	for i, v in ipairs(self.buffNodes) do
		v:showResetEffect()
	end
	masteryDetailSkillSingle = nil
	;(nil)[1] = cca.delay(0.2)
	;(nil)[2] = cca.callFunc(function()
		masteryDetailSkillSingle.resetSystemAllChildren(self.Node_effect_reset)
	end)
	;(nil)[3] = cca.callFunc(function()
		masteryDetailSkillSingle.resetSystemAllChildren(self.Node_effect_reset)
	end)
	self.Node_effect_reset:runAction(cca.seq(nil))
end
function masteryDetailView:gameGuide_getTarget(itemName, parameters)
	if itemName == "Button_up" then
		return self.buffNodes[1]:gameGuide_getTarget(itemName, parameters)
	elseif itemName == "Button_close" then
		return SoraDGetChildByName(self.ccs_title, "Button_close")
	end
	return nil
end
return masteryDetailView
