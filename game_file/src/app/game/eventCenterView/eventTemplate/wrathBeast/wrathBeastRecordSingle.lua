local wrathBeastRecordSingle = class("wrathBeastRecordView", function(target)
	return target
end)
function wrathBeastRecordSingle:ctor()
	self.Text_record = SoraDGetChildByName(self, "Text_record")
	self.Text_record = SoraDChangeTextToHtml(self.Text_record)
	self.Text_record:setTouchEnabled(true)
	self.Text_record:setSwallowTouches(false)
	self.Text_record:addTouchEventListener(handler(self, self.onTextEvent))
	self.Image_frame = SoraDGetChildByName(self, "Image_frame")
	self.Image_frame:setOpacity(178.5)
	self.nodeWidth = self.Image_frame:getContentSize().width
	self.nodeHeight = 0
end
function wrathBeastRecordSingle:initData(data)
	local name = data.nickName
	if data.allianceAbbr and data.allianceAbbr ~= "" then
		_ENV = nil
		;(nil).abbr = data.allianceAbbr
		;(nil).name = data.nickName
		name = i18n("common_text_186", nil)
	end
	self.beastPos = data.beastPos
	local str, icon
	local BossName = i18n(worldMapDefine.getWorldBossName(data.bossType))
	if data.eventType == gWBeastRecordType.CRIT then
		_ENV = worldMapDefine.getWorldBossName(data.bossType)
		worldMapDefine.getWorldBossName(data.bossType).name = name
		worldMapDefine.getWorldBossName(data.bossType).BossName = BossName
		_ENV = worldMapDefine.getWorldBossName(data.bossType)
		worldMapDefine.getWorldBossName(data.bossType).x = self.beastPos.x
		worldMapDefine.getWorldBossName(data.bossType).y = self.beastPos.y
		worldMapDefine.getWorldBossName(data.bossType).site = i18n("common_text_2155", worldMapDefine.getWorldBossName(data.bossType))
		_ENV, _ENV, worldMapDefine.getWorldBossName(data.bossType).damage = "common_text_2155", data.data, data.data
		;("common_text_2155").color = "#00FF00"
		;("common_text_2155").u = true
		;("common_text_2155").c = true
		_ENV, ("common_text_2155").name = worldMapDefine.getWorldBossName(data.bossType)
		_ENV, data.data.site, ("common_text_2155").param, worldMapDefine.getWorldBossName(data.bossType).x = "common_text_2155", "common_text_2155", worldMapDefine.getWorldBossName(data.bossType)
		_ENV, data.data.damage, ("common_text_2155").color = "common_text_2155", "common_text_2155", "#FFFF00"
		data.data.__default, ("common_text_2155").color = "common_text_2155", "#787878"
		str = _G.i18n_html("god_beast_text_17", worldMapDefine.getWorldBossName(data.bossType))
		_ENV = "god_beast_text_17"
		;("god_beast_text_17").param = "#icon_fight_attack.png"
		;("god_beast_text_17").width = 37.888888888888886
		;("god_beast_text_17").height = 31
		;("god_beast_text_17").offsety = 10
		;("god_beast_text_17").scale = 0.6888888888888889
		icon = SoraDWrapReplaceTag("god_beast_text_17")
	else
		local wrathBeastCtrl = SoraDGetCtrl("wrathBeastCtrl")
		local atkTypeStr = wrathBeastCtrl:getAtkTypeStr(data.eventType)
		_ENV = "common_text_2155"
		;("common_text_2155").name = name
		;("common_text_2155").BossName = BossName
		_ENV = worldMapDefine.getWorldBossName(data.bossType)
		worldMapDefine.getWorldBossName(data.bossType).x = self.beastPos.x
		worldMapDefine.getWorldBossName(data.bossType).y = self.beastPos.y
		;("common_text_2155").site = i18n("common_text_2155", worldMapDefine.getWorldBossName(data.bossType))
		;("common_text_2155").atkType = atkTypeStr
		_ENV, _ENV, ("common_text_2155").award = "god_beast_text_07", i18n("god_beast_text_07"), i18n("god_beast_text_07")
		;("god_beast_text_07").color = "#00FF00"
		;("god_beast_text_07").u = true
		;("god_beast_text_07").c = true
		_ENV, ("god_beast_text_07").name = worldMapDefine.getWorldBossName(data.bossType)
		_ENV, i18n("god_beast_text_07").site, ("god_beast_text_07").param, worldMapDefine.getWorldBossName(data.bossType).x = "god_beast_text_07", "god_beast_text_07", worldMapDefine.getWorldBossName(data.bossType)
		_ENV, i18n("god_beast_text_07").atkType, ("god_beast_text_07").color = "god_beast_text_07", "god_beast_text_07", "#FFFF00"
		_ENV, i18n("god_beast_text_07").award, ("god_beast_text_07").color = "god_beast_text_07", "god_beast_text_07", "#FFC864"
		i18n("god_beast_text_07").__default, ("god_beast_text_07").color = "god_beast_text_07", "#FFFFFF"
		str = _G.i18n_html("god_beast_text_18", "common_text_2155", (i18n("god_beast_text_07")))
		_ENV = "god_beast_text_18"
		;("god_beast_text_18").param = "#allitreas_box_01.png"
		;("god_beast_text_18").width = 34.297872340425535
		;("god_beast_text_18").height = 31
		;("god_beast_text_18").offsety = 10
		;("god_beast_text_18").scale = 0.2198581560283688
		icon = SoraDWrapReplaceTag("god_beast_text_18")
	end
	str = SoraDFIsRA() and icon .. str or str .. icon
	self.Text_record:setString(str)
	local height = SoraDGetAutoHeightLabel(self.Text_record, self.nodeWidth - 40)
	local imageH = height + 17
	self.Image_frame:setContentSize(cc.size(self.Image_frame:getContentSize().width, imageH))
	self.Text_record:setPositionY(imageH / 2)
	self.nodeHeight = imageH + 5
	if data.eventType == gWBeastRecordType.CRIT then
		self.Image_frame:setVisible(false)
	else
		self.Image_frame:setVisible(true)
	end
end
function wrathBeastRecordSingle:getNodeWidth()
	return self.nodeWidth
end
function wrathBeastRecordSingle:getNodeHeight()
	return self.nodeHeight
end
function wrathBeastRecordSingle:onTextEvent(target, event)
	if event == ccui.TouchEventType.began then
	elseif event == ccui.TouchEventType.ended then
		if self.singleIsMoved then
			self.singleIsMoved = false
			return
		end
		SoraDPlaySound()
		SoraDGotoWorldMapPoint(self.beastPos)
		SoraDRemoveAllPanelFromManager()
	elseif event == ccui.TouchEventType.moved then
		local touchBeganPoint = target:getTouchBeganPosition()
		local touchmovePoint = target:getTouchMovePosition()
		local distance = cc.pGetDistance(touchBeganPoint, touchmovePoint)
		if tonumber(distance) > TOUCH_MOVED_ERROR_VALUE then
			self.singleIsMoved = true
		end
	elseif event == ccui.TouchEventType.canceled then
		self.singleIsMoved = false
	end
end
return wrathBeastRecordSingle
