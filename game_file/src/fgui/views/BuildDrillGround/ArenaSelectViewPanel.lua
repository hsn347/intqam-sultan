local arenaCtrl = SoraDGetCtrl("arenaCtrl")
local arenaltCtrl = include("arenaltCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local ArenaSelectViewPanel = class("ArenaSelectViewPanel", baseFguiPanel)
function ArenaSelectViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("ArenaSelectViewPanel:ctor", self.viewName)
end
function ArenaSelectViewPanel:onInit()
	print("=======ArenaSelectViewPanel:onInit")
	self.fields.Com_title:initData("", handler(self, self.onClickClose), handler(self, self.showHelp))
	self.fields.List:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.List:setVirtual()
end
function ArenaSelectViewPanel:onShow()
	print("=======ArenaSelectViewPanel:onShow")
	self:req4info(self.param.battleType)
end
function ArenaSelectViewPanel:judgeGlobalChange(target, redata)
	if gArenaBattleType.AREAN_GLOBAL == self.battleType then
		self.battleInfo = arenaCtrl:getBattleInfo(self.battleType)
		if self.battleInfo.arenaStatus == gActivityState.CLOSE then
			SoraDShowMsgTip(i18n("arena_text_35"))
			self:removeFromParent()
		end
	end
end
function ArenaSelectViewPanel:reReq4Info(target, redata)
	SoraDShowMsgBox(i18n("arena_text_07"), i18n("common_text_204"), nil, nil)
	SoraDShowLoading(self:displayObject())
	self.battleInfo = arenaCtrl:getBattleInfo(self.battleType)
	arenaCtrl:req4battleGrounds(self.battleType)
end
function ArenaSelectViewPanel:req4info(battleType)
	self.battleType = battleType
	SoraDShowLoading(self:displayObject())
	self.battleInfo = arenaCtrl:getBattleInfo(self.battleType)
	dump(self.battleInfo, "weljhrwkejrhkw")
	arenaCtrl:req4battleGrounds(self.battleType)
	if self.battleType == gArenaBattleType.ARENA_LOCAL then
		self.fields.Com_title:setTitle(i18n("arena_text_01"))
	elseif self.battleType == gArenaBattleType.AREAN_GLOBAL then
		self.fields.Com_title:setTitle(i18n("arena_text_03"))
	end
end
function ArenaSelectViewPanel:initData(target, redata)
	SoraDCloseLoading(self:displayObject())
	if self.battleType == redata.battleType then
		self.blockInfo = redata.rankList
	else
		print("channel err")
		return
	end
	self:initView()
end
function ArenaSelectViewPanel:initView()
	self.blockList = arenaltCtrl.getSubSectionListByType(self.battleType)
	self.fields.List:setNumItems(#self.blockList)
	for i, v in ipairs(self.blockList) do
		if self.battleInfo.arenaGroup == v.grading then
			arenaltCtrl = nil
			;(nil).block = i18n(v.name)
			self.fields.Text_tip:setString(i18n("arena_text_06", nil))
			self.curIndex = i - 1
			break
		end
	end
	if self.curIndex then
		self.fields.List:scrollToView(self.curIndex)
	end
	local guideStep = SoraDIsGameGuide()
	if guideStep and guideStep == 46001 then
		arenaltCtrl = self.curIndex
		self.curIndex.msg = "MESSAGE_SERVER_GUIDE_STEP_ON"
		self.curIndex.step = 46002
		SoraDSendMessage(self.curIndex)
	end
end
function ArenaSelectViewPanel:onItemRenderer(index, obj)
	local data = self.blockList[index + 1]
	obj.data = data
	local _fields = obj._fields
	if not obj._fields then
		obj._fields = fguiHelper.get_fields(obj)
		_fields = obj._fields
		if not SoraDFIsRA() then
			obj:fixChildrenPos()
		end
		_fields.Button_award:addClickListener(function(...)
			SoraDPlaySound()
			local grade = obj.data.grading
			local tIndex = obj.data.index
			_ENV = nil
			;(nil).bType = self.battleType
			;(nil).blockID = grade
			;(nil).tIndex = tIndex
			uiManager:show("ArenaPriceShowView", nil)
		end)
		_fields.Load_click:addClickListener(function(...)
			SoraDPlaySound()
			local data = obj.data
			if self.battleInfo.arenaGroup == data.grading then
				_ENV = nil
				;(nil).battleType = self.battleType
				;(nil).index = data.index
				uiManager:show("ArenaMainView", nil)
				self:removeFromParent()
			else
				_ENV = nil
				;(nil).battleType = self.battleType
				;(nil).blockID = data.grading
				uiManager:show("ArenaRankView", nil)
			end
		end)
	end
	local isHit = false
	local c1 = obj:getController("c1")
	if self.battleInfo.arenaGroup == data.grading then
		isHit = true
		c1:setSelectedIndex(0)
	else
		c1:setSelectedIndex(1)
	end
	_fields.Button_award:setVisible(not isHit)
	_fields.Text_title:setString(i18n(data.name))
	local titleStr = self:transLevel(data.level[1]) .. " - " .. self:transLevel(data.level[2])
	if data.star and (0 < data.star[1] or 0 < data.star[2]) then
		_ENV = i18n(data.name)
		i18n(data.name).lv = data.star[1]
		_ENV = i18n(data.name)
		i18n(data.name).lv = data.star[2]
		titleStr = titleStr .. "\n" .. i18n("Glory_text_26", i18n(data.name)) .. " - " .. i18n("Glory_text_26", i18n(data.name))
	end
	_fields.Text_title2:setString(titleStr)
	_fields.Image_type:setURL(string.format("icon_DrillGrounds_tu%d.png", data.grading))
	local info = self.blockInfo[tostring(data.grading)]
	if info then
		local showName = arenaltCtrl.specialCreateName(info, true)
		_fields.Text_lord:setString(showName)
		_fields.Com_head:setHeadSprite(info.iconID, info.avatar)
	end
end
function ArenaSelectViewPanel:transLevel(bLevel)
	local buildLogic = include("buildLogic")
	local warLv = buildLogic.transformBuildLvToWarLv(bLevel)
	if 0 < warLv then
		_ENV = nil
		;(nil).lv = warLv
		return i18n("common_text_1948", nil)
	else
		_ENV = nil
		;(nil).lv = bLevel
		return i18n("common_text_100", nil)
	end
end
function ArenaSelectViewPanel:showHelp()
	SoraDPlaySound()
	if self.battleType == gArenaBattleType.ARENA_LOCAL then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.LOCAL_ARENA)
	elseif self.battleType == gArenaBattleType.AREAN_GLOBAL then
		userSDKManager.showSingleFAQ(gSDKDef.FAQSingleType.GLOBAL_ARENA)
	end
end
function ArenaSelectViewPanel:gameGuide_getTarget(itemName, parameters)
	if self.curIndex then
		local childIndex = self.fields.List:itemIndexToChildIndex(self.curIndex)
		local item = self.fields.List:getChildAt(childIndex)
		return item._fields.Load_click
	end
	return self.fields[itemName]
end
return ArenaSelectViewPanel
